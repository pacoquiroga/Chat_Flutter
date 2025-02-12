// lib/main.dart

import 'package:chat_front2/vistas/pantalla_chats.dart';
import 'package:chat_front2/vistas/pantalla_login_firebase.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Verificar si hay un usuario autenticado
  User? user = FirebaseAuth.instance.currentUser;

  runApp(MiAplicacion(user: user));
}

class MiAplicacion extends StatelessWidget {
  final User? user;

  MiAplicacion({this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicación de Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: user == null ? PantallaLoginFirebase() : PantallaChats(),
    );
  }
}
