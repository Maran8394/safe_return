// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_return/blocs/public/public_bloc.dart';
import 'package:safe_return/models/user_data.dart';
import 'package:safe_return/paths/routes.dart';

import 'package:safe_return/utils/constants/states_list.dart';
import 'package:safe_return/utils/enums/state_enums.dart';
import 'package:safe_return/widgets/constant_widgets.dart';
import 'package:safe_return/widgets/custom_material_button.dart';
import 'package:safe_return/widgets/input_label.dart';
import 'package:safe_return/widgets/input_widget.dart';
import 'package:safe_return/widgets/progress_dialog.dart';

class PublicRegistrationEdit extends StatefulWidget {
  final UserData userData;
  const PublicRegistrationEdit({
    super.key,
    required this.userData,
  });

  @override
  State<PublicRegistrationEdit> createState() => _PublicRegistrationEditState();
}

class _PublicRegistrationEditState extends State<PublicRegistrationEdit> {
  PublicBloc? _publicBloc;
  FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  ProgressDialog? dialog;

  bool terms = true;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _ic = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _occupation = TextEditingController();
  String? choosedState;
  final TextEditingController _city = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    dialog = ProgressDialog(context);
    _publicBloc = PublicBloc();
    setState(() {
      _name.text = widget.userData.name!;
      _ic.text = widget.userData.ic!;
      _email.text = widget.userData.email!;
      _occupation.text = widget.userData.occupation!;
      _city.text = widget.userData.city!;
      _contactNumber.text = widget.userData.contactNumber!;
      choosedState = widget.userData.state!;
    });
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
              if (state is UpdateInitState) {
                dialog!.showAlertDialog(Colors.blue);
              }
              if (state is UpdateFailedState) {
                dialog!.dimissDialog();
                ConstantWidgets.showAlert(
                  context,
                  state.errorMessage,
                  StateType.error,
                );
              }
              if (state is UpdateSuccessState) {
                dialog!.dimissDialog();
                ConstantWidgets.showAlert(
                  context,
                  state.successMessage,
                  StateType.success,
                ).then((value) {
                  Navigator.popAndPushNamed(
                    context,
                    Routes.publicDashboard,
                  );
                });
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fields Start
                  const RequiredInputLabel(
                    label: "Name",
                    isRequired: true,
                  ),
                  InputWidget(
                    controller: _name,
                    isRequired: true,
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
                    readOnly: true,
                  ),
                  SizedBox(height: size.height * 0.02),

                  const RequiredInputLabel(
                    label: "Occupation",
                    isRequired: true,
                  ),
                  InputWidget(
                    controller: _occupation,
                    isRequired: true,
                  ),
                  SizedBox(height: size.height * 0.02),

                  const RequiredInputLabel(
                    label: "State",
                    isRequired: true,
                  ),
                  Container(
                    height: size.height * 0.07,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        menuMaxHeight: size.height * 0.25,
                        value: MalaysiaStates.states.first.toLowerCase(),
                        items: MalaysiaStates.states
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.toLowerCase(),
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            choosedState = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  const RequiredInputLabel(
                    label: "City",
                    isRequired: true,
                  ),
                  InputWidget(
                    controller: _city,
                    isRequired: true,
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
                  ),
                  SizedBox(height: size.height * 0.02),

                  Center(
                    child: CustomMaterialButton(
                        width: size.width * 0.5,
                        height: size.height * 0.06,
                        backgroundColor: Colors.green,
                        fontColor: Colors.white,
                        text: "Update",
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            _publicBloc!.add(
                              UpdateEvent(
                                name: _name.text.trim(),
                                email: _email.text.trim(),
                                ic: _ic.text.trim(),
                                occupation: _occupation.text.trim(),
                                state: choosedState!,
                                city: _city.text.trim(),
                                contactNumber: _contactNumber.text.trim(),
                              ),
                            );
                          }
                        }),
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
