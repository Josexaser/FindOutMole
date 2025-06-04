import 'package:flutter/material.dart';

/// @class FindOutText
/// @brief Widget que muestra el texto estilizado "Find Out" en la pantalla de login.
/// 
/// Este widget aplica un padding superior y lateral, y define el estilo visual del texto principal.
class FindOutText extends StatelessWidget {
  /// @brief Constructor del widget FindOutText.
  /// @param key Clave opcional para el widget.
  const FindOutText({super.key});

  /// @brief Construye el widget de texto "Find Out".
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa el texto estilizado.
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