import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyapp/core/constants/firestore_fields.dart';
import 'package:volleyapp/core/mappers/base_mapper.dart';
import 'package:volleyapp/features/user/data/models/user_model.dart';

class UserJsonMapper implements BaseMapper<Map<String, dynamic>, UserModel> {
  @override
  UserModel from(Map<String, dynamic> input) {
    return UserModel(
      id: input[FirestoreUserFields.id] as String,
      firstname: input[FirestoreUserFields.firstname] as String,
      lastname: input[FirestoreUserFields.lastname] as String,
      email: input[FirestoreUserFields.email] as String,
      birthdate: (input[FirestoreUserFields.birthdate] as Timestamp).toDate(),
      avatarUrl: input[FirestoreUserFields.avatarUrl] as String?,
      createdAt: (input[FirestoreUserFields.createdAt] as Timestamp).toDate(),
      roleId: input[FirestoreUserFields.roleId] as String,
      clubId: input[FirestoreUserFields.clubId] as String?,
      teamId: input[FirestoreUserFields.teamId] as String?,
    );
  }

  @override
  Map<String, dynamic> to(UserModel output) {
    return {
      FirestoreUserFields.id: output.id,
      FirestoreUserFields.firstname: output.firstname,
      FirestoreUserFields.lastname: output.lastname,
      FirestoreUserFields.email: output.email,
      FirestoreUserFields.birthdate: output.birthdate,
      FirestoreUserFields.avatarUrl: output.avatarUrl,
      FirestoreUserFields.createdAt: output.createdAt,
      FirestoreUserFields.roleId: output.roleId,
      FirestoreUserFields.clubId: output.clubId,
      FirestoreUserFields.teamId: output.teamId,
    };
  }
}
