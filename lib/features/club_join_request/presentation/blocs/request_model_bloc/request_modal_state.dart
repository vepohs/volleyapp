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

  final Map<String, String?> selectedTeamByRequest;
  final Map<String, String?> selectedRoleByRequest;

  RequestsModalLoaded({
    required this.club,
    required this.teams,
    required this.requests,
    required this.selectedTeamByRequest,
    required this.selectedRoleByRequest,
  });

  RequestsModalLoaded copyWith({
    Club? club,
    List<Team>? teams,
    List<ClubJoinRequest>? requests,
    Map<String, String?>? selectedTeamByRequest,
    Map<String, String?>? selectedRoleByRequest,
  }) {
    return RequestsModalLoaded(
      club: club ?? this.club,
      teams: teams ?? this.teams,
      requests: requests ?? this.requests,
      selectedTeamByRequest: selectedTeamByRequest ?? this.selectedTeamByRequest,
      selectedRoleByRequest: selectedRoleByRequest ?? this.selectedRoleByRequest,
    );
  }
}

class RequestsModalError extends RequestsModalState {
  final String message;
  RequestsModalError(this.message);
}