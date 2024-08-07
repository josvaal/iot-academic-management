import 'package:flutter/material.dart';
import 'package:open_rooms/project/methods/method_logout.dart';
import 'package:open_rooms/project/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    print(currentUser?.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Perfil",
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: CustomButton(
              bg: Colors.blue.shade200,
              fg: Colors.black,
              action: methodLogout,
              title: "Cerrar sesión"),
        ),
      ),
    );
  }
}
