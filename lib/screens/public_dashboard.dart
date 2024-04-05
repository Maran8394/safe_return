// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:safe_return/models/user_data.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/repo/user_repo.dart';
import 'package:safe_return/screens/public_registration_edit.dart';
import 'package:safe_return/utils/constants/states_list.dart';
import 'package:safe_return/utils/enums/state_enums.dart';
import 'package:safe_return/widgets/constant_widgets.dart';

class PublicDashboard extends StatefulWidget {
  const PublicDashboard({super.key});

  @override
  State<PublicDashboard> createState() => _PublicDashboardState();
}

class _PublicDashboardState extends State<PublicDashboard> {
  String? choosedState;
  bool? userVerfiedStatus;
  bool loader = true;
  @override
  void initState() {
    super.initState();
    setState(() {
      choosedState = MalaysiaStates.states.first;
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
                const ProfileCard()
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.38,
            child: Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: loader
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.post_add_outlined,
                            size: 30,
                          ),
                          title: const Text("New Case"),
                          onTap: () {
                            if (userVerfiedStatus == true) {
                              Navigator.pushNamed(context, Routes.newCase);
                            } else {
                              ConstantWidgets.showAlert(
                                context,
                                "You're not verfied yet.",
                                StateType.warning,
                              );
                            }
                          },
                        ),
                        const Divider(height: 10),
                        ListTile(
                          leading: const Icon(
                            Icons.view_day_outlined,
                            size: 30,
                          ),
                          title: const Text("View Case"),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.viewCase,
                            );
                          },
                        ),
                        const Divider(
                          height: 10,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.admin_panel_settings_outlined,
                            size: 30,
                          ),
                          title: const Text("Update Password"),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.updatePassword,
                            );
                          },
                        ),
                        const Divider(height: 10),
                        ListTile(
                          leading: const Icon(
                            Icons.exit_to_app_outlined,
                            size: 30,
                          ),
                          title: const Text("Logout"),
                          onTap: () async {
                            UserRepo userRepo = UserRepo();
                            await userRepo.logout();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.indexPage,
                              (route) => false,
                            );
                          },
                        ),
                        const Divider(height: 10),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget headerTitle() {
    return Center(
      child: Text(
        "safe return".toUpperCase(),
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData>(
      future: UserRepo.getUserData(),
      builder: (context, AsyncSnapshot<UserData> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          UserData userData = snapshot.data!;
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    userData.name!,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(
                    userData.ic!,
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.create_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.publicRegistrationEdit,
                        arguments: PublicRegistrationEdit(userData: userData),
                      );
                    },
                  ),
                ),
                _buildRow("USER ID", userData.userId!),
                _buildRow("EMAIL", userData.email!),
                _buildRow("CONTACT", userData.contactNumber!),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(flex: 1, child: Text(label)),
        Expanded(flex: 2, child: Text(value)),
      ],
    );
  }
}
