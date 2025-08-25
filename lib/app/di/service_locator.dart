import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

// Auth
import 'package:volleyapp/features/auth/data/datasources/auth_datasource.dart';
import 'package:volleyapp/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:volleyapp/features/auth/data/repositories/auth_repositoryImpl.dart';
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_in_with_email/sign_in_with_email_use_case.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_in_with_google/sign_in_with_google.dart';
import 'package:volleyapp/features/auth/domain/use_cases/sign_up_with_email/sign_up_with_email_usecase.dart';
import 'package:volleyapp/features/club/data/datasources/club_datasource.dart';
import 'package:volleyapp/features/club/data/datasources/firebase_club_datasource.dart';
import 'package:volleyapp/features/club/data/repositories/club_repository_impl.dart';
import 'package:volleyapp/features/club/domain/repositories/club_repository.dart';
import 'package:volleyapp/features/club/domain/use_cases/add_club/add_club_use_case.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_all_club/get_all_club_use_case.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_club_by_id/get_club_by_id_use_case.dart';
import 'package:volleyapp/features/club/domain/use_cases/get_filtered_club_by_name/get_filtered_club_by_name_use_case.dart';
import 'package:volleyapp/features/club_join_request/data/datasources/club_join_request_datasource.dart';
import 'package:volleyapp/features/club_join_request/data/datasources/firebase_club_request_datasource.dart';
import 'package:volleyapp/features/club_join_request/data/repositories/club_join_request_repository_impl.dart';
import 'package:volleyapp/features/club_join_request/domain/repositories/club_join_request_repository.dart';
import 'package:volleyapp/features/club_join_request/domain/use_cases/submit_club_join_request/submit_club_join_request_use_case.dart';
import 'package:volleyapp/features/club_membership/data/datasources/club_membership_datasource.dart';
import 'package:volleyapp/features/club_membership/data/datasources/firestrore_club_memership_datasource.dart';
import 'package:volleyapp/features/club_membership/data/repositories/club_membership_repository_impl.dart';
import 'package:volleyapp/features/club_membership/domain/repositories/club_membership_repository.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/add_club_membership_use_case/add_club_membership_use_case.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_by_user_id/get_club_user_id_use_case.dart';
import 'package:volleyapp/features/club_membership/domain/use_cases/get_club_for_current_user/get_club_for_current_user_use_case.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/get_all_team_by_club_id/get_all_team_by_club_id_use_case.dart';
import 'package:volleyapp/features/event/data/datasources/event_datasource.dart';
import 'package:volleyapp/features/event/data/datasources/firebase_event_datasource.dart';
import 'package:volleyapp/features/event/data/repositories/event_repository_impl.dart';
import 'package:volleyapp/features/event/domain/repositories/event_repository.dart';
import 'package:volleyapp/features/event/domain/use_cases/add_event/add_event_use_case.dart';
import 'package:volleyapp/features/event/domain/use_cases/get_all_event/get_all_event_by_club_id_use_case.dart';
import 'package:volleyapp/features/club_team/data/datasources/club_team_datasource.dart';
import 'package:volleyapp/features/club_team/data/datasources/firebase_club_team_datasource.dart';
import 'package:volleyapp/features/club_team/data/repositories/club_team_repository_impl.dart';
import 'package:volleyapp/features/club_team/domain/repositories/club_team_repository.dart';
import 'package:volleyapp/features/club_team/domain/use_cases/add_club_team/add_club_team_use_case.dart';

import 'package:volleyapp/features/team/data/datasources/firebase_team_datasource.dart';
import 'package:volleyapp/features/team/data/datasources/team_datasource.dart';
import 'package:volleyapp/features/team/data/repositories/team_repository_impl.dart';
import 'package:volleyapp/features/team/domain/repositories/team_repository.dart';
import 'package:volleyapp/features/team/domain/use_cases/add_team/add_team_use_case.dart';
import 'package:volleyapp/features/team/domain/use_cases/get_team_by_id/get_team_by_id_use_case.dart';
import 'package:volleyapp/features/team_membership/data/datasources/firebase_team_membership.dart';
import 'package:volleyapp/features/team_membership/data/datasources/team_membership_datasource.dart';
import 'package:volleyapp/features/team_membership/data/repositories/team_membership_repository_impl.dart';
import 'package:volleyapp/features/team_membership/domain/repositories/team_membership_repository.dart';
import 'package:volleyapp/features/team_membership/domain/use_cases/add_team_membership/add_team_membership_use_case.dart';

// User
import 'package:volleyapp/features/user/data/datasources/firebase_user_datasource.dart';
import 'package:volleyapp/features/user/data/datasources/user_datasource.dart';
import 'package:volleyapp/features/user/data/repositories/user_repository.dart';
import 'package:volleyapp/features/user/domain/repositories/user_repository.dart';
import 'package:volleyapp/features/user/domain/use_cases/add_user/add_user_usecase.dart';

// Session (réactive)
import 'package:volleyapp/features/session/domain/session_state_provider.dart';
import 'package:volleyapp/features/session/data/session_state_provider_reactive.dart';

final locator = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  locator.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Datasources

  locator.registerLazySingleton<AuthDatasource>(
    () => FirebaseAuthDatasource(firebaseAuth: locator<FirebaseAuth>()),
  );
  locator.registerLazySingleton<UserDatasource>(
    () => FirebaseUserDatasource(firestore: locator<FirebaseFirestore>()),
  );
  locator.registerLazySingleton<ClubDataSource>(
    () => FirebaseClubDatasource(firestore: locator<FirebaseFirestore>()),
  );

  locator.registerLazySingleton<ClubMembershipDataSource>(
    () => FirebaseClubMembershipDatasource(
      firestore: locator<FirebaseFirestore>(),
    ),
  );

  locator.registerLazySingleton<ClubRequestDataSource>(
    () =>
        FirebaseClubRequestDataSource(firestore: locator<FirebaseFirestore>()),
  );

  locator.registerLazySingleton<EventDatasource>(
    () => FirebaseEventDatasource(firestore: locator<FirebaseFirestore>()),
  );

  locator.registerLazySingleton<TeamDataSource>(
    () => FirebaseTeamDataSource(firestore: locator<FirebaseFirestore>()),
  );

  locator.registerLazySingleton<ClubTeamDataSource>(
    () => FirebaseClubTeamDatasource(firestore: locator<FirebaseFirestore>()),
  );

  locator.registerLazySingleton<TeamMembershipDataSource>(
    () => FirebaseTeamMembershipDatasource(
      firestore: locator<FirebaseFirestore>(),
    ),
  );
  // Repositories
  locator.registerLazySingleton<TeamRepository>(
    () => TeamRepositoryImpl(locator<TeamDataSource>()),
  );
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator<AuthDatasource>()),
  );
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(locator<UserDatasource>()),
  );
  locator.registerLazySingleton<ClubRepository>(
    () => ClubRepositoryImpl(locator<ClubDataSource>()),
  );

  locator.registerLazySingleton<ClubMembershipRepository>(
    () => ClubMembershipRepositoryImpl(locator<ClubMembershipDataSource>()),
  );

  locator.registerLazySingleton<ClubJoinRequestRepository>(
    () => ClubRequestRepositoryImpl(locator<ClubRequestDataSource>()),
  );
  locator.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(locator<EventDatasource>()),
  );

  locator.registerLazySingleton<ClubTeamRepository>(
    () => ClubTeamRepositoryImpl(locator<ClubTeamDataSource>()),
  );
  locator.registerLazySingleton<TeamMembershipRepository>(
    () => TeamMembershipRepositoryImpl(locator<TeamMembershipDataSource>()),
  );

  // Use cases
  locator.registerLazySingleton<GetAllClubUseCase>(
    () => GetAllClubUseCase(locator<ClubRepository>()),
  );
  locator.registerLazySingleton<GetAllTeamByClubId>(
    () => GetAllTeamByClubId(
      locator<ClubTeamRepository>(),
      locator<TeamRepository>(),
    ),
  );
  locator.registerLazySingleton<SignUpWithEmailUseCase>(
    () => SignUpWithEmailUseCase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<SignInWithEmailUseCase>(
    () => SignInWithEmailUseCase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<AddUserUseCase>(
    () => AddUserUseCase(locator<UserRepository>()),
  );

  locator.registerLazySingleton<AddClubUseCase>(
    () => AddClubUseCase(locator<ClubRepository>()),
  );
  locator.registerLazySingleton<AddTeamUseCase>(
    () => AddTeamUseCase(locator<TeamRepository>()),
  );

  locator.registerLazySingleton<AddClubMembershipUseCase>(
    () => AddClubMembershipUseCase(locator<ClubMembershipRepository>()),
  );

  locator.registerLazySingleton<GetFilteredClubByNameUseCase>(
    () => GetFilteredClubByNameUseCase(locator<ClubRepository>()),
  );

  locator.registerLazySingleton<SubmitClubJoinRequestUseCase>(
    () => SubmitClubJoinRequestUseCase(locator<ClubJoinRequestRepository>()),
  );
  locator.registerLazySingleton<GetAllEventByClubIdUseCase>(
    () => GetAllEventByClubIdUseCase(locator<EventRepository>()),
  );
  locator.registerLazySingleton<AddEventUseCase>(
    () => AddEventUseCase(locator<EventRepository>()),
  );
  locator.registerLazySingleton<GetClubUserIdUseCase>(
    () => GetClubUserIdUseCase(locator<ClubMembershipRepository>()),
  );
  locator.registerLazySingleton<AddClubTeamUseCase>(
    () => AddClubTeamUseCase(locator<ClubTeamRepository>()),
  );
  locator.registerLazySingleton<AddTeamMembershipUseCase>(
    () => AddTeamMembershipUseCase(locator<TeamMembershipRepository>()),
  );
  locator.registerLazySingleton<GetClubForCurrentUserUseCase>(
        () => GetClubForCurrentUserUseCase(authRepository: locator<AuthRepository>(),clubRepository: locator<ClubRepository>(),membershipRepository: locator<ClubMembershipRepository>()),
  );
  locator.registerLazySingleton<GetClubByIdUseCase>(
        () => GetClubByIdUseCase(locator<ClubRepository>()),
  );
  locator.registerLazySingleton<GetTeamByIdUseCase>(
        () => GetTeamByIdUseCase(locator<TeamRepository>()),
  );

  // Session provider
  locator.registerLazySingleton<SessionStateProvider>(
    () => SessionStateProviderReactive(
      membershipRepository: locator<ClubMembershipRepository>(),
      authRepository: locator<AuthRepository>(),
      userRepository: locator<UserRepository>(),
      authChangesStream: locator<FirebaseAuth>().authStateChanges(),
    ),
  );
}
