// lib/vistas/pantalla_login.dart

import 'package:flutter/material.dart';
import '../controladores/controlador_usuarios.dart';
import 'pantalla_chat.dart';

class PantallaLogin extends StatelessWidget {
  final TextEditingController controladorUsuarioActual =
      TextEditingController();
  final ControladorUsuarios _controladorUsuarios = ControladorUsuarios();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Chat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controladorUsuarioActual,
              decoration: InputDecoration(labelText: 'Tu nombre de usuario'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<String>>(
                stream: _controladorUsuarios.obtenerUsuariosUnicos(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final usuarios = snapshot.data!;

                  return ListView.builder(
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final otroUsuario = usuarios[index];

                      return ListTile(
                        title: Text(otroUsuario),
                        onTap: () {
                          if (controladorUsuarioActual.text.isNotEmpty &&
                              controladorUsuarioActual.text != otroUsuario) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PantallaChat(
                                  usuarioActual: controladorUsuarioActual.text,
                                  otroUsuario: otroUsuario,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Por favor ingresa tu nombre de usuario y selecciona otro usuario diferente'),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
