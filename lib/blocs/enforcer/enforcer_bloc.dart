// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:safe_return/models/case_model.dart';
import 'package:safe_return/models/reports_data.dart';
import 'package:safe_return/repo/user_repo.dart';
import 'package:safe_return/utils/custom_methods.dart';

part 'enforcer_event.dart';
part 'enforcer_state.dart';

class EnforcerBloc extends Bloc<EnforcerEvent, EnforcerState> {
  EnforcerBloc() : super(EnforcerInitial()) {
    on<EnforcerEvent>((event, emit) {});

    on<ChangeUserVerifiedStatus>((event, emit) async {
      emit(ChangeVerificationInitState());
      UserRepo userRepo = UserRepo();
      try {
        String msg = await userRepo.changeVerifiedStatus(
          status: event.status,
          userId: event.userId,
        );
        emit(ChangeVerificationSuccessState(msg: msg));
      } catch (e) {
        emit(ChangeVerificationFailedState(errorMessage: getErrorMessage(e)));
      }
    });

    on<AssignStaffEvent>((event, emit) async {
      emit(AssignStaffInitState());
      UserRepo userRepo = UserRepo();
      try {
        await userRepo.addEnforcersToCases(
          event.enforcerId,
          event.enforcerName,
          event.caseId,
        );
        emit(AssignStaffSuccessState());
      } catch (e) {
        emit(AssignStaffFailedState(errorMessage: getErrorMessage(e)));
      }
    });

    on<GetReportsDataEvent>((event, emit) async {
      emit(GetEnforcerReportsDataInitState());
      UserRepo userRepo = UserRepo();
      try {
        ReportsData reportsData = await userRepo.getEnforcerReportsData();
        emit(GetEnforcerReportsDataSuccessState(reportsData: reportsData));
      } catch (e) {
        emit(GetEnforcerReportsDataFailedState(
          errorMessage: getErrorMessage(e),
        ));
      }
    });

    on<GetCasesListEvent>((event, emit) async {
      emit(GetCasesInitState());
      UserRepo userRepo = UserRepo();
      try {
        QuerySnapshot<Map<String, dynamic>> reportsData =
            await userRepo.getFilteredCases();
        List<CaseModel> caseModel = reportsData.docs.map((doc) {
          return CaseModel.fromMap(doc.data());
        }).toList();
        emit(GetCasesSuccessState(caseModel: caseModel));
      } catch (e) {
        emit(GetCasesFailedState(
          errorMessage: getErrorMessage(e),
        ));
      }
    });
  }
}
