import 'package:firebase_auth/firebase_auth.dart';

Future<bool> methodLogin(String email, String password) async {
  final auth = FirebaseAuth.instance;
  try {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      // print('No user found for that email.');
      return false;
    } else if (e.code == 'wrong-password') {
      //print('Wrong password provided for that user.');
      return false;
    }
  }
  return false;
}
