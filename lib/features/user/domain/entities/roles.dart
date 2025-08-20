


import 'package:volleyapp/features/user/domain/entities/role.dart';

class Roles {
  static const Role president = Role(
    id: 'president',
    name: 'président',
    permissions: {
      'manage_users',
      'manage_roles',
      'view_stats',
    },
  );

  static const Role coach = Role(
    id: 'coach',
    name: 'Coach',
    permissions: {
      'manage_team',
      'view_stats',
    },
  );

  static const Role player = Role(
    id: 'player',
    name: 'Joueur',
    permissions: {
      'view_team',
    },
  );
  static const Role user = Role(id: 'user', name: 'Utilisateur', permissions: {});

  static const Map<String, Role> values = {
    'president': president,
    'coach': coach,
    'player': player,
    'user': user,
  };

  static Role? fromId(String id) => values[id];
}
