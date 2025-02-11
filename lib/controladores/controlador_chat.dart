// lib/controladores/controlador_chat.dart
import 'package:firebase_database/firebase_database.dart';
import '../modelos/mensaje.dart';

class ControladorChat {
  final DatabaseReference _mensajesRef =
      FirebaseDatabase.instance.ref().child('mensajes');

  Stream<List<Mensaje>> obtenerMensajes(String usuario1, String usuario2) {
    return _mensajesRef.onValue.map((event) {
      final Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
      if (data == null) return [];

      List<Mensaje> mensajes = [];
      data.forEach((key, value) {
        final mensaje = Mensaje.fromMap(Map<String, dynamic>.from(value));
        // Filtrar mensajes solo entre estos dos usuarios
        if ((mensaje.remitente == usuario1 && mensaje.receptor == usuario2) ||
            (mensaje.remitente == usuario2 && mensaje.receptor == usuario1)) {
          mensajes.add(mensaje);
        }
      });

      // Ordenar mensajes por timestamp
      mensajes.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return mensajes;
    });
  }

  Future<void> enviarMensaje(Mensaje mensaje) async {
    await _mensajesRef.push().set(mensaje.toMap());
  }
}
