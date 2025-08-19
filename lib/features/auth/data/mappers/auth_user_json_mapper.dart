import 'package:volleyapp/core/constants/firestore_fields.dart';
import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/auth/data/models/auth_user_model.dart';

class AuthUserJsonMapper
    implements BaseMapper<Map<String, dynamic>, AuthUserModel> {
  @override
  AuthUserModel from(Map<String, dynamic> input) {
    return AuthUserModel(
      id: input[FirestoreUserFields.id] as String,
      email: input[FirestoreUserFields.email] as String,
    );
  }

  @override
  Map<String, dynamic> to(AuthUserModel output) {
    return {
      FirestoreUserFields.id: output.id,
      FirestoreUserFields.email: output.email,
    };
  }
}