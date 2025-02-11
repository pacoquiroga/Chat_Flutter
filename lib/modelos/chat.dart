class Chat {
  final String id;
  final String usuario1;
  final String usuario2;
  final String ultimoMensaje;
  final DateTime ultimaActividad;

  Chat({
    required this.id,
    required this.usuario1,
    required this.usuario2,
    this.ultimoMensaje = '',
    required this.ultimaActividad,
  });

  factory Chat.fromMap(Map<String, dynamic> map, String id) {
    return Chat(
      id: id,
      usuario1: map['usuario1'] ?? '',
      usuario2: map['usuario2'] ?? '',
      ultimoMensaje: map['ultimoMensaje'] ?? '',
      ultimaActividad:
          DateTime.fromMillisecondsSinceEpoch(map['ultimaActividad'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuario1': usuario1,
      'usuario2': usuario2,
      'ultimoMensaje': ultimoMensaje,
      'ultimaActividad': ultimaActividad.millisecondsSinceEpoch,
    };
  }
}
