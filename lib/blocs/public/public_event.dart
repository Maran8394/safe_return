// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'public_bloc.dart';

class PublicEvent {}

class RegisterEvent extends PublicEvent {
  String name;
  String ic;
  String email;
  String userId;
  String password;
  String occupation;
  String state;
  String city;
  String contactNumber;
  List uploadedFiles;

  RegisterEvent({
    required this.name,
    required this.ic,
    required this.email,
    required this.userId,
    required this.password,
    required this.occupation,
    required this.state,
    required this.city,
    required this.contactNumber,
    required this.uploadedFiles,
  });
}

class UpdateEvent extends PublicEvent {
  String name;
  String email;
  String ic;
  String userId;
  String occupation;
  String state;
  String city;
  String contactNumber;
  UpdateEvent({
    required this.name,
    required this.email,
    required this.ic,
    required this.userId,
    required this.occupation,
    required this.state,
    required this.city,
    required this.contactNumber,
  });
}

class LoginEvent extends PublicEvent {
  final String email;
  String? userId;
  final String password;
  final String userType;
  LoginEvent({
    required this.email,
    this.userId,
    required this.password,
    required this.userType,
  });
}

class UpdatePasswordEvent extends PublicEvent {
  final String oldPassword;
  final String newPassword;
  UpdatePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });
}

class NewCaseEvent extends PublicEvent {
  final Map<String, dynamic> requestData;

  NewCaseEvent({required this.requestData});
}
