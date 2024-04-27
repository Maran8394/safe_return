// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_return/blocs/enforcer/enforcer_bloc.dart';
import 'package:safe_return/models/case_model.dart';
import 'package:safe_return/paths/routes.dart';
import 'package:safe_return/repo/user_repo.dart';
import 'package:safe_return/screens/enforcer_assign_staff.dart';

class CaseList extends StatefulWidget {
  const CaseList({super.key});

  @override
  State<CaseList> createState() => _CaseListState();
}

class _CaseListState extends State<CaseList> {
  UserRepo? _userRepo;
  EnforcerBloc? _enforcerBloc;
  String? imageCount;
  String? docCount;

  @override
  void initState() {
    super.initState();
    _userRepo = UserRepo();
    _enforcerBloc = EnforcerBloc();
    _enforcerBloc!.add(GetCasesListEvent());
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
          child: BlocBuilder<EnforcerBloc, EnforcerState>(
            bloc: _enforcerBloc,
            builder: (context, state) {
              if (state is GetCasesInitState) {
                return const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              if (state is GetCasesFailedState) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(state.errorMessage),
                  ),
                );
              }
              if (state is GetCasesSuccessState) {
                List<bool> switchValues =
                    List.filled(state.caseModel.length, false);
                return ListView.builder(
                  itemCount: state.caseModel.length,
                  itemBuilder: (context, index) {
                    CaseModel caseData = state.caseModel.elementAt(index);
                    String? name = caseData.caseId;
                    String? location = caseData.city;
                    bool? isItSolved = caseData.isItSolved;
                    switchValues[index] = isItSolved;
                    return ListTile(
                      leading: Text(
                        (index + 1).toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      title: Text(name!),
                      subtitle: Text(location!),
                      trailing: CupertinoSwitch(
                        value: switchValues[index],
                        onChanged: (value) async {
                          setState(() {
                            switchValues[index] = value;
                          });
                          await updateCase(name, value);
                          _enforcerBloc!.add(GetCasesListEvent());
                        },
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.enforcerAssignStaff,
                          arguments: EnforcerAssignStaff(caseModel: caseData),
                        );
                      },
                    );
                  },
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
    );
  }

  Future<void> updateCase(String name, bool isSolved) async {
    await _userRepo!.updateIsItSolved(name, isSolved);
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
              (count != null) ? "$count" : "-",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
