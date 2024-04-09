import 'package:facturasya/pages/Signup.dart';
import 'package:facturasya/pages/bienvenida.dart';
import 'package:facturasya/services/auth_google.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  print('inicio de sesion corectamente');
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const Scaffold(
                      body: Bienvenida(),
                    );
                  }));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'El correo electrónico ingresado no está registrado.'),
                    ));
                  } else if (e.code == 'wrong-password') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('La contraseña ingresada es incorrecta.'),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Error al iniciar sesión. Por favor, inténtalo de nuevo.'),
                    ));
                  }
                } catch (e) {
                  print('Error al iniciar sesión: $e');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Error al iniciar sesión. Por favor, inténtalo de nuevo.'),
                  ));
                }
              },
              child: Text('Iniciar sesión'),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () async {
                try {
                  final user = await AuthUser().loginGoogle();
                  if (user != null) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const Scaffold(
                        body: Bienvenida(),
                      );
                    }));
                  }
                } on FirebaseAuthException catch (error) {
                  print(error.message);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(error.message ?? 'Ups... Algo salio mal')));
                } catch (error) {
                  print(error);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(error.toString())));
                }
              },
              child: Text('Iniciar con google'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return Scaffold(
                    body: Signup(),
                  );
                }));
              },
              child: Text('¿No tienes una cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
