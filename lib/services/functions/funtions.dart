import 'package:cloud_firestore/cloud_firestore.dart';

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


 

