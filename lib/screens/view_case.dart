import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_return/models/case_model.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/repo/user_repo.dart';
import 'package:safe_return/utils/constants/states_list.dart';
import 'package:safe_return/utils/enums/state_enums.dart';
import 'package:safe_return/widgets/alert_list_tile.dart';
import 'package:safe_return/widgets/constant_widgets.dart';
import 'package:safe_return/widgets/input_widget.dart';

class ViewCase extends StatefulWidget {
  const ViewCase({super.key});

  @override
  State<ViewCase> createState() => _ViewCaseState();
}

class _ViewCaseState extends State<ViewCase> {
  bool? userVerfiedStatus;
  bool loader = true;
  UserRepo? _userRepo;
  final _formKey = GlobalKey<FormState>();
  String? choosedState;
  CollectionReference? casesCollection;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  @override
  void initState() {
    super.initState();
    _userRepo = UserRepo();

    setState(() {
      choosedState = MalaysiaStates.states.first.toLowerCase();
    });
    UserRepo userRepo = UserRepo();
    userRepo.getUserStatus().then((value) {
      setState(() {
        userVerfiedStatus = value;
        loader = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            child: Column(
              children: [
                headerTitle(),
                SizedBox(height: size.height * 0.02),
                newCaseContainer(),
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.43,
            child: Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: FutureBuilder(
                future: _userRepo!.getFilteredCases(
                  name: _name.text.trim(),
                  age: _age.text.trim(),
                  state: choosedState,
                ),
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
                    final caseDocsMo = snapshot.data!.docs.map((doc) {
                      return CaseModel.fromMap(doc.data());
                    }).toList();
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Text(
                            "ALERTS",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        if (caseDocsMo.isNotEmpty) ...[
                          for (var model in caseDocsMo) ...[
                            AlertListTile(model: model),
                          ],
                        ] else ...[
                          const Center(
                            child: Text("No new cases"),
                          )
                        ],
                        SizedBox(height: size.height * 0.5)
                      ],
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget newCaseContainer() {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search,
                  size: 25,
                ),
                Text(
                  "Quick Search",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.06,
                        child: InputWidget(
                          hintText: "Name",
                          controller: _name,
                          isRequired: true,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      SizedBox(
                        height: size.height * 0.06,
                        child: InputWidget(
                          hintText: "Age",
                          controller: _age,
                          isRequired: true,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            menuMaxHeight: size.height * 0.25,
                            value: choosedState,
                            items: MalaysiaStates.states
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.toLowerCase(),
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) async {
                              if (value != null) {
                                setState(() {
                                  choosedState = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.04),
              GestureDetector(
                onTap: () {
                  final user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    if (userVerfiedStatus == true) {
                      Navigator.pushNamed(context, Routes.newCase);
                    } else {
                      ConstantWidgets.showAlert(
                        context,
                        "You're not verfied yet.",
                        StateType.warning,
                      );
                    }
                  } else {
                    ConstantWidgets.showAlert(
                      context,
                      "User must be logged in",
                      StateType.warning,
                    );
                  }
                },
                child: Container(
                  height: size.height * 0.2,
                  width: size.width * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      colors: [
                        Colors.orangeAccent.shade700,
                        Colors.orange,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.wysiwyg,
                        opticalSize: 48,
                        applyTextScaling: true,
                        size: 28,
                        color: Colors.white,
                      ),
                      Text(
                        "New Case",
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget headerTitle() {
    return Row(
      mainAxisAlignment: Navigator.canPop(context)
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      children: [
        if (Navigator.canPop(context)) ...[
          const BackButton(color: Colors.white),
          SizedBox(width: MediaQuery.of(context).size.width * 0.14),
        ],
        Text(
          "safe return".toUpperCase(),
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
