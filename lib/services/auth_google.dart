import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Import Firestore

class AuthUser {
  Future<User?> loginGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      // lo registra si es nuevo
      if (userCredential.additionalUserInfo!.isNewUser) {
        
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user!.uid)
            .set({
          'username': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
          'created_at': DateTime.now(),
        });
      }

      return user;

    } catch (e) {
      print('Error logging in with Google: $e');
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
  Future<String> getWelcomeMessage() async {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user == null) {
      return 'No se ha iniciado sesión';
    }

    // Get the user's document from Firestore
    final userDoc = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid);

    // Get the username from the document
    final snapshot = await userDoc.get();
    if (snapshot.exists) {
      final userData = snapshot.data();
      final username = userData?['username'] ?? '';
      return 'Bienvenido, $username!';
    } else {
      return 'Error al recuperar datos del usuario';
    }
  }

}
