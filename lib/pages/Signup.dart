import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facturasya/pages/bienvenida.dart';
import 'package:facturasya/widgets/mywdgbutton.dart';
import 'package:facturasya/widgets/mywdgbuttonicon.dart';
import 'package:facturasya/widgets/mywdgtextbutton.dart';
import 'package:facturasya/widgets/mywdgtextfield.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      backgroundColor: const Color.fromARGB(255, 54, 114, 244),

      body:SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
           child: Stack(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: MediaQuery.of(context).padding.top
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyWdgButtonIcon(
                          iconData: FontAwesomeIcons.handPointLeft,
                          colorButton: Colors.white,
                          colorIcon: Colors.blue,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const Text("  Atras",
                          textScaler: TextScaler.linear(1.5),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding:  EdgeInsets.only(left: 20,bottom: 10),
                    child: Text("Registrarse",
                    textScaler: TextScaler.linear(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),),
                  ),
                  const Padding(
                    padding:  EdgeInsets.only(left: 20,bottom: 5),
                    child: Text("¡Únete ahora y descubre un mundo de posibilidades con nuestra aplicación!",
                    textScaler: TextScaler.linear(1.2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20)
                    )
                  ),
                  child:  
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyWdgTextField(
                            title: "Nombre",
                            hintText: "Ronaldinho Gaúcho",
                            textEditingController: _usernameController,
                          ),
                          const SizedBox(height: 20.0),
                          MyWdgTextField(
                            title: "Correo",
                            hintText: "fuckbito@email.com",
                            textEditingController: _emailController,
                          ),
                          const SizedBox(height: 20.0),
                          MyWdgTextField(
                            title: "Contraseña",
                            isObscure: true,
                            hintText: "*****",
                            textEditingController: _passwordController,
                          ),
                          const SizedBox(height: 20.0),
                          MyWdgButton(
                            text: "Registrarse",
                            color: Colors.blue,
                            onPressed: () {
                              _register();
                            },
                          ),
                          const SizedBox(height: 80.0),
                          MyWdgTextButton(
                            text: "¿Ya tienes una cuenta? Inicia sesión",
                            onPressed: (){
                              Navigator.of(context).pop();
                            }
                          ),
                        ],
                      ),
                    ),
                  )
                ]
              )
            ]
           ),
         ),
       )
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
        await userCredential.user?.updatePhotoURL(
              "https://www.pngkey.com/png/detail/532-5327322_contact-us-human-icon-png.png",
        );

        // Almacenamos los datos del usuario en Firestore
        await _firestore
            .collection('usuarios')
            .doc(userCredential.user!.uid)
            .set({
          'username': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'photoURL': 'https://www.pngkey.com/png/detail/532-5327322_contact-us-human-icon-png.png',
          'created_at': DateTime.now(),
        }).whenComplete(() {
          // Navegamos a la pantalla de bienvenida
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Bienvenida()),
          );
        });

        
      }
    } catch (e) {
      // Manejamos cualquier error que ocurra durante la creación del usuario
      print('Error al crear usuario: $e');
    }
  }
}
