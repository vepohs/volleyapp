import 'package:firebase_auth/firebase_auth.dart';
import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/auth/data/models/auth_user_model.dart';

class AuthUserFirebaseMapper implements BaseMapper<User, AuthUserModel> {
  @override
  AuthUserModel from(User input) {
    return AuthUserModel(
      id: input.uid,
      email: input.email ?? '',
    );
  }

  @override
  User to(AuthUserModel output) {
    throw UnimplementedError('Conversion Model -> Firebase User impossible');
  }
}
