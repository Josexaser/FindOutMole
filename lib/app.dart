import 'package:findoutmole/screen/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

// PANTALLA PARA HACER CAMBIOS EN LA APP
class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            LoginPage(), // Pantalla de inicio de sesión     // Pantalla de inicio (Home),
      ),
    );
  }
}
