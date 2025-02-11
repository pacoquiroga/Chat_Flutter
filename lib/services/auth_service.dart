import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('users');

  Future<void> signup({
    required String email,
    required String password,
  }) async {
    try {
      // Crear usuario en Authentication
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardar información del usuario en Realtime Database
      await _usersRef.child(userCredential.user!.uid).set({
        'email': email,
        'createdAt': ServerValue.timestamp,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'La contraseña es muy débil';
      } else if (e.code == 'email-already-in-use') {
        throw 'El email ya está en uso';
      }
      Fluttertoast.showToast(
        msg: e.message!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      throw 'Error desconocido';
    }
  }

  Future<UserCredential> signin({
    required String email,
    required String password,
  }) async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'Usuario no encontrado';
      } else if (e.code == 'wrong-password') {
        throw 'Contraseña incorrecta';
      }
      throw e.message ?? 'Error de autenticación';
    } catch (e) {
      throw 'Error al iniciar sesión';
    }
  }
}
