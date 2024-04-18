// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
  }
}
