// lib/vistas/pantalla_chat.dart

import 'package:flutter/material.dart';
import '../controladores/controlador_chat.dart';
import '../modelos/mensaje.dart';

class PantallaChat extends StatefulWidget {
  final String usuario;

  PantallaChat({required this.usuario});

  @override
  _PantallaChatState createState() => _PantallaChatState();
}

class _PantallaChatState extends State<PantallaChat> {
  final ControladorChat _controladorChat = ControladorChat();
  final TextEditingController _controladorMensaje = TextEditingController();
  List<Mensaje> _mensajes = [];

  @override
  void initState() {
    super.initState();
    _cargarMensajes();
    _controladorChat.conectarSocket((mensaje) {
      setState(() {
        _mensajes.add(mensaje);
      });
    });
  }

  @override
  void dispose() {
    _controladorChat.desconectarSocket();
    super.dispose();
  }

  void _cargarMensajes() async {
    try {
      final mensajes = await _controladorChat.obtenerMensajes();
      setState(() {
        _mensajes = mensajes;
      });
    } catch (e) {
      print('Error al cargar mensajes: $e');
    }
  }

  void _enviarMensaje() {
    if (_controladorMensaje.text.isNotEmpty) {
      final mensaje = Mensaje(
        username: widget.usuario,
        message: _controladorMensaje.text,
      );
      _controladorChat.enviarMensaje(mensaje);
      _controladorMensaje.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sala de Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _mensajes.length,
              itemBuilder: (context, index) {
                final msg = _mensajes[index];
                return ListTile(
                  title: Text(msg.username),
                  subtitle: Text(msg.message),
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
                    decoration: InputDecoration(hintText: 'Escribe un mensaje'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _enviarMensaje,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
