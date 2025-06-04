import 'package:flutter/material.dart';

/// @class MoleText
/// @brief Widget que muestra el texto estilizado "MOLE" centrado en la pantalla de login.
/// 
/// Este widget define el estilo visual y la alineación del texto principal "MOLE".
class MoleText extends StatelessWidget {
  /// @brief Constructor del widget MoleText.
  /// @param key Clave opcional para el widget.
  const MoleText({super.key});

  /// @brief Construye el widget de texto "MOLE".
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa el texto estilizado.
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center, // Alineación del texto "MOLE" centrado
      child: Text(
        'MOLE',
        style: TextStyle(
          fontSize: 108,
          fontWeight: FontWeight.bold,
          color: Color(0xFF3CF4FF),
          letterSpacing: 1.5,
          fontFamily: 'Montserrat',
          height: 1,
        ),
      ),
    );
  }
}