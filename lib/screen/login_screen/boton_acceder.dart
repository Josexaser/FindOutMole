
import 'package:findoutmole/screen/menu_screen/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BotonAcceder extends StatelessWidget {
  final TextEditingController userController;
  final TextEditingController passwordController;


  const BotonAcceder({
    super.key,
    required this.userController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Color(0xFF4DD0E1), Color(0xFF1976D2)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: TextButton(
          onPressed: () async {
  final user = userController.text.trim();
  final password = passwordController.text.trim();

  try {
    // Intenta iniciar sesión con Firebase
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: user,
      password: password,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  } on FirebaseAuthException catch (e) {
    // Si hay un error, muestra un mensaje
    String errorMessage = 'Error al iniciar sesión';

    if (e.code == 'user-not-found') {
      errorMessage = 'No se encontró ningún usuario con ese correo';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Contraseña incorrecta';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
},
          child: Text(
            'Acceder',
            style: TextStyle(
              color: Colors.white, // Color del texto del botón
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}