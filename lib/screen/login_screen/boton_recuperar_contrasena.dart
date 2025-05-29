import 'package:findoutmole/screen/login_screen/screen_password.dart';
import 'package:flutter/material.dart';

class BotonRecuperarContrasena extends StatelessWidget {
  const BotonRecuperarContrasena({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScreenPassword()),
            );
          },
          child: const Text(
            'Recuperar contraseña',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
