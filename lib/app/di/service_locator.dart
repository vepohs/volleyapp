import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

// Auth
import 'package:volleyapp/features/auth/data/datasources/auth_datasource.dart';
import 'package:volleyapp/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:volleyapp/features/auth/data/repositories/auth_repositoryImpl.dart' as auth_data;
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart' as auth_domain;
import 'package:volleyapp/features/auth/domain/use_cases/sign_in_with_email/sign_in_with_email_use_case.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_in_with_google/sign_in_with_google.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_up_with_email/sign_up_with_email_usecase.dart';
import 'package:volleyapp/features/club/data/datasources/club_datasource.dart';
import 'package:volleyapp/features/club/data/datasources/firebase_club_datasource.dart';
import 'package:volleyapp/features/club/data/repositories/club_repository_impl.dart';
import 'package:volleyapp/features/club/domain/repositories/club_repository.dart';
import 'package:volleyapp/features/club/domain/use_cases/add_club/add_club_use_case.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_filtered_club_by_name/get_filtered_club_by_name_use_case.dart';
import 'package:volleyapp/features/club_membership/data/datasources/firestrore_club_memership_datasource.dart';
import 'package:volleyapp/features/club_membership/data/repositories/club_membership_repository_impl.dart';
import 'package:volleyapp/features/club_membership/domain/repositories/club_membership_repository.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/add_club_membership_use_case/add_club_membership_use_case.dart';

// User
import 'package:volleyapp/features/user/data/datasources/firebase_user_datasource.dart';
import 'package:volleyapp/features/user/data/datasources/user_datasource.dart';
import 'package:volleyapp/features/user/data/repositories/user_repository.dart' as user_data;
import 'package:volleyapp/features/user/domain/repositories/user_repository.dart' as user_domain;
import 'package:volleyapp/features/user/domain/use_cases/add_user/add_user_usecase.dart';

// Session (réactive)
import 'package:volleyapp/features/session/domain/session_state_provider.dart';
import 'package:volleyapp/features/session/data/session_state_provider_reactive.dart' as session_b;

import '../../features/club_membership/data/datasources/club_membership_datasource.dart';

final locator = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  locator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Datasources
  locator.registerLazySingleton<AuthDatasource>(
        () => FirebaseAuthDatasource(firebaseAuth: locator<FirebaseAuth>()),
  );
  locator.registerLazySingleton<UserDatasource>(
        () => FirebaseUserDatasource(firestore: locator<FirebaseFirestore>()),
  );
  locator.registerLazySingleton<ClubDataSource>(
          () => FirebaseClubDatasource(firestore: locator<FirebaseFirestore>()));

  locator.registerLazySingleton<ClubMembershipDataSource>(
          () => FirebaseClubMembershipDatasource(firestore: locator<FirebaseFirestore>()));

  // Repositories
  locator.registerLazySingleton<auth_domain.AuthRepository>(
        () => auth_data.AuthRepositoryImpl(locator<AuthDatasource>()),
  );
  locator.registerLazySingleton<user_domain.UserRepository>(
        () => user_data.UserRepositoryImpl(locator<UserDatasource>()),
  );
  locator.registerLazySingleton<ClubRepository>(
          () => ClubRepositoryImpl(locator<ClubDataSource>()));

  locator.registerLazySingleton<ClubMembershipRepository>(
          () => ClubMembershipRepositoryImpl(locator<ClubMembershipDataSource>()));

  // Use cases
  locator.registerLazySingleton<SignUpWithEmailUseCase>(
        () => SignUpWithEmailUseCase(locator<auth_domain.AuthRepository>()),
  );
  locator.registerLazySingleton<SignInWithEmailUseCase>(
        () => SignInWithEmailUseCase(locator<auth_domain.AuthRepository>()),
  );
  locator.registerLazySingleton<SignInWithGoogleUseCase>(
        () => SignInWithGoogleUseCase(locator<auth_domain.AuthRepository>()),
  );
  locator.registerLazySingleton<AddUserUseCase>(
        () => AddUserUseCase(locator<user_domain.UserRepository>()),
  );

  locator.registerLazySingleton<AddClubUseCase>(
          () => AddClubUseCase(locator<ClubRepository>()));

  locator.registerLazySingleton<AddClubMembershipUseCase>(
          () => AddClubMembershipUseCase(locator<ClubMembershipRepository>()));

  locator.registerLazySingleton<GetFilteredClubByNameUseCase>(() =>GetFilteredClubByNameUseCase(locator<ClubRepository>()));

  // Session provider
  locator.registerLazySingleton<SessionStateProvider>(
        () => session_b.SessionStateProviderReactive(
      authRepository: locator<auth_domain.AuthRepository>(),
      userRepository: locator<user_domain.UserRepository>(),
      authChangesStream: locator<FirebaseAuth>().authStateChanges(),
    ),
  );

}
