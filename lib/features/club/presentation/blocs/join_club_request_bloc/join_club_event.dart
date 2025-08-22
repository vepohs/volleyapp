import 'package:volleyapp/features/club/domain/entities/club.dart';

abstract class JoinClubEvent {}

class SearchClubsChanged extends JoinClubEvent {
  final String query;
  SearchClubsChanged(this.query);
}

class ClubSelected extends JoinClubEvent {
  final Club club;
  ClubSelected(this.club);
}

class SubmitJoinClub extends JoinClubEvent {} // non utilisé ici