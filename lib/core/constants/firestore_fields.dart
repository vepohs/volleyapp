class FirestoreUserFields {
  static const String id = 'id';
  static const String firstname = 'firstname';
  static const String lastname = 'lastname';
  static const String email = 'email';
  static const String birthdate = 'birthdate';
  static const String avatarUrl = 'avatarUrl';
  static const String createdAt = 'createdAt';
}

class FirestoreClubFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String avatarUrl = 'avatarUrl';
  static const String createdAt = 'createdAt';
}

class FirestoreClubMembershipFields {
  static const String id = 'id';
  static const String clubId = 'clubId';
  static const String userId = 'userId';
  static const String roleId = 'roleId';
  static const String joinedAt = 'joinedAt';
}

class FirestoreTeamFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String category = 'category';
  static const String gender = 'gender';
  static const String level = 'level';
  static const String avatarUrl = 'avatarUrl';
}

class FirestoreTeamMembershipFields {
  static const String id = 'id';
  static const String teamId = 'teamId';
  static const String userId = 'userId';
  static const String joinedAt = 'joinedAt';
}

class FirestoreClubJoinRequestFields {
  static const String id = 'id';
  static const String clubId = 'clubId';
  static const String userId = 'userId';
  static const String status = 'status';
  static const String createdAt = 'createdAt';
  static const String decidedAt = 'decidedAt';
}

class FirestoreEventFields {
  static const String id = 'id';
  static const String startAt = 'startAt';
  static const String endAt = 'endAt';
  static const String location = 'location';
  static const String type = 'type';        // "match" | "training"
  static const String details = 'details';  // Map<String, dynamic>
  static const String createdAt = 'createdAt';

  // ---- Sous-champs pour MatchDetails ----
  static const String homeClubId = 'homeClubId';
  static const String homeTeamId = 'homeTeamId';
  static const String awayClubId = 'awayClubId';
  static const String awayTeamId = 'awayTeamId';
  static const String competition = 'competition';
  static const String result = 'result';

  // ---- Sous-champs pour Result ----
  static const String sets = 'sets';
  static const String updatedAt = 'updatedAt';

  // ---- Sous-champs pour SetScore ----
  static const String number = 'number';
  static const String homePoints = 'homePoints';
  static const String awayPoints = 'awayPoints';

  // ---- Sous-champs pour TrainingDetails ----
  static const String clubId = 'clubId';
  static const String teamId = 'teamId';
  static const String coachId = 'coachId';
  static const String notes = 'notes';
}
class FirestoreClubTeamFields {
  static const String id = "id";
  static const String clubId = "clubId";
  static const String teamId = "teamId";
  static const String linkedAt = "linkedAt";
}

