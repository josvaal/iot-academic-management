import 'package:firebase_auth/firebase_auth.dart';

Future<void> methodLogout() async {
  await FirebaseAuth.instance.signOut();
}
