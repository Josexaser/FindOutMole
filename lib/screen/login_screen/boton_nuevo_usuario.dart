import 'package:flutter/material.dart';
import 'package:findoutmole/screen/register_screen/register.dart';

class BotonNuevoUsuario extends StatelessWidget {
  const BotonNuevoUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
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
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );
          },
          child: Text(
            'Nuevo Usuario',
            style: TextStyle(
              color: Colors.white, // Color del texto del botón
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
