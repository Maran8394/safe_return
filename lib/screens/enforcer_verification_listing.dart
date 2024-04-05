// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:safe_return/models/user_data.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/repo/user_repo.dart';
import 'package:safe_return/screens/enforcer_verification_detail.dart';

class EnforcerVerificationListing extends StatefulWidget {
  const EnforcerVerificationListing({super.key});

  @override
  State<EnforcerVerificationListing> createState() =>
      _EnforcerVerificationListingState();
}

class _EnforcerVerificationListingState
    extends State<EnforcerVerificationListing> {
  UserRepo? _userRepo;
  String? imageCount;
  String? docCount;

  @override
  void initState() {
    super.initState();
    _userRepo = UserRepo();
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
          "Verification",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: FutureBuilder(
            future: _userRepo!.getUnverifiedUsers(),
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
                final userDataModel = snapshot.data!.docs.map((doc) {
                  return UserData.fromMap(doc.data());
                }).toList();
                if (userDataModel.isNotEmpty) {
                  return ListView.builder(
                    itemCount: userDataModel.length,
                    itemBuilder: (context, index) {
                      UserData userDataModelObject =
                          userDataModel.elementAt(index);
                      String? name = userDataModel.elementAt(index).name;

                      return ListTile(
                        leading: Text(
                          (index + 1).toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        title: Text(name!),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_red_eye_outlined,
                              size: 30),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              Routes.enforcerVerificationDetail,
                              arguments: EnforcerVerificationDetail(
                                userData: userDataModelObject,
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.enforcerVerificationDetail,
                            arguments: EnforcerVerificationDetail(
                              userData: userDataModelObject,
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("No new members"),
                  );
                }
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
