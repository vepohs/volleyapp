
import 'package:volleyapp/features/auth/data/models/auth_user_model.dart';

abstract class AuthDatasource {
  Future<AuthUserModel> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<bool> isUserConnected() ;

  Future<AuthUserModel?> getCurrentUser() ;

  Future signInWithEmail({required String email, required String password}) ;
}
