// lib/modelos/mensaje.dart

class Mensaje {
  final String remitente;
  final String receptor;
  final String texto;
  final String hora;

  Mensaje({
    required this.remitente,
    required this.receptor,
    required this.texto,
    String? hora,
  }) : hora = hora ??
            "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}";

  Map<String, dynamic> toJson() => {
        'remitente': remitente,
        'receptor': receptor,
        'texto': texto,
        'hora': hora,
      };

  static Mensaje fromJson(Map<String, dynamic> json) => Mensaje(
        remitente: json['remitente'],
        receptor: json['receptor'],
        texto: json['texto'],
        hora: json['hora'],
      );
}
