import 'package:volleyapp/features/team/domain/entities/team.dart';

abstract class TeamState {}

class TeamInitial extends TeamState {}

class TeamLoading extends TeamState {}

class TeamLoaded extends TeamState {
  final List<Team> teams;
  TeamLoaded({required this.teams});
}

class TeamError extends TeamState {
  final String message;

  TeamError(this.message);
}
