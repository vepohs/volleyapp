import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:volleyapp/features/auth/data/datasources/auth_datasource.dart';
import 'package:volleyapp/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:volleyapp/features/auth/data/repositories/auth_repository.dart';
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_up_with_email/sign_up_with_email_usecase.dart';

final locator = GetIt.instance;

Future<void> configureDependencies() async {
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  locator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  locator.registerLazySingleton<AuthDatasource>(() => FirebaseAuthDatasource(firebaseAuth: locator<FirebaseAuth>()));
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(locator<AuthDatasource>()));
  locator.registerLazySingleton<SignUpWithEmailUseCase>(() => SignUpWithEmailUseCase(locator<AuthRepository>()));




}
