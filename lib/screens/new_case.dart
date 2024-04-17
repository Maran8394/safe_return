// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_return/blocs/public/public_bloc.dart';
import 'package:safe_return/cubits/postCode/post_code_cubit.dart';
import 'package:safe_return/repo/user_repo.dart';
import 'package:safe_return/utils/constants/dropdown_values.dart';
import 'package:safe_return/utils/custom_methods.dart';
import 'package:safe_return/utils/enums/state_enums.dart';
import 'package:safe_return/widgets/auto_suggestion_dropdown.dart';
import 'package:safe_return/widgets/constant_widgets.dart';
import 'package:safe_return/widgets/custom_material_button.dart';

import 'package:safe_return/widgets/input_label.dart';
import 'package:safe_return/widgets/input_widget.dart';
import 'package:safe_return/widgets/progress_dialog.dart';

class NewCase extends StatefulWidget {
  const NewCase({super.key});

  @override
  State<NewCase> createState() => _NewCaseState();
}

class _NewCaseState extends State<NewCase> {
  PublicBloc? _publicBloc;
  UserRepo? _userRepo;
  PostCodeCubit? _postCodeCubit;
  ProgressDialog? dialog;
  final _formKey = GlobalKey<FormState>();
  String? imageCount;
  String? docCount;
  String? hairColor;
  String? race;
  String? eyeColor;
  String? country;
  String? state;
  List<String> selectedImagePaths = [];
  List<String> selectedDocPaths = [];
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController circumstancesController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List zipCodeOptions = [];
  bool? loader;
  @override
  void initState() {
    super.initState();

    dialog = ProgressDialog(context);
    _userRepo = UserRepo();
    _publicBloc = PublicBloc();
    _postCodeCubit = PostCodeCubit();

    _postCodeCubit!.fetchPostCodes();
    setState(() {
      country = "malaysia";
      state = "kuala lumpur";
      hairColor = "black";
      eyeColor = "black";
      race = "malay";
    });
  }

  @override
  void dispose() {
    dateController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    circumstancesController.dispose();
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    descriptionController.dispose();
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
          "New Case",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: (loader != true)
            ? Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: BlocListener<PublicBloc, PublicState>(
                    bloc: _publicBloc,
                    listener: (context, state) {
                      if (state is NewCaseInitState) {
                        dialog!.showAlertDialog(Colors.blue);
                      }
                      if (state is NewCaseFailedState) {
                        dialog!.dimissDialog();
                        ConstantWidgets.showAlert(
                          context,
                          state.errorMessage,
                          StateType.error,
                        );
                      }
                      if (state is NewCaseSuccessState) {
                        dialog!.dimissDialog();
                        ConstantWidgets.showAlert(
                          context,
                          state.message,
                          StateType.success,
                        ).then((value) {
                          Navigator.pop(context);
                        });
                        _userRepo!.getUserDeviceId(
                          nameController.text,
                          stateController.text,
                        );
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Circumstances",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Row(
                          children: [
                            const Expanded(
                                flex: 1, child: Text("Date of last contact")),
                            Expanded(
                              flex: 3,
                              child: InputWidget(
                                controller: dateController,
                                onTap: () async {
                                  String? fromDate = await datePicker(
                                    context,
                                    initalDate: DateTime.now(),
                                  );
                                  if (fromDate != null) {
                                    var formatedData = DateFormat("dd-MM-yyyy")
                                        .format(DateTime.parse(fromDate));
                                    setState(() =>
                                        dateController.text = formatedData);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.04),
                        Text(
                          "Last Known Location",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Zip Code")),
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
                                  return Expanded(
                                    flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: AutoSuggestDropDown(
                                        textInputType: TextInputType.number,
                                        hintText: "Zip Code",
                                        options: codes,
                                        maxLength: 5,
                                        optionsBuilder: (TextEditingValue
                                            textEditingValue) async {
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
                                          List<String> splitted =
                                              (selection.split("-"));
                                          Map<String, dynamic>? object =
                                              await _userRepo!
                                                  .getObjectByPostcodeAndAreaName(
                                                      splitted.first,
                                                      splitted.last);
                                          cityController.text = object!["city"];
                                          stateController.text =
                                              object["state_name"];
                                          zipCodeController.text =
                                              splitted.first;
                                        },
                                      ),
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
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("City")),
                            Expanded(
                              flex: 3,
                              child: InputWidget(
                                controller: cityController,
                                isRequired: true,
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),

                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("State")),
                            Expanded(
                              flex: 3,
                              child: InputWidget(
                                controller: stateController,
                                isRequired: true,
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                        // Container(
                        //   height: size.height * 0.06,
                        //   width: size.width,
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(10),
                        //     border: Border.all(
                        //       color: Colors.grey.shade300,
                        //     ),
                        //   ),
                        //   child: DropdownButtonHideUnderline(
                        //     child: DropdownButton(
                        //       padding:
                        //           const EdgeInsets.symmetric(horizontal: 10),
                        //       menuMaxHeight: size.height * 0.25,
                        //       value: state,
                        //       items: MalaysiaStates.states
                        //           .map(
                        //             (e) => DropdownMenuItem(
                        //               value: e.toLowerCase(),
                        //               child: Text(e),
                        //             ),
                        //           )
                        //           .toList(),
                        //       onChanged: (value) async {
                        //         if (value != null) {
                        //           setState(() {
                        //             state = value;
                        //           });
                        //         }
                        //       },
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: size.height * 0.02),
                        // const RequiredInputLabel(label: "Country"),
                        // SizedBox(height: size.height * 0.01),
                        // Container(
                        //   height: size.height * 0.06,
                        //   width: size.width,
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(10),
                        //     border: Border.all(
                        //       color: Colors.grey.shade300,
                        //     ),
                        //   ),
                        //   child: DropdownButtonHideUnderline(
                        //     child: DropdownButton(
                        //       alignment: AlignmentDirectional.centerStart,
                        //       padding: const EdgeInsets.symmetric(horizontal: 8),
                        //       menuMaxHeight: size.height * 0.45,
                        //       value: country,
                        //       items: DropDownValues.countries
                        //           .map(
                        //             (e) => DropdownMenuItem(
                        //               value: e.toLowerCase(),
                        //               child: Text(e),
                        //             ),
                        //           )
                        //           .toList(),
                        //       onChanged: (value) {
                        //         setState(() {
                        //           country = value!;
                        //         });
                        //       },
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: size.height * 0.02),
                        const RequiredInputLabel(
                          label: "Circumstances of disapperance",
                        ),
                        SizedBox(height: size.height * 0.01),
                        InputWidget(
                          maxLines: 4,
                          controller: circumstancesController,
                          isRequired: true,
                        ),
                        SizedBox(height: size.height * 0.04),
                        Text(
                          "Victim Info",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Name")),
                            Expanded(
                              flex: 3,
                              child: InputWidget(
                                controller: nameController,
                                isRequired: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Age")),
                            Expanded(
                              flex: 1,
                              child: InputWidget(
                                keyboardType: TextInputType.number,
                                controller: ageController,
                                isRequired: true,
                              ),
                            ),
                            SizedBox(width: size.width * 0.1),
                            const Expanded(flex: 1, child: Text("Race")),
                            Container(
                              height: size.height * 0.06,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  menuMaxHeight: size.height * 0.45,
                                  value: race,
                                  items: DropDownValues.race
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.toLowerCase(),
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      hairColor = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text("Height")),
                            Expanded(
                              flex: 1,
                              child: InputWidget(
                                keyboardType: TextInputType.number,
                                controller: heightController,
                                isRequired: true,
                                hintText: "CM",
                              ),
                            ),
                            SizedBox(width: size.width * 0.1),
                            const Expanded(flex: 1, child: Text("Weight")),
                            Expanded(
                              flex: 1,
                              child: InputWidget(
                                keyboardType: TextInputType.number,
                                controller: weightController,
                                isRequired: true,
                                hintText: "KG",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        const RequiredInputLabel(label: "Hair Color"),
                        Container(
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
                              value: hairColor,
                              items: DropDownValues.hairColors
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.toLowerCase(),
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  hairColor = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        const RequiredInputLabel(label: "Eye Color"),
                        Container(
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
                              value: eyeColor,
                              items: DropDownValues.eyeColors
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.toLowerCase(),
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  eyeColor = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        const RequiredInputLabel(label: "Description"),
                        SizedBox(height: size.height * 0.01),
                        InputWidget(
                          maxLines: 4,
                          controller: descriptionController,
                          isRequired: true,
                        ),
                        SizedBox(height: size.height * 0.02),
                        const RequiredInputLabel(
                            label: "Upload picture and document"),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            UploadField(
                              icon: Icons.image_outlined,
                              size: size,
                              count: imageCount,
                              onTap: () async {
                                var status = await Permission.storage.status;
                                if (status == PermissionStatus.granted) {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    allowMultiple: true,
                                    type: FileType.image,
                                  );
                                  if (result != null) {
                                    List<String> paths = result.paths
                                        .map((path) => path!)
                                        .toList();
                                    setState(() {
                                      imageCount = result.count.toString();
                                      selectedImagePaths.addAll(paths);
                                    });
                                  }
                                } else if (status ==
                                    PermissionStatus.permanentlyDenied) {
                                  await openAppSettings();
                                } else {
                                  ConstantWidgets.showAlert(
                                    context,
                                    "Storage Access Required",
                                    StateType.error,
                                  );
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  await Permission.storage.request();
                                }
                              },
                            ),
                            UploadField(
                              icon: Icons.file_present_outlined,
                              size: size,
                              count: docCount,
                              onTap: () async {
                                var status = await Permission.storage.status;
                                if (status == PermissionStatus.granted) {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    allowMultiple: true,
                                    type: FileType.custom,
                                    allowedExtensions: ["pdf"],
                                  );
                                  if (result != null) {
                                    List<String> paths = result.paths
                                        .map((path) => path!)
                                        .toList();
                                    setState(() {
                                      docCount = result.count.toString();
                                      selectedDocPaths.addAll(paths);
                                    });
                                  }
                                } else if (status ==
                                    PermissionStatus.permanentlyDenied) {
                                  await openAppSettings();
                                } else {
                                  ConstantWidgets.showAlert(
                                    context,
                                    "Storage Access Required",
                                    StateType.error,
                                  );
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  await Permission.storage.request();
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.04),
                        Center(
                          child: CustomMaterialButton(
                            backgroundColor: Colors.green,
                            fontColor: Colors.white,
                            width: size.width * 0.5,
                            height: size.height * 0.06,
                            text: "SUBMIT",
                            onPress: () async {
                              // _userRepo!.getUserDeviceId(
                              //   nameController.text,
                              //   stateController.text,
                              // );
                              if (_formKey.currentState!.validate()) {
                                final userId =
                                    FirebaseAuth.instance.currentUser?.uid;
                                final caseData = {
                                  'dateOfLastContact': dateController.text,
                                  'city': cityController.text,
                                  'state': state!.toLowerCase(),
                                  'zipCode': zipCodeController.text,
                                  'circumstancesOfDisappearance':
                                      circumstancesController.text,
                                  'name': nameController.text.toLowerCase(),
                                  'age': ageController.text,
                                  'race': race,
                                  'height': heightController.text,
                                  'weight': weightController.text,
                                  'hairColor': hairColor,
                                  'eyeColor': eyeColor,
                                  'description': descriptionController.text,
                                  'images': [],
                                  'documents': [],
                                  'userId': userId,
                                  "caseId": generateCaseId(),
                                  "status": true,
                                };
                                UserRepo userRepo = UserRepo();

                                if (imageCount != null) {
                                  dialog!.showAlertDialog(Colors.blue);
                                  final images = await userRepo.uploadFiles(
                                    selectedImagePaths,
                                    'images',
                                  );
                                  caseData['images'] = images;
                                  dialog!.dimissDialog();
                                }

                                if (docCount != null) {
                                  dialog!.showAlertDialog(Colors.blue);
                                  final documents = await userRepo.uploadFiles(
                                    selectedDocPaths,
                                    'documents',
                                  );
                                  caseData['documents'] = documents;
                                  dialog!.dimissDialog();
                                }
                                _publicBloc!.add(
                                  NewCaseEvent(requestData: caseData),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator.adaptive(),
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
