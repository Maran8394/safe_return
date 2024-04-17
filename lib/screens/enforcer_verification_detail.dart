// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_return/blocs/enforcer/enforcer_bloc.dart';

import 'package:safe_return/models/user_data.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/utils/enums/state_enums.dart';
import 'package:safe_return/widgets/constant_widgets.dart';
import 'package:safe_return/widgets/custom_material_button.dart';
import 'package:safe_return/widgets/input_label.dart';
import 'package:safe_return/widgets/progress_dialog.dart';

class EnforcerVerificationDetail extends StatefulWidget {
  final UserData userData;
  const EnforcerVerificationDetail({
    super.key,
    required this.userData,
  });

  @override
  State<EnforcerVerificationDetail> createState() =>
      _EnforcerVerificationDetailState();
}

class _EnforcerVerificationDetailState
    extends State<EnforcerVerificationDetail> {
  String? imageCount;
  String? docCount;
  EnforcerBloc? _enforcerBloc;
  ProgressDialog? _dialog;

  @override
  void initState() {
    super.initState();
    _enforcerBloc = EnforcerBloc();
    _dialog = ProgressDialog(context);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.verified_user_outlined,
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
                    const Expanded(flex: 1, child: Text("Name")),
                    Expanded(
                      flex: 2,
                      child: Text(widget.userData.name!),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("IC")),
                    Expanded(flex: 2, child: Text(widget.userData.ic!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("Email")),
                    Expanded(flex: 2, child: Text(widget.userData.email!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("Occupation")),
                    Expanded(flex: 2, child: Text(widget.userData.occupation!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("State")),
                    Expanded(flex: 2, child: Text(widget.userData.state!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("City")),
                    Expanded(flex: 2, child: Text(widget.userData.city!)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(flex: 1, child: Text("CONTACT")),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.userData.contactNumber!,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                const RequiredInputLabel(label: "Document", isBold: true),
                SizedBox(height: size.height * 0.01),
                SizedBox(
                  height: size.height * 0.2,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.userData.docs!.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(width: size.width * 0.03),
                    itemBuilder: (context, index) {
                      String imageUrl = widget.userData.docs!.elementAt(index);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: size.height * 0.18,
                        width: size.width * 0.28,
                        child: Image.network(imageUrl),
                      );
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.1),
              ],
            ),
          ),
        ),
        floatingActionButton: BlocListener<EnforcerBloc, EnforcerState>(
          bloc: _enforcerBloc,
          listener: (context, state) {
            if (state is ChangeVerificationInitState) {
              _dialog!.showAlertDialog(Colors.blue);
            } else if (state is ChangeVerificationSuccessState) {
              _dialog!.dimissDialog();
              ConstantWidgets.showAlert(
                context,
                state.msg,
                StateType.success,
              ).then(
                (value) => Navigator.popAndPushNamed(
                  context,
                  Routes.enforcerVerificationListing,
                ),
              );
            } else if (state is ChangeVerificationFailedState) {
              _dialog!.dimissDialog();
              ConstantWidgets.showAlert(
                context,
                state.errorMessage,
                StateType.error,
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomMaterialButton(
                width: size.width * 0.35,
                text: "Accept",
                backgroundColor: Colors.green,
                fontColor: Colors.white,
                onPress: () {
                  _enforcerBloc!.add(ChangeUserVerifiedStatus(
                    status: true,
                    userId: widget.userData.uId!,
                  ));
                },
              ),
              SizedBox(width: size.width * 0.1),
              CustomMaterialButton(
                width: size.width * 0.35,
                text: "Reject",
                backgroundColor: Colors.red,
                fontColor: Colors.white,
                onPress: () {
                  _enforcerBloc!.add(ChangeUserVerifiedStatus(
                    status: false,
                    userId: widget.userData.uId!,
                  ));
                },
              ),
            ],
          ),
        ));
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
