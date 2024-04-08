import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Login_page.dart';

class BuscarUsuario extends StatefulWidget {
  const BuscarUsuario({Key? key}) : super(key: key);

  @override
  _BuscarUsuarioState createState() => _BuscarUsuarioState();
}

class _BuscarUsuarioState extends State<BuscarUsuario> {
  final TextEditingController _controladorBusqueda = TextEditingController();
  String username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar usuario'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controladorBusqueda,
              decoration: const InputDecoration(
                labelText: 'Buscar...',
              ),
              onChanged: (texto) {
                setState(() {
                  username = texto;
                });
              },
            ),
          ),
          if (username.length >= 3)
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('usuarios')
                  .where('username', isGreaterThanOrEqualTo: username)
                  .where('username', isLessThan: username + 'z')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data?.docs.isEmpty ?? false) {
                    return Text('No existen usuarios con ese nombre');
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(doc['username']),
                          trailing: doc['username'] ==
                                  FirebaseAuth.instance.currentUser!.displayName
                              ? const ElevatedButton(
                                  
                                  onPressed:
                                      null, 
                                  child: Text('Tu'),
                                )
                              : FutureBuilder<DocumentSnapshot>(
                                  future: doc.reference
                                      .collection('seguidores')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data?.exists ?? false) {
                                        return ElevatedButton(
                                            onPressed: () async {
                                              await doc.reference
                                                  .collection('seguidores')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .delete();
                                              setState(() {});
                                            },
                                            child: Text('Dejar de seguir'));
                                      }
                                      return ElevatedButton(
                                          onPressed: () async {
                                            await doc.reference
                                                .collection('seguidores')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .set({'time': DateTime.now()});
                                            setState(() {});
                                          },
                                          child: Text('Seguir'));
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  }),
                        );
                      },
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
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
    );
  }
}
