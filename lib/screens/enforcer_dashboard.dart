// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safe_return/models/enforcer_profile_model.dart';
import 'package:safe_return/paths/asset_paths.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/repo/user_repo.dart';
import 'package:safe_return/utils/constants/states_list.dart';

class EnforcerDashboard extends StatefulWidget {
  const EnforcerDashboard({super.key});

  @override
  State<EnforcerDashboard> createState() => _EnforcerDashboardState();
}

class _EnforcerDashboardState extends State<EnforcerDashboard> {
  String? choosedState;

  @override
  void initState() {
    super.initState();
    setState(() {
      choosedState = MalaysiaStates.states.first;
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
            top: size.height * 0.28,
            child: Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.verified_user_outlined,
                      size: 30,
                    ),
                    title: const Text("Verification"),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.enforcerVerificationListing,
                      );
                    },
                  ),
                  const Divider(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.article_outlined,
                      size: 30,
                    ),
                    title: const Text("Cases"),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.caseList,
                      );
                    },
                  ),
                  const Divider(
                    height: 10,
                  ),
                  // ListTile(
                  //   leading: const Icon(
                  //     Icons.group_add_outlined,
                  //     size: 30,
                  //   ),
                  //   title: const Text("Assign Staff"),
                  //   onTap: () {
                  //     Navigator.pushNamed(
                  //       context,
                  //       Routes.caseList,
                  //     );
                  //   },
                  // ),
                  // const Divider(
                  //   height: 10,
                  // ),
                  ListTile(
                    leading: const Icon(
                      Icons.pie_chart_outline,
                      size: 30,
                    ),
                    title: const Text("Reports"),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.enforcerReports,
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

  Widget newCaseContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: FutureBuilder(
          future: UserRepo.getEnforcerData(),
          builder: (context, AsyncSnapshot<EnforcerProfileModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              EnforcerProfileModel userData = snapshot.data!;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 40,
                  child: Center(
                    child: SvgPicture.asset(
                      AssetPath.enforcer,
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                  ),
                ),
                title: Text(userData.name),
                subtitle: Text(userData.station),
              );
            }
          }),
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
