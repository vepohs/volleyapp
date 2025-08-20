import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volleyapp/features/auth/domain/entitites/auth_user.dart';
import 'package:volleyapp/features/auth/domain/ports/auth_state_source.dart';

class FirebaseAuthStateSource implements AuthStateSource {
  final FirebaseAuth _fa;
  FirebaseAuthStateSource(this._fa);

  @override
  Stream<AuthUser?> get changes =>
      _fa.authStateChanges().map((u) => u == null ? null : AuthUser( id: u.uid, email: u.email));

  @override
  Option<AuthUser> getCurrentUser() {
    final u = _fa.currentUser;
    return u == null ? none() : some(AuthUser(id: u.uid, email: u.email));
  }
}