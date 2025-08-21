import 'package:volleyapp/features/club/domain/entities/club.dart';

abstract class ClubEvent {}

class SearchClubsChanged extends ClubEvent {
  final String query;
  SearchClubsChanged(this.query);
}

class ClubSelected extends ClubEvent {
  final Club club;
  ClubSelected(this.club);
}

class SubmitJoinClub extends ClubEvent {} // non utilisé ici