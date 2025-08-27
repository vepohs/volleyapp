import 'dart:async';
import 'package:dartz/dartz.dart' show Option;
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:volleyapp/features/user/domain/repositories/user_repository.dart';

import 'package:volleyapp/features/session/domain/session_state_provider.dart';
import 'package:volleyapp/features/session/domain/session_status.dart';
import 'package:volleyapp/features/club_membership/domain/repositories/club_membership_repository.dart';

class SessionStateProviderReactive implements SessionStateProvider {
  final AuthRepository _authRepo;
  final UserRepository _userRepo;
  final ClubMembershipRepository _membershipRepo;

  final _ctrl = StreamController<SessionStatus>.broadcast();
  SessionStatus _current = SessionStatus.unknown;

  StreamSubscription? _authEventsSub;
  StreamSubscription? _profileSub;
  StreamSubscription? _membershipSub;

  SessionStateProviderReactive({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required ClubMembershipRepository membershipRepository,
    Stream<dynamic>? authChangesStream,
  })  : _authRepo = authRepository,
        _userRepo = userRepository,
        _membershipRepo = membershipRepository {
    _bind();
    _authEventsSub = authChangesStream?.listen((_) => _bind());
  }

  Future<void> _bind() async {
    await _profileSub?.cancel();
    await _membershipSub?.cancel();
    _profileSub = null;
    _membershipSub = null;

    final eitherAuth = await _authRepo.getCurrentUser();

    await eitherAuth.fold<Future<void>>(
          (_) async => _set(SessionStatus.unauthenticated),
          (Option authOpt) async {
        await authOpt.fold<Future<void>>(
              () async => _set(SessionStatus.unauthenticated),
              (authUser) async {
            _profileSub = _userRepo
                .watchUserById(id: authUser.id)
                .listen((optProfile) {
              final profile = optProfile.toNullable();
              if (profile == null || !profile.isProfileComplete) {
                _set(SessionStatus.profileIncomplete);
                return;
              }
              _membershipSub?.cancel();
              _membershipSub = _membershipRepo
                  .watchClubByUserId(userId: authUser.id)
                  .listen(
                    (optClub) {
                  if (optClub.isSome()) {
                    _set(SessionStatus.inClub);
                  } else {
                    _set(SessionStatus.noClub);
                  }
                },
                onError: (_) => _set(SessionStatus.noClub),
              );
            }, onError: (_) => _set(SessionStatus.profileIncomplete));
          },
        );
      },
    );
  }

  void _set(SessionStatus s) {
    if (_current != s) {
      _current = s;
      _ctrl.add(_current);
    }
  }

  @override
  Stream<SessionStatus> get status => _ctrl.stream;

  @override
  SessionStatus get current => _current;

  @override
  Future<void> refresh() => _bind();

  @override
  void dispose() {
    _authEventsSub?.cancel();
    _profileSub?.cancel();
    _membershipSub?.cancel();
    _ctrl.close();
  }
}
