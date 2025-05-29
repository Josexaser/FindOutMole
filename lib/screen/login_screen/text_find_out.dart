import 'package:flutter/material.dart';

class FindOutText extends StatelessWidget {
  const FindOutText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding solo para el texto superior
      padding: EdgeInsets.only(
        top: 40, // Píxeles de margen arriba
        left: 1, // Píxeles desde la izquierda
        right: 10, // Píxeles desde la derecha
      ),
      child: Text(
        // Texto "Find Out" y sus características
        'Find Out',
        style: TextStyle(
          fontSize: 38, // Tamaño de la fuente
          fontWeight: FontWeight.w600, // Estilo de la fuente (negrita)
          color: Color(0xFF1A1A40), // Color del texto
          fontFamily: 'Georgia', // Estilo Texto
          height: 0.7, // Controla la separación vertical
        ),
      ),
    );
  }
}
