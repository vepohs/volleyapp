import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:volleyapp/app/di/service_locator.dart';
import 'package:volleyapp/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/foundation.dart' show kIsWeb;


Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    // Android / iOS → serverClientId requis
    await GoogleSignIn.instance.initialize(
      serverClientId: "269709383838-400gk9rr7vs2tqpomac38afi4eufilqc.apps.googleusercontent.com",
    );
  } else {
    // Web → pas de serverClientId
    await GoogleSignIn.instance.initialize();
  }

  await configureDependencies();

  runApp(await builder());
}
