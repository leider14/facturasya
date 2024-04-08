import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthUser{
  Future logingGoogle()async{
    final acoountGoogle = await GoogleSignIn().signIn();
    final googleAuth = await acoountGoogle?.authentication;
    final credential= GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }
  Future<void> signOutGoogle() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}