import 'package:flutter/material.dart';
// import '../controladores/controlador_auth.dart';
import 'pantalla_login.dart';

class PantallaAuth extends StatefulWidget {
  @override
  _PantallaAuthState createState() => _PantallaAuthState();
}

class _PantallaAuthState extends State<PantallaAuth> {
  // final ControladorAuth _auth = ControladorAuth();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _esRegistro = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_esRegistro) {
          // await _auth.registrar(
          //   _emailController.text,
          //   _passwordController.text,
          // );
        } else {
          // await _auth.iniciarSesion(
          //   _emailController.text,
          //   _passwordController.text,
          // );
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PantallaLogin()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esRegistro ? 'Registro' : 'Inicio de Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese una contraseña' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_esRegistro ? 'Registrarse' : 'Iniciar Sesión'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _esRegistro = !_esRegistro;
                  });
                },
                child: Text(_esRegistro
                    ? '¿Ya tienes cuenta? Inicia sesión'
                    : '¿No tienes cuenta? Regístrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
