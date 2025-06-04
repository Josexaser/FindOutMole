import 'package:flutter/material.dart';
import 'package:findoutmole/screen/register_screen/register.dart';

/// @class BotonNuevoUsuario
/// @brief Botón personalizado para navegar a la pantalla de registro de nuevo usuario.
/// 
/// Este botón, al ser presionado, redirige al usuario a la pantalla de registro
/// (`RegisterPage`) para crear una nueva cuenta.
class BotonNuevoUsuario extends StatelessWidget {
  /// @brief Constructor del botón de nuevo usuario.
  /// @param key Clave opcional para el widget.
  const BotonNuevoUsuario({super.key});
  
  /// @brief Construye el widget del botón.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa el botón de registro de nuevo usuario.
  @override
  Widget build(BuildContext context) {
    return Padding(
      // Aplica un padding horizontal para centrar el botón.
      padding: EdgeInsets.symmetric(horizontal: 50),
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
          // Acción al presionar el botón: navega a la pantalla de registro.
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