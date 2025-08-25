import 'package:volleyapp/features/club_join_request/domain/entities/club_join_request.dart';

abstract class ClubJoinRequestListState {}

class JoinRequestInitial extends ClubJoinRequestListState {}

class JoinRequestLoading extends ClubJoinRequestListState {}

class JoinRequestLoaded extends ClubJoinRequestListState {
  final List<ClubJoinRequest> requests;
  JoinRequestLoaded({required this.requests});
}

class JoinRequestError extends ClubJoinRequestListState {
  final String message;
  JoinRequestError(this.message);
}
