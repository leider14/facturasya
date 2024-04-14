import 'package:facturasya/pages/Signup.dart';
import 'package:facturasya/pages/bienvenida.dart';
import 'package:facturasya/services/auth_google.dart';
import 'package:facturasya/widgets/mywdgbutton.dart';
import 'package:facturasya/widgets/mywdgtextbutton.dart';
import 'package:facturasya/widgets/mywdgtextfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 54, 114, 244),
      body:   SingleChildScrollView(
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
                  const Padding(
                    padding:  EdgeInsets.only(left: 20,bottom: 10),
                    child: Text("Iniciar Sesión",
                    textScaler: TextScaler.linear(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),),
                  ),
                  const Padding(
                    padding:  EdgeInsets.only(left: 20,bottom: 5),
                    child: Text("Ingresa a tu cuenta y sumérgete en la experiencia digital que tenemos para ti.",
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
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //const SizedBox(height: 30.0),
                        MyWdgTextField(
                          textEditingController: _emailController,
                          title: "Correo Electrónico",
                          hintText: "fuckbito@email.com",
                        ),
                        const SizedBox(height: 20.0),
                        MyWdgTextField(
                          textEditingController: _passwordController,
                          title: "Contraseña",
                          hintText: "********",
                        ),
                        const SizedBox(height: 20.0),
                        MyWdgButton(
                          text: "Iniciar Sesión",
                          color: Colors.blue,
                          onPressed: () async {
                            try {
                              UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
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
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                    'Error al iniciar sesión. Por favor, inténtalo de nuevo.'),
                              ));
                            }
                          },
                        ),
                        const SizedBox(height: 10.0),
                        MyWdgButton(
                          text: "Iniciar con Google",
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
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.1,
                        ),
                        MyWdgTextButton(
                          text: '¿No tienes una cuenta? Regístrate',
                          
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return  const Signup();
                            }));
                          },
                        ),
                      ],
                    ),
                  ),
                ),]
              ),
            ],
          ),
        ),
      ),
    );
  }
}
