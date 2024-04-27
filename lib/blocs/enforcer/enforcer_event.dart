// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'enforcer_bloc.dart';

@immutable
sealed class EnforcerEvent {}

class ChangeUserVerifiedStatus extends EnforcerEvent {
  final bool status;
  final String userId;
  ChangeUserVerifiedStatus({
    required this.status,
    required this.userId,
  });
}

class AssignStaffEvent extends EnforcerEvent {
  String caseId;
  String enforcerId;
  String enforcerName;
  AssignStaffEvent({
    required this.caseId,
    required this.enforcerId,
    required this.enforcerName,
  });
}

class GetReportsDataEvent extends EnforcerEvent {}


class GetCasesListEvent extends EnforcerEvent{}