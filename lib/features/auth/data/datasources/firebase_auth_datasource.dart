import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:volleyapp/features/auth/data/datasources/auth_datasource.dart';
import 'package:volleyapp/features/auth/data/mappers/auth_user_firebase_mapper.dart';
import 'package:volleyapp/features/auth/data/models/auth_user_model.dart';
import 'package:volleyapp/features/auth/errors/auth_exception.dart';

class FirebaseAuthDatasource implements AuthDatasource {
  final FirebaseAuth firebaseAuth;
  final AuthUserFirebaseMapper mapper = AuthUserFirebaseMapper();

  FirebaseAuthDatasource({required this.firebaseAuth});

  Future<AuthUserModel?> _reloadAndMap(User? firebaseUser) async {
    if (firebaseUser == null) return null;

    await firebaseUser.reload();
    final refreshedUser = firebaseAuth.currentUser;
    if (refreshedUser == null) return null;

    return mapper.from(refreshedUser);
  }

  @override
  Future<AuthUserModel> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      final userModel = await _reloadAndMap(firebaseUser);

      if (userModel == null) {
        throw const SignUpWithEmailException(
          "Firebase user introuvable après création",
        );
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailException("FirebaseAuth error: ${e.message}");
    } catch (e) {
      throw SignUpWithEmailException("Erreur inconnue: $e");
    }
  }

  @override
  Future<bool> isUserConnected() async {
    try {
      final userModel = await _reloadAndMap(firebaseAuth.currentUser);
      return userModel != null;
    } on FirebaseAuthException catch (e) {
      throw IsUserConnectedException("FirebaseAuth error: ${e.message}");
    } catch (e) {
      throw IsUserConnectedException("Erreur inattendue: $e");
    }
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    try {
      return await _reloadAndMap(firebaseAuth.currentUser);
    } on FirebaseAuthException catch (e) {
      throw GetCurrentUserException("FirebaseAuth error: ${e.message}");
    } catch (e) {
      throw GetCurrentUserException("Erreur inattendue: $e");
    }
  }

  @override
  Future<AuthUserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      final userModel = await _reloadAndMap(firebaseUser);

      if (userModel == null) {
        throw const SignInWithEmailException(
          "Firebase user introuvable après connexion",
        );
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw SignInWithEmailException("FirebaseAuth error: ${e.message}");
    } catch (e) {
      throw SignInWithEmailException("Erreur inconnue: $e");
    }
  }

  @override
  Future<AuthUserModel> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        userCredential = await firebaseAuth.signInWithPopup(googleProvider);
      } else {
        final googleUser = await GoogleSignIn.instance.authenticate();

        final googleAuth = googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        userCredential = await firebaseAuth.signInWithCredential(credential);
      }

      final firebaseUser = userCredential.user;
      final userModel = await _reloadAndMap(firebaseUser);

      if (userModel == null) {
        throw const SignInWithGoogleException(
          "Firebase user introuvable après connexion Google",
        );
      }

      return userModel;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const SignInWithGoogleException(
          "Connexion annulée par l’utilisateur",
        );
      }
      throw SignInWithGoogleException(
        "Google sign-in error: ${e.description}",
      );
    } on FirebaseAuthException catch (e) {
      throw SignInWithGoogleException("FirebaseAuth error: ${e.message}");
    } catch (e) {
      throw SignInWithGoogleException("Erreur inconnue: $e");
    }
  }

  @override
  Future<Unit> signOut() async {
    try {
      await firebaseAuth.signOut();

      return unit;
    } on FirebaseAuthException catch (e) {
      throw SignOutException("FirebaseAuth error: ${e.message}");
    } catch (e) {
      throw SignOutException("Erreur inattendue: $e");
    }
  }

}
