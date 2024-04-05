// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'public_bloc.dart';

@immutable
sealed class PublicState {}

final class PublicInitial extends PublicState {}

class RegisterationInitiatedState extends PublicState {}

class RegisterationSuccessState extends PublicState {
  final String successMessage;
  RegisterationSuccessState({
    required this.successMessage,
  });
}

class RegisterationFailedState extends PublicState {
  final String errorMessage;
  RegisterationFailedState({
    required this.errorMessage,
  });
}

class UpdateInitState extends PublicState {}

class UpdateSuccessState extends PublicState {
  final String successMessage;
  UpdateSuccessState({
    required this.successMessage,
  });
}

class UpdateFailedState extends PublicState {
  final String errorMessage;
  UpdateFailedState({
    required this.errorMessage,
  });
}

class UpdatePasswordInitState extends PublicState {}

class UpdatePasswordSuccessState extends PublicState {
  final String successMessage;
  UpdatePasswordSuccessState({
    required this.successMessage,
  });
}

class UpdatePasswordFailedState extends PublicState {
  final String errorMessage;
  UpdatePasswordFailedState({
    required this.errorMessage,
  });
}

class LoginInitiated extends PublicState {}

class LoginSuccessState extends PublicState {
  final UserCredential? userCredential;
  LoginSuccessState({
    this.userCredential,
  });
}

class LoginFailedState extends PublicState {
  final String errorMessage;
  LoginFailedState({
    required this.errorMessage,
  });
}

class NewCaseInitState extends PublicState {}

class NewCaseSuccessState extends PublicState {
  final String? message;
  NewCaseSuccessState({
    this.message,
  });
}

class NewCaseFailedState extends PublicState {
  final String errorMessage;
  NewCaseFailedState({
    required this.errorMessage,
  });
}
