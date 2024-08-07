import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:open_rooms/project/methods/method_login.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool authError = false;
  String errorMessage = "";

  // ignore: no_leading_underscores_for_local_identifiers
  void _setAuthError(bool _authError, String _errorMessage) {
    setState(() {
      authError = _authError;
      errorMessage = _errorMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 35.0,
          ),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.blue.shade200,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: Colors.white,
              labelText: "Correo Electronico",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.blue.shade200,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.blue.shade200.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(
                  Icons.email,
                  color: Colors.blue.shade200,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            cursorColor: Colors.blue.shade200,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: Colors.white,
              labelText: "Contraseña",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.blue.shade200,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.blue.shade200.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(
                  Icons.lock,
                  color: Colors.blue.shade200,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Builder(
            builder: (context) {
              if (authError) {
                return Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
              return Container();
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
            child: LoadingBtn(
              width: MediaQuery.of(context).size.width * 1,
              animate: true,
              color: Colors.blue.shade200,
              height: 50,
              borderRadius: 50,
              loader: Container(
                padding: const EdgeInsets.all(10),
                width: 40,
                height: 40,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
              child: const Text(
                "Ingresar",
                style: TextStyle(color: Colors.black),
              ),
              onTap: (startLoading, stopLoading, btnState) async {
                if (btnState == ButtonState.idle) {
                  startLoading();
                  _setAuthError(false, "");
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    bool loginSuccess = await methodLogin(
                      emailController.text,
                      passwordController.text,
                    );
                    if (!loginSuccess) {
                      stopLoading();
                      _setAuthError(true, "Ocurrió un error inesperado");
                    } else {
                      _setAuthError(false, "");
                    }
                  } else {
                    stopLoading();
                    _setAuthError(true, "Rellene los campos");
                  }

                  stopLoading();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
