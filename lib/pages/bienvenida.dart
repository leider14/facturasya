import 'package:facturasya/pages/Login_page.dart';
import 'package:facturasya/pages/buscar.dart';
import 'package:facturasya/pages/participantes_sala.dart';
import 'package:facturasya/services/auth_google.dart';
import 'package:facturasya/services/sala.dart';
import 'package:facturasya/widgets/mywdgbutton.dart';
import 'package:facturasya/widgets/mywdgtextbutton.dart';
import 'package:facturasya/widgets/mywdgtextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Bienvenida extends StatefulWidget {
  const Bienvenida({Key? key}) : super(key: key);

  @override
  State<Bienvenida> createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
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
      backgroundColor: const Color.fromARGB(255, 54, 114, 244),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "assets/images/background.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
<<<<<<< Updated upstream
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BuscarUsuario(),
=======
                const SizedBox(height: 20),
                const Text(
                  'Sale Fuckbito',
                  textScaler: TextScaler.linear(2.0),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                const SizedBox(height: 40),
                //Caja de inicio de juego
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 50
                  ),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white
                  ),
                  child: Column(
                    children: [
                      //Mensaje a Usuario
                      FutureBuilder<String>(
                        future: AuthUser().getWelcomeMessage(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!,
                              textScaler: const TextScaler.linear(1.2),
                              style: const TextStyle(
                                color: const Color.fromARGB(255, 35, 35, 35),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
>>>>>>> Stashed changes
                      ),
                      const SizedBox(height: 20,),
                      MyWdgTextField(
                        title: "Pin de Juego",
                        hintText: "00000",
                        onQrPressed: () {
                          print("aca"); 
                        },
                      ),
                      const SizedBox(height: 20,),
                      MyWdgButton(
                        text: "Unirse a la Sala",
                        onPressed: () {
                          print("Crear Sala");
                        },
                      ),
                      const SizedBox(height: 20,),
                      MyWdgButton(
                        text: "Crear Sala",
                        color: Colors.green,
                        onPressed: () {
                          print("Crear Sala");
                        },
                      ),
                      const SizedBox(height: 20,),
                      MyWdgTextButton(
                        text: "Cerrar Sesión",
                        onPressed: () {
                          
                        },
                      )
                    ],
                  ),
                ),

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
                    final salaService = SalaService();
          
                    final nombresUsuario =
                        await salaService.obtenerParticipantesSala('ABCD1234');
                    print(nombresUsuario);
                  },
                  child: const Text('Ver a la lista de la sala'),
                ),
                
                
              ],
            ),
<<<<<<< Updated upstream
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
=======
          ),
        ],
>>>>>>> Stashed changes
      ),
    );
  }
}
