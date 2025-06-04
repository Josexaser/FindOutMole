import 'package:flutter/material.dart';

/// @class FooterBar
/// @brief Barra de pie de página reutilizable para la aplicación.
/// 
/// Muestra un texto de derechos reservados en la parte inferior de la pantalla.
class FooterBar extends StatelessWidget {
  /// @brief Constructor de la barra de pie de página.
  /// @param key Clave opcional para el widget.
  const FooterBar({super.key});

  /// @brief Construye el widget de la barra de pie de página.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa la barra de pie de página.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 50, // Ajusta la altura según lo que necesites
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          border: Border(
            top: BorderSide.none, // Asegura que no haya borde superior
          ),
        ),
        child: Align(
          alignment: Alignment.center, // Centra el texto verticalmente
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '© 2025 FindOutMole. Todos los derechos reservados.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}