import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facturasya/services/auth_google.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  

  /* Future<String> getUserFromFirebase(String uid, String campo) async {
  final collectionUser = _firestore.collection('usuarios').doc(uid);
  final querySnapshot = await collectionUser.get();
  final userData = querySnapshot.data();
  if (userData != null && userData[campo] != null) {
    return userData[campo];
  } else {
    return ""; 
  }
} */
String generateUid() {
  Random random = Random();
  String uid = '';
  for (int i = 0; i < 6; i++) {
    uid += random.nextInt(10).toString();
  }
  return uid;
}
Future<String> generarCodigoUinco() async {
    String codigo;
    do {
      codigo = generateUid();
      // Verifica si ya existe una sala con el código generado
      final salaSnapshot =
          await _firestore.collection('salas').doc(codigo).get();
      if (!salaSnapshot.exists) {
        // Si no existe, se ha encontrado un código único
        break;
      }
    } while (true);
    return codigo;
  }
 Future<Map<String, dynamic>> getUserFromFirebase(String uid) async {
  try {
    final querySnapshot = await _firestore.collection('usuarios').doc(uid).get();
    final userData = querySnapshot.data();
    if (userData != null) {
      return userData; 
    } else {
      return {};
    }
  } catch (error) {
   
    print('Error fetching user data: $error');
    return {};
  }
}

  Future<void> signOutUser() async {
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
  }


 

