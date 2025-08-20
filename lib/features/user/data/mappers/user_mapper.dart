import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/user/data/models/user_model.dart';
import 'package:volleyapp/features/user/domain/entities/user.dart';

class UserMapper implements BaseMapper<UserModel, User> {
  @override
  User from(UserModel input) {
    return User(
      id: input.id,
      firstname: input.firstname,
      lastname: input.lastname,
      email: input.email,
      birthdate: input.birthdate,
      avatarUrl: input.avatarUrl,
    );
  }

  @override
  UserModel to(User output) {
    return UserModel(
      id: output.id,
      firstname: output.firstname,
      lastname: output.lastname,
      email: output.email,
      birthdate: output.birthdate,
      avatarUrl: output.avatarUrl,
      createdAt: DateTime.now(),
      roleId: 'user',
      clubId: null,
      teamId: null,
    );
  }
}
