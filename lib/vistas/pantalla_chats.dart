import 'package:chat_front2/vistas/pantalla_login_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_front2/modelos/chat.dart';
import 'package:chat_front2/vistas/pantalla_chat.dart';
import 'package:firebase_database/firebase_database.dart';

class PantallaChats extends StatefulWidget {
  const PantallaChats({super.key});

  @override
  State<PantallaChats> createState() => _PantallaChatState();
}

class _PantallaChatState extends State<PantallaChats> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _emailController = TextEditingController();
  final DatabaseReference _chatsRef =
      FirebaseDatabase.instance.ref().child('chats');

  void _mostrarDialogoNuevoChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          'Nuevo Chat',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email del contacto',
            hintText: 'Ingrese el email del usuario',
            labelStyle: TextStyle(
              color: Colors.white54,
            ),
            hintStyle: TextStyle(
              color: Colors.white38,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          cursorColor: Colors.white,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_emailController.text.isNotEmpty) {
                _crearNuevoChat(_emailController.text);
                Navigator.pop(context);
                _emailController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Crear Chat'),
          ),
        ],
      ),
    );
  }

  Stream<List<Chat>> _obtenerChats() {
    return _chatsRef.onValue.map((event) {
      final Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
      if (data == null) return [];

      return data.entries
          .map((entry) {
            final chat =
                Chat.fromMap(Map<String, dynamic>.from(entry.value), entry.key);
            if (chat.usuario1 == currentUser?.email ||
                chat.usuario2 == currentUser?.email) {
              return chat;
            }
            return null;
          })
          .where((chat) => chat != null)
          .cast<Chat>()
          .toList();
    });
  }

  Future<void> _crearNuevoChat(String otroUsuario) async {
    // Normalizar el email
    otroUsuario = otroUsuario.trim().toLowerCase();

    if (otroUsuario == currentUser?.email) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No puedes crear un chat contigo mismo'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Verificar si ya existe un chat con este usuario
      final chatsExistentes = await _chatsRef.get();
      if (chatsExistentes.exists) {
        final chatsMap = chatsExistentes.value as Map<dynamic, dynamic>;
        final chatExistente = chatsMap.values.any((chat) {
          final c = Map<String, dynamic>.from(chat);
          return (c['usuario1'] == currentUser?.email &&
                  c['usuario2'] == otroUsuario) ||
              (c['usuario1'] == otroUsuario &&
                  c['usuario2'] == currentUser?.email);
        });

        if (chatExistente) {
          if (mounted) {
            Navigator.pop(context); // Cerrar indicador de carga
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ya existe una conversación con este usuario'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }
      }

      // Crear nuevo chat directamente
      final nuevoChat = Chat(
        id: '',
        usuario1: currentUser?.email ?? '',
        usuario2: otroUsuario,
        ultimaActividad: DateTime.now(),
      );

      final newChatRef = await _chatsRef.push();
      await newChatRef.set(nuevoChat.toMap());

      if (mounted) {
        Navigator.pop(context); // Cerrar indicador de carga
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PantallaChat(
              usuarioActual: currentUser?.email ?? '',
              otroUsuario: otroUsuario,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Cerrar indicador de carga
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear el chat: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Mis Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.blue,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaLoginFirebase(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xff232526), Color(0xff414345)],
          stops: [0, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Chat>>(
            stream: _obtenerChats(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final chats = snapshot.data!;
              if (chats.isEmpty) {
                return const Center(
                    child: Text(
                  'No hay chats disponibles',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ));
              }

              return ListView.separated(
                itemCount: chats.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final otroUsuario = chat.usuario1 == currentUser?.email
                      ? chat.usuario2
                      : chat.usuario1;

                  return ListTile(
                    title: Text(
                      otroUsuario,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      chat.ultimaActividad.toString().substring(0, 19),
                      style: const TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PantallaChat(
                          usuarioActual: currentUser?.email ?? '',
                          otroUsuario: otroUsuario,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoNuevoChat,
        backgroundColor: Colors.black,
        foregroundColor: Colors.blue,
        child: const Icon(Icons.chat),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
