import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:volleyapp/features/auth/data/datasources/auth_datasource.dart';
import 'package:volleyapp/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:volleyapp/features/auth/data/repositories/auth_repository.dart' as data_impl;
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_in_with_email/sign_in_with_email_use_case.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_in_with_google/sign_in_with_google.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_up_with_email/sign_up_with_email_usecase.dart';
import 'package:volleyapp/features/session/domain/session_state_provider.dart';
import 'package:volleyapp/features/user/data/datasources/firebase_user_datasource.dart';
import 'package:volleyapp/features/user/data/datasources/user_datasource.dart';
import 'package:volleyapp/features/user/data/repositories/user_repository.dart';
import 'package:volleyapp/features/user/domain/repositories/user_repository.dart';
import 'package:volleyapp/features/user/domain/use_cases/add_user/add_user_usecase.dart';

final locator = GetIt.instance;

Future<void> configureDependencies() async {
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  locator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  locator.registerLazySingleton<AuthDatasource>(
        () => FirebaseAuthDatasource(firebaseAuth: locator<FirebaseAuth>()),
  );

  locator.registerLazySingleton<AuthRepository>(
        () => data_impl.AuthRepositoryImpl(locator<AuthDatasource>()),
  );

  locator.registerLazySingleton<SignUpWithEmailUseCase>(
        () => SignUpWithEmailUseCase(locator<AuthRepository>()),
  );

  locator.registerLazySingleton<SignInWithEmailUseCase>(
        () => SignInWithEmailUseCase(locator<AuthRepository>()),
  );

  locator.registerLazySingleton<SignInWithGoogleUseCase>(() => SignInWithGoogleUseCase(locator<AuthRepository>()));
  // Provider de session utilisé par le router
  locator.registerLazySingleton<SessionStateProvider>(
        () => FirebaseSessionStateProvider(),
  );

  locator.registerLazySingleton<UserDatasource>(() => FirebaseUserDatasource(firestore: locator<FirebaseFirestore>()));

  locator.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(locator<UserDatasource>()));

  locator.registerLazySingleton<AddUserUseCase>(() => AddUserUseCase(locator<UserRepository>()));
}
