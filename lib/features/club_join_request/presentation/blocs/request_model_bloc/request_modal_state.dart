import 'package:volleyapp/features/club/domain/entities/club.dart';
import 'package:volleyapp/features/club_join_request/domain/entities/club_join_request.dart';
import 'package:volleyapp/features/team/domain/entities/team.dart';

abstract class RequestsModalState {}

class RequestsModalInitial extends RequestsModalState {}
class RequestsModalLoading extends RequestsModalState {}

class RequestsModalLoaded extends RequestsModalState {
  final Club club;
  final List<Team> teams;
  final List<ClubJoinRequest> requests;
  RequestsModalLoaded({
    required this.club,
    required this.teams,
    required this.requests,
  });
}

class RequestsModalError extends RequestsModalState {
  final String message;
  RequestsModalError(this.message);
}
