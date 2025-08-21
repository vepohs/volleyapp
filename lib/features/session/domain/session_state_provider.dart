import 'dart:async';
import 'session_status.dart';

abstract class SessionStateProvider {
  Stream<SessionStatus> get status;
  SessionStatus get current;
  Future<void> refresh();
  void dispose();
}
