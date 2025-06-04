import 'package:flutter/material.dart';

/// @class TextoInicial
/// @brief Widget que muestra el título de la pantalla de registro.
/// 
/// Presenta el texto "Nuevo Usuario" centrado y con estilo destacado.
class TextoInicial extends StatelessWidget {
  /// @brief Constructor del widget TextoInicial.
  /// @param key Clave opcional para el widget.
  const TextoInicial({super.key});

  /// @brief Construye el widget del título inicial.
  /// @param context Contexto de la aplicación.
  /// @return Widget con el texto estilizado.
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