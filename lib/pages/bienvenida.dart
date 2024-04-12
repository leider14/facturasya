import 'package:facturasya/pages/Login_page.dart';
import 'package:facturasya/pages/buscar.dart';
import 'package:facturasya/pages/participantes_sala.dart';
import 'package:facturasya/services/auth_google.dart';
import 'package:facturasya/services/sala.dart';
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
  final TextEditingController salaController = TextEditingController();
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
            FutureBuilder<String>(
              future: AuthUser().getWelcomeMessage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Has iniciado sesión exitosamente.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: salaController,
              decoration: const InputDecoration(
                labelText: 'Codigo sala',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
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
                    // Muestra el diálogo de espera
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return const AlertDialog(
                          title: Text('Cerrando sesión'),
                          content: Text('Por favor, espera...'),
                          actions: [],
                        );
                      },
                    );

                    // Obtiene el usuario actual
                    final user = FirebaseAuth.instance.currentUser;

                    // Determina el método de inicio de sesión
                    if (user?.providerData.isNotEmpty ?? false) {
                      // Cierre de sesión de Google
                      await AuthUser().signOutGoogle();
                    } else {
                      // Cierre de sesión con correo electrónico y contraseña
                      await FirebaseAuth.instance.signOut();
                    }

                    // Cierra el diálogo de espera
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);

                    // Navega a la página de inicio de sesión
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text('Cerrar sesión'),
                ),
              ],
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () async {
                final salaService = SalaService();

                await salaService.unirseASala(salaController.text);
              },
              child: const Text('Unirse a la sala'),
            ),
            ElevatedButton(
              onPressed: () async {
                final salaService = SalaService();

                await salaService.crearSala(salaController.text);
              },
              child: const Text('Crear sala'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ParticipantesSala(codigoSala: '9000')),
                );
              },
              child: const Text('Ver a la lista de la sala'),
            ),
          ],
        ),
      ),
    );
  }
}
