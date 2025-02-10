// lib/modelos/mensaje.dart

class Mensaje {
  final String username;
  final String message;

  Mensaje({required this.username, required this.message});

  // Convertir JSON a un objeto Mensaje
  factory Mensaje.desdeJson(Map<String, dynamic> json) {
    return Mensaje(
      username: json['username'],
      message: json['message'],
    );
  }

  // Convertir un objeto Mensaje a JSON
  Map<String, dynamic> aJson() {
    return {
      'username': username,
      'message': message,
    };
  }
}
