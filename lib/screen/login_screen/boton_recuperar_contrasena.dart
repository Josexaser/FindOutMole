import 'package:findoutmole/screen/login_screen/screen_password.dart';
import 'package:flutter/material.dart';

/// @class BotonRecuperarContrasena
/// @brief Botón personalizado para navegar a la pantalla de recuperación de contraseña.
/// 
/// Este botón, al ser presionado, redirige al usuario a la pantalla de recuperación
/// de contraseña (`ScreenPassword`) para que pueda restablecer su clave de acceso.
class BotonRecuperarContrasena extends StatelessWidget {
  /// @brief Constructor del botón de recuperación de contraseña.
  /// @param key Clave opcional para el widget.
  const BotonRecuperarContrasena({super.key});

  /// @brief Construye el widget del botón.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa el botón de recuperación de contraseña.
  @override
  Widget build(BuildContext context) {
    return Padding(
      // Aplica un padding horizontal para centrar el botón.
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: TextButton(
          // Estilo del botón: transparente y con bordes redondeados.
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          // Acción al presionar el botón: navega a la pantalla de recuperación.
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