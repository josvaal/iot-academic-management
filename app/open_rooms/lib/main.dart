import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_rooms/firebase_options.dart';
import 'package:open_rooms/project/pages/login.dart';
import 'package:open_rooms/project/routes/app_route_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthStateScreen(),
    );
  }
}

class AuthStateScreen extends StatefulWidget {
  const AuthStateScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthStateScreenState createState() => _AuthStateScreenState();
}

class _AuthStateScreenState extends State<AuthStateScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Cargando...",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            return Scaffold(
              body: MaterialApp.router(
                title: "Open Rooms",
                routerConfig: router,
                debugShowCheckedModeBanner: false,
              ),
            );
          } else {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Login(),
            );
          }
        },
      ),
    );
  }
}
