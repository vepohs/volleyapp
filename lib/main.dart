import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _addUser() async {
    final users = FirebaseFirestore.instance.collection('users');
    await users.add({
      'nom': 'Durand',
      'prenom': 'Alice',
      'email': 'alice@example.com',
      'createdAt': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajout utilisateur Firebase")),
      body: Center(
        child: ElevatedButton(
          onPressed: _addUser,
          child: const Text("Ajouter un utilisateur"),
        ),
      ),
    );
  }
}
