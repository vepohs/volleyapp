import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

enum SessionStatus { unknown, unauthenticated, authenticated }

abstract class SessionStateProvider {
  Stream<SessionStatus> get status;
  SessionStatus get current;
  void dispose();
}

class FirebaseSessionStateProvider implements SessionStateProvider {
  final _ctrl = StreamController<SessionStatus>.broadcast();
  late final StreamSubscription<User?> _sub;
  SessionStatus _current = SessionStatus.unknown;

  FirebaseSessionStateProvider() {
    // Seed immédiat (important pour ne pas bloquer indéfiniment sur /splash)
    final user = FirebaseAuth.instance.currentUser;
    _set(user == null ? SessionStatus.unauthenticated : SessionStatus.authenticated);

    // Ecoute des changements Firebase
    _sub = FirebaseAuth.instance.authStateChanges().listen((u) {
      _set(u == null ? SessionStatus.unauthenticated : SessionStatus.authenticated);
    }, onError: (_) {
      _set(SessionStatus.unauthenticated);
    });
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
  void dispose() {
    _sub.cancel();
    _ctrl.close();
  }
}
