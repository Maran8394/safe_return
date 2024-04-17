// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_code_cubit.dart';

class PostCodeState {}

final class PostCodeInitial extends PostCodeState {}

class PostCodeInitialState extends PostCodeState {}

class PostCodeSuccessState extends PostCodeState {
  final List<String> codes;
  PostCodeSuccessState({
    required this.codes,
  });
}

class PostCodeFailedState extends PostCodeState {
  final String message;

  PostCodeFailedState({required this.message});
}
