// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:safe_return/repo/user_repo.dart';
import 'package:safe_return/utils/custom_methods.dart';

part 'public_event.dart';
part 'public_state.dart';

class PublicBloc extends Bloc<PublicEvent, PublicState> {
  PublicBloc() : super(PublicInitial()) {
    on<RegisterEvent>((event, emit) async {
      emit(RegisterationInitiatedState());
      UserRepo userRepo = UserRepo();
      try {
        String msg = await userRepo.registerUser(
          event.name,
          event.ic,
          event.email,
          event.userId,
          event.password,
          event.occupation,
          event.state,
          event.city,
          event.contactNumber,
          event.uploadedFiles,
        );
        emit(RegisterationSuccessState(successMessage: msg));
      } catch (e) {
        emit(
          RegisterationFailedState(
            errorMessage: getErrorMessage(e),
          ),
        );
      }
    });

    on<UpdateEvent>((event, emit) async {
      emit(UpdateInitState());
      UserRepo userRepo = UserRepo();
      try {
        String msg = await userRepo.updateUser(
          email: event.email,
          name: event.name,
          ic: event.ic,
          userId: event.userId,
          occupation: event.occupation,
          state: event.state,
          city: event.city,
          contactNumber: event.contactNumber,
        );
        emit(UpdateSuccessState(successMessage: msg));
      } catch (e) {
        emit(
          UpdateFailedState(errorMessage: getErrorMessage(e)),
        );
      }
    });

    on<UpdatePasswordEvent>((event, emit) async {
      emit(UpdatePasswordInitState());
      UserRepo userRepo = UserRepo();
      try {
        String msg = await userRepo.updatePassword(
          event.oldPassword,
          event.newPassword,
        );
        emit(UpdatePasswordSuccessState(successMessage: msg));
      } catch (e) {
        emit(
          UpdatePasswordFailedState(errorMessage: getErrorMessage(e)),
        );
      }
    });
    on<LoginEvent>((event, emit) async {
      emit(LoginInitiated());
      UserRepo userRepo = UserRepo();
      try {
        UserCredential? msg = await userRepo.loginUser(
          email: event.email,
          password: event.password,
          userId: event.userId,
          userType: event.userType,
        );
        emit(LoginSuccessState(userCredential: msg));
      } catch (e) {
        emit(LoginFailedState(errorMessage: getErrorMessage(e)));
      }
    });

    on<NewCaseEvent>((event, emit) async {
      emit(NewCaseInitState());
      UserRepo userRepo = UserRepo();
      try {
        String? msg = await userRepo.createNewCase(event.requestData);
        emit(NewCaseSuccessState(message: msg));
      } catch (e) {
        emit(NewCaseFailedState(errorMessage: getErrorMessage(e)));
      }
    });
  }
}
