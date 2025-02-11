import 'package:firebase_database/firebase_database.dart';

class ControladorUsuarios {
  final DatabaseReference _mensajesRef =
      FirebaseDatabase.instance.ref().child('mensajes');

  Stream<List<String>> obtenerUsuariosUnicos() {
    return _mensajesRef.onValue.map((event) {
      final Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return [];

      Set<String> usuariosUnicos = {};

      data.values.forEach((mensaje) {
        usuariosUnicos.add(mensaje['remitente'] as String);
        usuariosUnicos.add(mensaje['receptor'] as String);
      });

      return usuariosUnicos.toList()..sort();
    });
  }
}
