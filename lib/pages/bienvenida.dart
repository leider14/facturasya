
import 'package:facturasya/pages/Login_page.dart';
import 'package:facturasya/pages/participantes_sala.dart';
import 'package:facturasya/services/auth_google.dart';
import 'package:facturasya/services/functions/funtions.dart';
import 'package:facturasya/services/sala.dart';
import 'package:facturasya/widgets/mywdgbutton.dart';
import 'package:facturasya/widgets/mywdgdialogloading.dart';
import 'package:facturasya/widgets/mywdgtextbutton.dart';
import 'package:facturasya/widgets/mywdgtextfield.dart';
import 'package:flutter/material.dart';

class Bienvenida extends StatefulWidget {
  const Bienvenida({Key? key}) : super(key: key);

  @override
  State<Bienvenida> createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {
  final TextEditingController salaController = TextEditingController();
  @override
  void initState() {
    _checkAuthentication();
    salaController.text = "";
    super.initState();
  }

  void _checkAuthentication() async {
    setState(() {});
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
                                color: Color.fromARGB(255, 35, 35, 35),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      const SizedBox(height: 20,),
                      MyWdgTextField(
                        title: "Pin de Juego",
                        hintText: "00000",
                        textEditingController: salaController,
                        keyboardType: TextInputType.number,
                        onQrPressed: () {

                        },
                      ),
                      const SizedBox(height: 20,),
                      MyWdgButton(
                        text: "Unirse a la Sala",
                        onPressed: ()  async {
                          hideKeyboard(context: context);
                          myWdgDialogLoading(context: context);
                          final salaService = SalaService();
                          await salaService.unirseASala(salaController.text).whenComplete(() {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ParticipantesSala(codigoSala: salaController.text);
                            },));
                          });
                        },
                      ),
                      const SizedBox(height: 20,),
                      MyWdgButton(
                        text: "Crear Sala",
                        color: Colors.green,
                        onPressed: () async {
                          hideKeyboard(context: context);
                          myWdgDialogLoading(context: context);
                          final salaService = SalaService();
                          await salaService.crearSala(salaController.text).whenComplete(() {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ParticipantesSala(codigoSala: salaController.text);
                            },));
                          });
                          
                        },
                      ),
                      const SizedBox(height: 20,),
                      MyWdgTextButton(
                        text: "Cerrar Sesión",
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
            
                          await signOutUser().whenComplete(() {
                            // Cierra el diálogo de espera
                            Navigator.pop(context);
              
                            // Navega a la página de inicio de sesión
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          });
            
                          
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
