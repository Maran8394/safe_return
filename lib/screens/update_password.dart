// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_return/blocs/public/public_bloc.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/repo/user_repo.dart';
import 'package:safe_return/utils/enums/state_enums.dart';
import 'package:safe_return/widgets/constant_widgets.dart';
import 'package:safe_return/widgets/custom_material_button.dart';
import 'package:safe_return/widgets/input_label.dart';
import 'package:safe_return/widgets/input_widget.dart';
import 'package:safe_return/widgets/progress_dialog.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  PublicBloc? _publicBloc;
  FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  ProgressDialog? dialog;

  bool terms = true;
  final TextEditingController _oldpwd = TextEditingController();
  final TextEditingController _newpwd = TextEditingController();
  final TextEditingController _confirmpwd = TextEditingController();

  String? choosedState;
  final TextEditingController _city = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    dialog = ProgressDialog(context);
    _publicBloc = PublicBloc();
  }

  @override
  void dispose() {
    _oldpwd.dispose();
    _newpwd.dispose();
    _confirmpwd.dispose();
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
          "Safe REturn".toUpperCase(),
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: BlocListener<PublicBloc, PublicState>(
            bloc: _publicBloc,
            listener: (context, state) async {
              if (state is UpdatePasswordInitState) {
                dialog!.showAlertDialog(Colors.blue);
              }
              if (state is UpdatePasswordFailedState) {
                dialog!.dimissDialog();
                ConstantWidgets.showAlert(
                  context,
                  state.errorMessage,
                  StateType.error,
                );
              }
              if (state is UpdatePasswordSuccessState) {
                dialog!.dimissDialog();
                ConstantWidgets.showAlert(
                  context,
                  state.successMessage,
                  StateType.success,
                ).then((value) async {
                  UserRepo userRepo = UserRepo();
                  await userRepo.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.indexPage,
                    (route) => false,
                  );
                });
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.admin_panel_settings_outlined,
                          size: 30,
                        ),
                        SizedBox(width: size.width * 0.04),
                        Text(
                          "Update Password",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  const RequiredInputLabel(
                    label: "Old Password",
                    isRequired: true,
                  ),
                  InputWidget(
                    isRequired: true,
                    maxLines: 1,
                    obsecureText: true,
                    controller: _oldpwd,
                  ),
                  SizedBox(height: size.height * 0.02),
                  const RequiredInputLabel(
                    label: "New Password",
                    isRequired: true,
                  ),
                  InputWidget(
                    isRequired: true,
                    maxLines: 1,
                    obsecureText: true,
                    controller: _newpwd,
                  ),
                  SizedBox(height: size.height * 0.02),
                  const RequiredInputLabel(
                    label: "Confirm Password",
                    isRequired: true,
                  ),
                  InputWidget(
                    isRequired: true,
                    maxLines: 1,
                    obsecureText: true,
                    controller: _confirmpwd,
                  ),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomMaterialButton(
        width: size.width * 0.8,
        height: size.height * 0.06,
        text: "Update",
        backgroundColor: Colors.green,
        fontColor: Colors.white,
        onPress: () {
          if (_formKey.currentState!.validate()) {
            if (_newpwd.text == _confirmpwd.text) {
              _publicBloc!.add(
                UpdatePasswordEvent(
                  oldPassword: _oldpwd.text,
                  newPassword: _newpwd.text,
                ),
              );
            } else {
              ConstantWidgets.showAlert(
                context,
                "Passwords not matched",
                StateType.error,
              );
            }
          }
        },
      ),
    );
  }
}
