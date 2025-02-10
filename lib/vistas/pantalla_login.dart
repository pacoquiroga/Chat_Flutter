// lib/vistas/pantalla_login.dart

import 'package:flutter/material.dart';
import 'pantalla_chat.dart';

class PantallaLogin extends StatelessWidget {
  final TextEditingController controladorUsuario = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sala de Chat - Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controladorUsuario,
              decoration: InputDecoration(labelText: 'Nombre de usuario'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (controladorUsuario.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaChat(
                        usuario: controladorUsuario.text,
                      ),
                    ),
                  );
                }
              },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
