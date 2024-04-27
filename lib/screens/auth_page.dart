// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safe_return/blocs/public/public_bloc.dart';

import 'package:safe_return/paths/asset_paths.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/repo/user_repo.dart';
import 'package:safe_return/utils/enums/state_enums.dart';
import 'package:safe_return/widgets/constant_widgets.dart';
import 'package:safe_return/widgets/custom_material_button.dart';
import 'package:safe_return/widgets/input_widget.dart';
import 'package:safe_return/widgets/progress_dialog.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  PublicBloc? _publicBloc;
  ProgressDialog? _dialog;
  FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  bool isPublic = true;
  bool isEnforcer = false;

  final TextEditingController _userId = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _forgotPasswordEmail = TextEditingController();

  // final CollectionReference _collectionRef =
  //     FirebaseFirestore.instance.collection('post_code');

  @override
  void initState() {
    super.initState();
    _publicBloc = PublicBloc();
    _dialog = ProgressDialog(context);
    // _uploadCSVToFirestore();
  }

  // Future<void> _uploadCSVToFirestore() async {
  //   String csvData =
  //       await rootBundle.loadString('assets/images/my_postcode.csv');

  //   List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);

  //   for (List<dynamic> row in rows) {
  //     String postcode = row[0].toString();
  //     String postOffice = row[1].toString();
  //     String stateName = row[2].toString();
  //     // Create a map of data to upload to Firestore
  //     Map<String, dynamic> data = {
  //       'postcode': postcode,
  //       'city': postOffice,
  //       'state_name': stateName,
  //     };

  //     // Add data to Firestore
  //     await _collectionRef.add(data);
  //     print("ADDED");
  //   }
  //   print("FINISHED");
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: BlocListener<PublicBloc, PublicState>(
          bloc: _publicBloc,
          listener: (context, state) async {
            if (state is LoginInitiated) {
              _dialog!.showAlertDialog(Colors.blue);
            }
            if (state is LoginSuccessState) {
              _dialog!.dimissDialog();
              UserRepo userRepo = UserRepo();
              String? userType = await userRepo.getUserAttrData("userType");

              if (userType == "public") {
                _firebaseMessaging.getToken().then((token) async {
                  print(token);
                  UserRepo repo = UserRepo();
                  repo.updateUserData({"deviceId": token!});
                });
                Navigator.pushNamed(
                  context,
                  Routes.publicDashboard,
                );
              } else {
                Navigator.pushNamed(
                  context,
                  Routes.enforcerDashboard,
                );
              }
            }
            if (state is LoginFailedState) {
              _dialog!.dimissDialog();
              ConstantWidgets.showAlert(
                context,
                state.errorMessage,
                StateType.error,
              );
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.06),
                Text(
                  "safe return".toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    PictureCard(
                      isActive: isPublic,
                      size: size,
                      imagePath: AssetPath.public,
                      onTap: () {
                        setState(() {
                          isPublic = true;
                          isEnforcer = false;
                        });
                      },
                    ),
                    PictureCard(
                      isActive: isEnforcer,
                      size: size,
                      imagePath: AssetPath.enforcer,
                      onTap: () {
                        setState(() {
                          isPublic = false;
                          isEnforcer = true;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (isPublic)
                        RichText(
                          text: TextSpan(
                            text: "Dont Have an account? ",
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: "Create now",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.cyanAccent.shade700,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.publicRegistration,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: size.height * 0.02),
                      InputWidget(
                        prefixIcon: const Icon(Icons.email),
                        hintText: "Email",
                        controller: _email,
                        isRequired: true,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: size.height * 0.01),
                      InputWidget(
                        prefixIcon: const Icon(Icons.lock),
                        maxLines: 1,
                        hintText: "Password",
                        obsecureText: true,
                        controller: _password,
                        isRequired: true,
                      ),
                      SizedBox(height: size.height * 0.02),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog.adaptive(
                                title: const Center(
                                    child: Text("Forgot Password")),
                                content: InputWidget(
                                  keyboardType: TextInputType.emailAddress,
                                  hintText: "Email",
                                  controller: _forgotPasswordEmail,
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (_forgotPasswordEmail
                                          .text.isNotEmpty) {
                                        try {
                                          await FirebaseAuth.instance
                                              .sendPasswordResetEmail(
                                            email: _forgotPasswordEmail.text,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Password reset email sent",
                                              ),
                                            ),
                                          );
                                          Navigator.pop(context);
                                        } catch (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Error: ${error.toString()}",
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text("Email is required"),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text("Submit"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot password?",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.cyanAccent.shade700,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      if (isPublic)
                        Text(
                          "To add new missing case required to login into Safe Return",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                CustomMaterialButton(
                  backgroundColor: Colors.green,
                  fontColor: Colors.white,
                  width: size.width * 0.5,
                  height: size.height * 0.06,
                  text: "Login",
                  onPress: () async {
                    if (_formKey.currentState!.validate()) {
                      if (isPublic) {
                        _publicBloc!.add(
                          LoginEvent(
                              email: _email.text.trim(),
                              userId: _userId.text.trim(),
                              password: _password.text.trim(),
                              userType:
                                  (isPublic == true) ? "public" : "enforcer"),
                        );
                      } else {
                        _publicBloc!.add(
                          LoginEvent(
                            email: _email.text.trim(),
                            password: _password.text.trim(),
                            userType: "enforcer",
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PictureCard extends StatelessWidget {
  const PictureCard({
    super.key,
    required this.size,
    this.onTap,
    required this.imagePath,
    required this.isActive,
  });

  final Size size;
  final Function()? onTap;
  final String imagePath;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: (isActive) ? 15 : 0,
        borderOnForeground: false,
        child: Container(
          padding: const EdgeInsets.only(
            right: 18,
            left: 10,
            bottom: 10,
            top: 10,
          ),
          decoration: BoxDecoration(
              color: (!isActive) ? Colors.white : Colors.grey.shade100,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              )),
          child: SvgPicture.asset(
            imagePath,
            height: size.height * 0.15,
          ),
        ),
      ),
    );
  }
}
