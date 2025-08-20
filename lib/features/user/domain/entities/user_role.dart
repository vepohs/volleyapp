import 'package:volleyapp/features/user/domain/entities/role.dart';
import 'package:volleyapp/features/user/domain/entities/user.dart';

class RoleUser {
  final Role role;
  final User user;

  const RoleUser({required this.user,required this.role});
}