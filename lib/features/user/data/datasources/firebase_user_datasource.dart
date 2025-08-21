import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volleyapp/core/constants/firestore_collections.dart';
import 'package:volleyapp/features/user/data/datasources/user_datasource.dart';
import 'package:volleyapp/features/user/data/mappers/user_json_mapper.dart';
import 'package:volleyapp/features/user/data/models/user_model.dart';
import 'package:volleyapp/features/user/errors/user_exceptions.dart';

class FirebaseUserDatasource implements UserDatasource {
  final FirebaseFirestore firestore;
  final UserJsonMapper mapper = UserJsonMapper();

  FirebaseUserDatasource({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _usersCol =>
      firestore.collection(FirestoreCollections.users);

  @override
  Future<UserModel> addUser({
    required String id,
    required String firstname,
    required String lastname,
    required String email,
    required DateTime birthdate,
    String? avatarUrl,
  }) async {
    try {
      final userModel = UserModel(
        id: id,
        firstname: firstname,
        lastname: lastname,
        email: email,
        birthdate: birthdate,
        avatarUrl: avatarUrl,
        createdAt: DateTime.now(),
      );

      final data = mapper.to(userModel);

      await _usersCol.doc(id).set(data);

      return userModel;
    } on FirebaseException catch (e) {
      throw AddUserException("Firestore error: ${e.message}");
    } catch (e) {
      throw AddUserException("Erreur inattendue: $e");
    }
  }

  @override
  Future<UserModel?> getUserById({required String id}) async {
    try {
      final doc = await _usersCol.doc(id).get();

      if (!doc.exists) return null;

      final data = doc.data();
      if (data == null) return null;

      return mapper.from({...data, 'id': id});
    } on FirebaseException catch (e) {
      throw GetUserByIdException("Firestore error: ${e.message}");
    } catch (e) {
      throw GetUserByIdException("Erreur inattendue: $e");
    }
  }

  @override
  Stream<UserModel?> watchUserById({required String id}) {
    try {
      return _usersCol.doc(id).snapshots().map((doc) {
        if (!doc.exists) return null;
        final data = doc.data();
        if (data == null) return null;
        final withId = {...data, 'id': id};
        return mapper.from(withId);
      });
    } catch (e) {
      throw WatchUserByIdException("Erreur inattendue: $e");
    }
  }
}
