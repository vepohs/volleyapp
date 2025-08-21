import 'package:volleyapp/features/user/data/models/user_model.dart';

abstract class UserDatasource {
  Future<UserModel> addUser({
    required String id,
    required String firstname,
    required String lastname,
    required String email,
    required DateTime birthdate,
    required String? avatarUrl,

  });

  Future<UserModel?> getUserById({required String id});
}
