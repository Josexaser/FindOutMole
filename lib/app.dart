import 'package:findoutmole/screen/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

/// @class AppHome
/// @brief Widget raíz de la aplicación.
/// 
/// Muestra la pantalla de inicio de sesión al arrancar la app.
class AppHome extends StatelessWidget {
  /// @brief Constructor del widget AppHome.
  /// @param key Clave opcional para el widget.
  const AppHome({super.key});

  /// @brief Construye el widget principal de la aplicación.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa la pantalla inicial.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoginPage(), // Pantalla de inicio de sesión
      ),
    );
  }
}