import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/auth/data/models/auth_user_model.dart';
import 'package:volleyapp/features/auth/domain/entitites/auth_user.dart';

class AuthUserMapper implements BaseMapper<AuthUserModel, AuthUser> {
  @override
  AuthUser from(AuthUserModel input) {
    return AuthUser(
      id: input.id,
      email: input.email,
    );
  }

  @override
  AuthUserModel to(AuthUser output) {
    return AuthUserModel(
      id: output.id,
      email: output.email,
    );
  }
}