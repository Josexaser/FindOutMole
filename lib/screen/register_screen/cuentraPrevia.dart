import 'package:findoutmole/screen/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

/// @class CuentaExiste
/// @brief Widget que muestra un enlace para usuarios que ya tienen cuenta.
/// 
/// Permite navegar a la pantalla de inicio de sesión al hacer tap en el texto.
class CuentaExiste extends StatelessWidget {
  /// @brief Constructor del widget CuentaExiste.
  /// @param key Clave opcional para el widget.
  const CuentaExiste({super.key});

  /// @brief Construye el widget del enlace a inicio de sesión.
  /// @param context Contexto de la aplicación.
  /// @return Widget con el texto y la navegación.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navega a la pantalla de inicio de sesión
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
      child: const Text(
        '¿Ya tienes cuenta? Inicia sesión',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}