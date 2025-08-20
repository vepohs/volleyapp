import 'dart:async';
import 'package:volleyapp/features/auth/domain/ports/auth_state_source.dart';
import 'session_status.dart';


class SessionStateProvider {
  final AuthStateSource _auth;
  SessionStatus _current = SessionStatus.unknown;
  SessionStatus get current => _current;

  late final Stream<SessionStatus> status;

  SessionStateProvider(this._auth) {
    status = _mapToStatus();
  }

  Stream<SessionStatus> _mapToStatus() async* {

    final userOpt = _auth.getCurrentUser();
    _current = userOpt.isSome() ? SessionStatus.authenticated : SessionStatus.unauthenticated;
    yield _current;


    await for (final user in _auth.changes) {
      _current = (user == null) ? SessionStatus.unauthenticated : SessionStatus.authenticated;
      yield _current;
    }
  }
}
