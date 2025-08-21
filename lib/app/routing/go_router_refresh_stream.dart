import 'dart:async';
import 'package:flutter/foundation.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _sub;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
    scheduleMicrotask(notifyListeners);
  }
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
