// lib/vistas/pantalla_chat.dart

import 'package:flutter/material.dart';
import '../controladores/controlador_chat.dart';
import '../modelos/mensaje.dart';

class PantallaChat extends StatefulWidget {
  final String usuarioActual;
  final String otroUsuario;

  PantallaChat({
    required this.usuarioActual,
    required this.otroUsuario,
  });

  @override
  _PantallaChatState createState() => _PantallaChatState();
}

class _PantallaChatState extends State<PantallaChat> {
  final ControladorChat _controladorChat = ControladorChat();
  final TextEditingController _controladorMensaje = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat con ${widget.otroUsuario}')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Mensaje>>(
              stream: _controladorChat.obtenerMensajes(
                widget.usuarioActual,
                widget.otroUsuario,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final mensajes = snapshot.data!;
                return ListView.builder(
                  itemCount: mensajes.length,
                  itemBuilder: (context, index) {
                    final msg = mensajes[index];
                    final esRemitente = msg.remitente == widget.usuarioActual;

                    return Align(
                      alignment: esRemitente
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color:
                              esRemitente ? Colors.blue[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: esRemitente
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(msg.texto),
                            Text(
                              msg.hora,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controladorMensaje,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controladorMensaje.text.isNotEmpty) {
                      _controladorChat.enviarMensaje(Mensaje(
                        remitente: widget.usuarioActual,
                        receptor: widget.otroUsuario,
                        texto: _controladorMensaje.text,
                      ));
                      _controladorMensaje.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
