import 'package:facturasya/pages/Login_page.dart';
import 'package:facturasya/pages/buscar.dart';
import 'package:facturasya/services/auth_google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Bienvenida extends StatefulWidget {
  const Bienvenida({Key? key}) : super(key: key);

  @override
  State<Bienvenida> createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  @override
  void initState() {
    _checkAuthentication();
    super.initState();
  }

  void _checkAuthentication() async {
    _user = _auth.currentUser;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Hola!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text(
              'Has iniciado sesión exitosamente.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BuscarUsuario(),
                      ),
                    );
                  },
                  child: const Text('BuscarUsuario'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Cerrando sesión'),
                          content: const Text('Por favor, espera...'),
                          actions: [],
                        );
                      },
                    );

                    //await AuthUser().signOutGoogle();
                    await FirebaseAuth.instance.signOut();

                    Navigator.pop(context); // Cierra el diálogo
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: const Text('Cerrar sesión'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
