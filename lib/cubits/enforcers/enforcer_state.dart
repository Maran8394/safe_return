part of 'enforcer_cubit.dart';

sealed class EnforcerCubitState {}

final class EnforcerInitial extends EnforcerCubitState {}

class GetEnforcerInitialState extends EnforcerCubitState {}

class GetEnforcerSuccessState extends EnforcerCubitState {
  final List<String> codes;
  GetEnforcerSuccessState({
    required this.codes,
  });
}

class GetEnforcerFailedState extends EnforcerCubitState {
  final String message;

  GetEnforcerFailedState({required this.message});
}
