import 'dart:async';
import 'package:dartz/dartz.dart' show Option;
import 'package:volleyapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:volleyapp/features/user/domain/repositories/user_repository.dart';
import 'package:volleyapp/features/user/domain/entities/user.dart' as DomainUser;
import 'package:volleyapp/features/session/domain/session_state_provider.dart';
import 'package:volleyapp/features/session/domain/session_status.dart';

class SessionStateProviderReactive implements SessionStateProvider {
  final AuthRepository _authRepo;
  final UserRepository _userRepo;

  final _ctrl = StreamController<SessionStatus>.broadcast();
  SessionStatus _current = SessionStatus.unknown;

  StreamSubscription? _authEventsSub;
  StreamSubscription? _profileSub;

  SessionStateProviderReactive({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    Stream<dynamic>? authChangesStream,
  })  : _authRepo = authRepository,
        _userRepo = userRepository {
    _bind();
    _authEventsSub = authChangesStream?.listen((_) => _bind());
  }

  Future<void> _bind() async {
    await _profileSub?.cancel();
    _profileSub = null;

    final eitherAuth = await _authRepo.getCurrentUser();

    await eitherAuth.fold<Future<void>>(
          (_) async => _set(SessionStatus.unauthenticated),
          (Option authOpt) async {
        await authOpt.fold<Future<void>>(
              () async => _set(SessionStatus.unauthenticated),
              (authUser) async {
            _profileSub = _userRepo
                .watchUserById(id: authUser.id)
                .listen((Option<DomainUser.User> opt) {
              final next = opt.fold(
                    () => SessionStatus.profileIncomplete,
                    (u) => u.isProfileComplete
                    ? SessionStatus.authenticated
                    : SessionStatus.profileIncomplete,
              );
              _set(next);
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
    _ctrl.close();
  }
}
