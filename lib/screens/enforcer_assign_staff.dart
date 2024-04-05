// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_return/blocs/enforcer/enforcer_bloc.dart';

import 'package:safe_return/models/case_model.dart';
import 'package:safe_return/models/enforcer_profile_model.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/utils/enums/state_enums.dart';
import 'package:safe_return/widgets/constant_widgets.dart';
import 'package:safe_return/widgets/custom_material_button.dart';
import 'package:safe_return/widgets/input_label.dart';
import 'package:safe_return/widgets/progress_dialog.dart';

class EnforcerAssignStaff extends StatefulWidget {
  final CaseModel caseModel;
  const EnforcerAssignStaff({
    super.key,
    required this.caseModel,
  });

  @override
  State<EnforcerAssignStaff> createState() => _EnforcerAssignStaffState();
}

class _EnforcerAssignStaffState extends State<EnforcerAssignStaff> {
  EnforcerBloc? _enforcerBloc;
  ProgressDialog? _dialog;
  String? imageCount;
  String? docCount;
  String? staff;

  @override
  void initState() {
    super.initState();
    _enforcerBloc = EnforcerBloc();
    _dialog = ProgressDialog(context);
    if (widget.caseModel.enforcers != null &&
        widget.caseModel.enforcers!.isNotEmpty) {
      setState(() {
        staff = widget.caseModel.enforcers!.first;
      });
    }
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
          "Safe Return".toUpperCase(),
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocListener<EnforcerBloc, EnforcerState>(
          bloc: _enforcerBloc,
          listener: (context, state) {
            if (state is AssignStaffInitState) {
              _dialog!.showAlertDialog(Colors.blue);
            } else if (state is AssignStaffSuccessState) {
              _dialog!.dimissDialog();
              ConstantWidgets.showAlert(
                context,
                "Assigned",
                StateType.success,
              ).then(
                (value) => Navigator.popAndPushNamed(
                  context,
                  Routes.caseList,
                ),
              );
            } else if (state is AssignStaffFailedState) {
              _dialog!.dimissDialog();
              ConstantWidgets.showAlert(
                context,
                state.errorMessage,
                StateType.error,
              );
            }
          },
          child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.group_add_outlined,
                        size: 30,
                      ),
                      SizedBox(width: size.width * 0.04),
                      Text(
                        "Verfication",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("Case Id")),
                    Expanded(flex: 2, child: Text(widget.caseModel.caseId!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("Name")),
                    Expanded(flex: 2, child: Text(widget.caseModel.name!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("Age")),
                    Expanded(flex: 2, child: Text(widget.caseModel.age!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("Race")),
                    Expanded(flex: 2, child: Text(widget.caseModel.race!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("Height")),
                    Expanded(flex: 2, child: Text(widget.caseModel.height!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("Weight")),
                    Expanded(flex: 2, child: Text(widget.caseModel.weight!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("Hair color")),
                    Expanded(flex: 2, child: Text(widget.caseModel.hairColor!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("Eye color")),
                    Expanded(flex: 2, child: Text(widget.caseModel.eyeColor!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                        flex: 1, child: Text("Date of last Contact")),
                    Expanded(
                        flex: 2,
                        child: Text(widget.caseModel.dateOfLastContact!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                        flex: 1, child: Text("Circumstances of disappearance")),
                    Expanded(
                        flex: 2,
                        child: Text(
                            widget.caseModel.circumstancesOfDisappearance!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("Description")),
                    Expanded(
                        flex: 2, child: Text(widget.caseModel.description!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("City")),
                    Expanded(flex: 2, child: Text(widget.caseModel.city!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("State")),
                    Expanded(flex: 2, child: Text(widget.caseModel.state!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("Country")),
                    Expanded(flex: 2, child: Text(widget.caseModel.country!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("Zip Code")),
                    Expanded(flex: 2, child: Text(widget.caseModel.zipCode!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                if (widget.caseModel.images!.isNotEmpty) ...[
                  const RequiredInputLabel(
                      label: "Victim Details", isBold: true),
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    height: size.height * 0.2,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.caseModel.images!.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: size.width * 0.03),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: size.height * 0.18,
                          width: size.width * 0.28,
                          child: const FlutterLogo(),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                ],
                const RequiredInputLabel(label: "Assign Staff", isBold: true),
                FutureBuilder(
                    future:
                        FirebaseFirestore.instance.collection("enforcer").get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(snapshot.error.toString()),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        final enforcerModel = snapshot.data!.docs.map((doc) {
                          return EnforcerProfileModel.fromMap(doc.data());
                        }).toList();

                        return Container(
                          height: size.height * 0.06,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              menuMaxHeight: size.height * 0.45,
                              value: staff,
                              items: enforcerModel
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.id,
                                      child: Text(e.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (widget.caseModel.enforcers == null ||
                                    widget.caseModel.enforcers!.isEmpty) {
                                  setState(() {
                                    staff = value;
                                  });
                                }
                              },
                            ),
                          ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text("Something is wrong!"),
                          ),
                        );
                      }
                    }),
                SizedBox(height: size.height * 0.04),
                if (widget.caseModel.enforcers != null &&
                    widget.caseModel.enforcers!.isNotEmpty) ...[
                  CustomMaterialButton(
                    width: size.width * 0.8,
                    height: size.height * 0.06,
                    text: "Assigned",
                    backgroundColor: Colors.green.withOpacity(0.7),
                    fontColor: Colors.white,
                    onPress: () {},
                  )
                ] else ...[
                  CustomMaterialButton(
                    width: size.width * 0.8,
                    height: size.height * 0.06,
                    text: "Submit",
                    backgroundColor: Colors.green,
                    fontColor: Colors.white,
                    onPress: () {
                      if (staff != null) {
                        _enforcerBloc!.add(
                          AssignStaffEvent(
                            caseId: widget.caseModel.caseId!,
                            enforcerId: staff!,
                          ),
                        );
                      } else {
                        ConstantWidgets.showAlert(
                          context,
                          "select any staff",
                          StateType.warning,
                        );
                      }
                    },
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UploadField extends StatelessWidget {
  const UploadField({
    super.key,
    required this.size,
    this.onTap,
    required this.icon,
    required this.count,
  });

  final Size size;
  final Function()? onTap;
  final IconData icon;
  final String? count;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        width: size.width * 0.25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              icon,
              size: 30,
            ),
            Text(
              (count != null) ? "($count)" : "-",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
