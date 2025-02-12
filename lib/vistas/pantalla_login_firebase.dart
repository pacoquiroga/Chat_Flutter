import 'package:chat_front2/services/auth_service.dart';
import 'package:chat_front2/vistas/pantalla_chats.dart';
import 'package:flutter/material.dart';

class PantallaLoginFirebase extends StatefulWidget {
  const PantallaLoginFirebase({super.key});

  @override
  State<PantallaLoginFirebase> createState() => _PantallaLoginFirebaseState();
}

class _PantallaLoginFirebaseState extends State<PantallaLoginFirebase> {
  bool isLogin = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Agregar esta función para validar el formato del email
  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  // Modificar la función para limpiar campos
  void _limpiarCampos() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    // Resetear el estado del formulario para eliminar mensajes de validación
    _formKey.currentState?.reset();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await AuthService().signup(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Mostrar mensaje de éxito
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro exitoso'),
              backgroundColor: Colors.green,
            ),
          );
          // Limpiar campos y cambiar a login
          _limpiarCampos();
          setState(() {
            isLogin = true;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await AuthService().signin(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PantallaChats()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xff232526), Color(0xff414345)],
          stops: [0, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botones de alternancia
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Primero limpiar campos y validaciones
                                _limpiarCampos();
                                setState(() {
                                  isLogin = true;
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    isLogin ? Colors.blue : Colors.grey,
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Iniciar Sesión'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Primero limpiar campos y validaciones
                                _limpiarCampos();
                                setState(() {
                                  isLogin = false;
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    !isLogin ? Colors.blue : Colors.grey,
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Registrarse'),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          height: 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  color:
                                      isLogin ? Colors.blue : Colors.grey[300],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color:
                                      !isLogin ? Colors.blue : Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Campo de Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.white54,
                            ),
                            prefixIconColor: WidgetStateColor.resolveWith(
                              (states) => states.contains(WidgetState.focused)
                                  ? Colors.blue
                                  : Colors.white54,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su email';
                            }
                            if (!isValidEmail(value)) {
                              return 'Por favor ingrese un email válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // Campo de Contraseña
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.white54,
                            ),
                            prefixIconColor: WidgetStateColor.resolveWith(
                              (states) => states.contains(WidgetState.focused)
                                  ? Colors.blue
                                  : Colors.white54,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su contraseña';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // Campo de Confirmación de Contraseña (solo en modo registro)
                        if (!isLogin) ...[
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            cursorColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Confirmar Contraseña',
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.white54,
                              ),
                              prefixIconColor: WidgetStateColor.resolveWith(
                                (states) => states.contains(WidgetState.focused)
                                    ? Colors.blue
                                    : Colors.white54,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor confirme su contraseña';
                              }
                              if (value.length < 5) {
                                return 'La contraseña debe tener al menos 5 caracteres';
                              }
                              if (value != _passwordController.text) {
                                return 'Las contraseñas no coinciden';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Botón de Email/Password
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (!isLogin) {
                                    _handleSignup();
                                  } else {
                                    _handleLogin();
                                  }
                                },
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  isLogin ? 'Iniciar Sesión' : 'Registrarse',
                                ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
