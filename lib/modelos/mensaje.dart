// lib/modelos/mensaje.dart

class Mensaje {
  final String remitente;
  final String receptor;
  final String texto;
  final String hora;
  final int timestamp;

  Mensaje({
    required this.remitente,
    required this.receptor,
    required this.texto,
    String? hora,
    int? timestamp,
  })  : hora = hora ?? _obtenerHoraActual(),
        timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  static String _obtenerHoraActual() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  factory Mensaje.fromMap(Map<String, dynamic> map) {
    return Mensaje(
      remitente: map['remitente'] ?? '',
      receptor: map['receptor'] ?? '',
      texto: map['texto'] ?? '',
      hora: map['hora'] ?? '',
      timestamp: map['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'remitente': remitente,
      'receptor': receptor,
      'texto': texto,
      'hora': hora,
      'timestamp': timestamp,
    };
  }
}
