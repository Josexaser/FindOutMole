import 'package:flutter/material.dart';

class TextoInicial extends StatelessWidget {
  const TextoInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Nuevo\nUsuario',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 44,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
