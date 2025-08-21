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

