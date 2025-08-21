class Role {
  final String id;
  final String name;
  final List<String> permissions;

  const Role({
    required this.id,
    required this.name,
    required this.permissions,
  });

  static const presidenggggg = Role(
    id: "president",
    name: "Président du club",
    permissions: [
      "manage_club",
      "add_player",
      "remove_player",
      "manage_teams",
    ],
  );

  static const coach = Role(
    id: "coach",
    name: "Entraîneur",
    permissions: ["manage_teams", "manage_events"],
  );

  static const player = Role(
    id: "player",
    name: "Joueur",
    permissions: ["view_stats"],
  );

  static const guest = Role(
    id: "guest",
    name: "Invité",
    permissions: [],
  );

  static const all = [presidenggggg, coach, player, guest];

  static Role fromId(String id) {
    return all.firstWhere(
          (role) => role.id == id,
      orElse: () => guest,
    );
  }
}
