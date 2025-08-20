import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import 'package:volleyapp/features/auth/data/datasources/auth_datasource.dart';
import 'package:volleyapp/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:volleyapp/features/auth/data/repositories/auth_repository.dart' as data_impl;
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_up_with_email/sign_up_with_email_usecase.dart';

import 'package:volleyapp/features/auth/domain/ports/auth_state_source.dart';
import 'package:volleyapp/features/auth/data/datasources/firebase_auth_state_source.dart';

import 'package:volleyapp/features/session/domain/session_state_provider.dart';

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

  // Optionnel : si d'autres couches en ont besoin
  locator.registerLazySingleton<AuthStateSource>(
        () => FirebaseAuthStateSource(locator<FirebaseAuth>()),
  );

  // Provider de session utilisé par le router
  locator.registerLazySingleton<SessionStateProvider>(
        () => FirebaseSessionStateProvider(),
  );
}
