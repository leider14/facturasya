import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facturasya/pages/bienvenida.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'USER NAME',
              ),
            ),
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
              onPressed: () {
                // Implementar la lógica de registro aquí
                _register();
              },
              child: Text('Registrarse'),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                // Navegar a la pantalla de inicio de sesión
              },
              child: Text('¿Ya tienes una cuenta? Inisia sesion'),
            ),
          ],
        ),
      ),
    );
  }

  void _register() async {
    // Intentamos crear un nuevo usuario con correo electrónico y contraseña
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Si la creación del usuario fue exitosa
      if (userCredential.user != null) {
        // Actualizamos el perfil del usuario con nombre de usuario y foto de perfil predeterminada
        await userCredential.user?.updateProfile(
          displayName: _usernameController.text,
          photoURL:
              "https://w7.pngwing.com/pngs/21/228/png-transparent-computer-icons-user-profile-others-miscellaneous-face-monochrome.png",
        );

        // Almacenamos los datos del usuario en Firestore
        await _firestore
            .collection('usuarios')
            .doc(userCredential.user!.uid)
            .set({
          'username': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'photoURL': 'https://w7.pngwing.com/pngs/21/228/png-transparent-computer-icons-user-profile-others-miscellaneous-face-monochrome.png',
          'created_at': DateTime.now(),
        });

        // Navegamos a la pantalla de bienvenida
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bienvenida()),
        );
      }
    } catch (e) {
      // Manejamos cualquier error que ocurra durante la creación del usuario
      print('Error al crear usuario: $e');
    }
  }
}
