// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_return/blocs/public/public_bloc.dart';
import 'package:safe_return/cubits/postCode/post_code_cubit.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/repo/user_repo.dart';
import 'package:safe_return/screens/case_list.dart';
import 'package:safe_return/screens/indexing_page.dart';
import 'package:safe_return/utils/enums/state_enums.dart';
import 'package:safe_return/widgets/auto_suggestion_dropdown.dart';
import 'package:safe_return/widgets/constant_widgets.dart';
import 'package:safe_return/widgets/custom_material_button.dart';
import 'package:safe_return/widgets/input_label.dart';
import 'package:safe_return/widgets/input_widget.dart';
import 'package:safe_return/widgets/progress_dialog.dart';

class PublicRegistration extends StatefulWidget {
  const PublicRegistration({super.key});

  @override
  State<PublicRegistration> createState() => _PublicRegistrationState();
}

class _PublicRegistrationState extends State<PublicRegistration> {
  PublicBloc? _publicBloc;
  PostCodeCubit? _postCodeCubit;
  UserRepo? _userRepo;
  FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  ProgressDialog? dialog;
  List<String> selectedDocPaths = [];
  bool terms = true;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _ic = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _occupation = TextEditingController();
  String? choosedState;
  final TextEditingController _city = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    dialog = ProgressDialog(context);
    _publicBloc = PublicBloc();
    _postCodeCubit = PostCodeCubit();
    _userRepo = UserRepo();
    _postCodeCubit!.fetchPostCodes();
  }

  @override
  void dispose() {
    _name.dispose();
    _ic.dispose();
    _email.dispose();
    _occupation.dispose();
    _city.dispose();
    _contactNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Text(
          "SAFE RETURN",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: BlocListener<PublicBloc, PublicState>(
            bloc: _publicBloc,
            listener: (context, state) {
              if (state is RegisterationInitiatedState) {
                dialog!.showAlertDialog(Colors.blue);
              }
              if (state is RegisterationFailedState) {
                dialog!.dimissDialog();
                ConstantWidgets.showAlert(
                  context,
                  state.errorMessage,
                  StateType.error,
                );
              }
              if (state is RegisterationSuccessState) {
                dialog!.dimissDialog();
                ConstantWidgets.showAlert(
                  context,
                  state.successMessage,
                  StateType.success,
                ).then((value) {
                  Navigator.popAndPushNamed(
                    context,
                    Routes.indexPage,
                    arguments: IndexingPage(index: 1),
                  );
                });
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Registration",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.indigoAccent,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  // Fields Start
                  const RequiredInputLabel(
                    label: "Name",
                    isRequired: true,
                  ),
                  InputWidget(
                    controller: _name,
                    isRequired: true,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    maxLength: 20,
                    textOnly: true,
                  ),
                  SizedBox(height: size.height * 0.02),

                  const RequiredInputLabel(
                    label: "IC",
                    isRequired: true,
                  ),
                  InputWidget(
                    controller: _ic,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    maxLength: 12,
                    maxLines: 1,
                  ),
                  SizedBox(height: size.height * 0.02),

                  const RequiredInputLabel(
                    label: "Email",
                    isRequired: true,
                  ),
                  InputWidget(
                    controller: _email,
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: size.height * 0.02),

                  const RequiredInputLabel(
                    label: "Occupation",
                    isRequired: true,
                  ),
                  InputWidget(
                    controller: _occupation,
                    isRequired: true,
                    keyboardType: TextInputType.text,
                    textOnly: true,
                  ),
                  SizedBox(height: size.height * 0.02),
                  const RequiredInputLabel(
                    label: "Zip Code",
                    isRequired: true,
                  ),
                  BlocBuilder<PostCodeCubit, PostCodeState>(
                    bloc: _postCodeCubit,
                    builder: (context, state) {
                      if (state is PostCodeInitialState) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      if (state is PostCodeSuccessState) {
                        List<String> codes = [];
                        codes = state.codes;
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: AutoSuggestDropDown(
                            textInputType: TextInputType.number,
                            hintText: "",
                            options: codes,
                            maxLength: 5,
                            optionsBuilder:
                                (TextEditingValue textEditingValue) async {
                              List<String> fetchedCodes =
                                  await _userRepo!.fetchPostCodes(
                                val: textEditingValue.text,
                              );
                              codes.clear();
                              codes = fetchedCodes;
                              return codes;
                            },
                            onChanged: (val) {
                              codes.clear();
                              _postCodeCubit!.fetchPostCodes(
                                val: val.toString(),
                              );
                            },
                            onSelected: (String selection) async {
                              Map<String, dynamic>? object = await _userRepo!
                                  .getObjectByPostcodeAndAreaName(selection);
                              _city.text = object!["city"];
                              _stateController.text = object["state_name"];
                              _zipCodeController.text = selection;
                            },
                          ),
                        );
                      }
                      if (state is PostCodeFailedState) {
                        return Center(
                          child: Text(state.message),
                        );
                      } else {
                        return const Center(
                          child: Text("Unknown error"),
                        );
                      }
                    },
                  ),

                  const RequiredInputLabel(
                    label: "State",
                    isRequired: true,
                  ),
                  InputWidget(
                    controller: _stateController,
                    isRequired: true,
                    readOnly: true,
                  ),
                  SizedBox(height: size.height * 0.02),

                  const RequiredInputLabel(
                    label: "City",
                    isRequired: true,
                  ),
                  InputWidget(
                    controller: _city,
                    isRequired: true,
                    readOnly: true,
                  ),
                  SizedBox(height: size.height * 0.02),

                  const RequiredInputLabel(
                    label: "Contact Number",
                    isRequired: true,
                  ),
                  InputWidget(
                    controller: _contactNumber,
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    maxLines: 1,
                  ),
                  SizedBox(height: size.height * 0.02),

                  const RequiredInputLabel(
                    label: "Password",
                    isRequired: true,
                  ),
                  InputWidget(
                    controller: _password,
                    isRequired: true,
                    obsecureText: true,
                    maxLines: 1,
                    maxLength: 20,
                  ),
                  SizedBox(height: size.height * 0.02),
                  UploadField(
                    icon: Icons.image_outlined,
                    size: size,
                    count: "IC",
                    onTap: () async {
                      var status = await Permission.storage.status;
                      if (status == PermissionStatus.granted) {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.image,
                        );
                        if (result != null) {
                          List<String> paths =
                              result.paths.map((path) => path!).toList();
                          setState(() {
                            selectedDocPaths.addAll(paths);
                          });
                        }
                      } else if (status == PermissionStatus.permanentlyDenied) {
                        openAppSettings();
                      } else {
                        ConstantWidgets.showAlert(
                          context,
                          "Storage Access Required",
                          StateType.error,
                        );
                        await Future.delayed(
                          const Duration(seconds: 2),
                        );
                        await Permission.storage.request();
                      }
                    },
                  ),
                  SizedBox(height: size.height * 0.02),
                  CheckboxListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: const Text("Agree to terms and conditions"),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: terms,
                    onChanged: (val) {
                      setState(() {
                        terms = val!;
                      });
                    },
                  ),

                  SizedBox(height: size.height * 0.02),

                  Center(
                    child: CustomMaterialButton(
                      width: size.width * 0.5,
                      height: size.height * 0.06,
                      backgroundColor: Colors.green,
                      fontColor: Colors.white,
                      text: "REGISTER",
                      onPress: () async {
                        if (_formKey.currentState!.validate()) {
                          if (!terms) {
                            ConstantWidgets.showAlert(
                              context,
                              "Please accept the terms and conditions",
                              StateType.warning,
                            );
                          } else {
                            if (selectedDocPaths.isNotEmpty) {
                              UserRepo userRepo = UserRepo();
                              dialog!.showAlertDialog(Colors.blue);
                              final documents = await userRepo.uploadFiles(
                                selectedDocPaths,
                                'documents',
                              );

                              dialog!.dimissDialog();
                              _publicBloc!.add(
                                RegisterEvent(
                                  name: _name.text.trim(),
                                  ic: _ic.text.trim(),
                                  email: _email.text.trim(),
                                  password: _password.text.trim(),
                                  occupation: _occupation.text.trim(),
                                  state: _stateController.text.trim(),
                                  city: _city.text.trim(),
                                  zipCode: _zipCodeController.text,
                                  contactNumber: _contactNumber.text.trim(),
                                  uploadedFiles: documents,
                                ),
                              );
                            } else {
                              ConstantWidgets.showAlert(
                                context,
                                "Upload any govt authorized file",
                                StateType.warning,
                              );
                            }
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
