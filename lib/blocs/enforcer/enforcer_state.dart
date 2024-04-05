// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'enforcer_bloc.dart';

@immutable
sealed class EnforcerState {}

final class EnforcerInitial extends EnforcerState {}

class ChangeVerificationInitState extends EnforcerState {}

class ChangeVerificationSuccessState extends EnforcerState {
  final String msg;
  ChangeVerificationSuccessState({
    required this.msg,
  });
}

class ChangeVerificationFailedState extends EnforcerState {
  final String errorMessage;
  ChangeVerificationFailedState({
    required this.errorMessage,
  });
}

class AssignStaffInitState extends EnforcerState {}

class AssignStaffSuccessState extends EnforcerState {}

class AssignStaffFailedState extends EnforcerState {
  final String errorMessage;
  AssignStaffFailedState({
    required this.errorMessage,
  });
}
