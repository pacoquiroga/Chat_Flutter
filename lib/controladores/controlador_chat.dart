// lib/controladores/controlador_chat.dart
import 'package:firebase_database/firebase_database.dart';
import '../modelos/mensaje.dart';

class ControladorChat {
  final DatabaseReference _mensajesRef =
      FirebaseDatabase.instance.ref().child('mensajes');

  Future<void> enviarMensaje(Mensaje mensaje) async {
    await _mensajesRef.push().set(mensaje.toJson());
  }

  Stream<List<Mensaje>> obtenerMensajes(
      String usuarioActual, String otroUsuario) {
    return _mensajesRef.onValue.map((event) {
      final Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return [];

      var mensajes = data.entries
          .map((e) => Mensaje.fromJson(Map<String, dynamic>.from(e.value)))
          .where((mensaje) =>
              (mensaje.remitente == usuarioActual &&
                  mensaje.receptor == otroUsuario) ||
              (mensaje.remitente == otroUsuario &&
                  mensaje.receptor == usuarioActual))
          .toList();

      // Ordenar mensajes por hora incluyendo segundos
      mensajes.sort((a, b) {
        var horaA = a.hora.split(':').map(int.parse).toList();
        var horaB = b.hora.split(':').map(int.parse).toList();

        // Comparar horas
        if (horaA[0] != horaB[0]) {
          return horaA[0].compareTo(horaB[0]);
        }
        // Comparar minutos
        if (horaA[1] != horaB[1]) {
          return horaA[1].compareTo(horaB[1]);
        }
        // Comparar segundos
        return horaA[2].compareTo(horaB[2]);
      });

      return mensajes;
    });
  }
}
