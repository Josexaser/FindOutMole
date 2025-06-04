import 'package:findoutmole/screen/login_screen/boton_nuevo_usuario.dart';
import 'package:findoutmole/screen/login_screen/boton_recuperar_contrasena.dart';
import 'package:findoutmole/screen/login_screen/text_find_out.dart';
import 'package:findoutmole/screen/login_screen/text_mole.dart';
import 'package:findoutmole/screen/FootBar.dart';
import 'package:flutter/material.dart';
import 'package:findoutmole/screen/login_screen/boton_acceder.dart';

/// @class LoginPage
/// @brief Pantalla principal de inicio de sesión de la aplicación.
/// 
/// Esta pantalla contiene los campos de usuario y contraseña, así como los botones
/// para acceder, recuperar contraseña y registrar un nuevo usuario.
class LoginPage extends StatelessWidget {
  /// @brief Constructor de la pantalla de login.
  /// @param key Clave opcional para el widget.
  const LoginPage({super.key});

  /// @brief Construye el widget de la pantalla de login.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa la pantalla de login.
  @override
  Widget build(BuildContext context) {
    final TextEditingController userController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo.
          SizedBox.expand(
            child: Image.asset('assets/images/2.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FindOutText(),
                const MoleText(),
                const Expanded(child: SizedBox(height: 280)),
                // Campo de usuario.
                _StyledInputField(
                  hintText: 'Usuario',
                  icon: Icons.person,
                  controller: userController,
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                // Campo de contraseña.
                _StyledInputField(
                  hintText: 'Contraseña',
                  icon: Icons.lock,
                  controller: passController,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                // Botón para acceder.
                BotonAcceder(
                  userController: userController,
                  passwordController: passController,
                ),
                const SizedBox(height: 10),
                // Botón para recuperar contraseña.
                const BotonRecuperarContrasena(),
                // Botón para registrar nuevo usuario.
                const BotonNuevoUsuario(),
              ],
            ),
          ),
        ],
      ),
      // Barra de navegación inferior.
      bottomNavigationBar: const FooterBar(),
    );
  }
}

/// @class _StyledInputField
/// @brief Campo de texto personalizado con estilo para usuario y contraseña.
/// 
/// Este widget muestra un campo de texto con icono, estilo personalizado y opción
/// para mostrar/ocultar el texto si es una contraseña.
class _StyledInputField extends StatefulWidget {
  /// @brief Texto de sugerencia para el campo.
  final String hintText;
  /// @brief Icono a mostrar en el campo.
  final IconData icon;
  /// @brief Controlador del campo de texto.
  final TextEditingController controller;
  /// @brief Indica si el texto debe ocultarse (para contraseñas).
  final bool obscureText;

  /// @brief Constructor del campo de texto personalizado.
  /// @param hintText Texto de sugerencia.
  /// @param icon Icono a mostrar.
  /// @param controller Controlador del campo.
  /// @param obscureText Indica si el texto debe ocultarse.
  const _StyledInputField({
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.obscureText,
  });

  @override
  State<_StyledInputField> createState() => _StyledInputFieldState();
}

/// @class _StyledInputFieldState
/// @brief Estado del widget _StyledInputField para manejar la visibilidad del texto.
class _StyledInputFieldState extends State<_StyledInputField> {
  late bool _obscureText;

  /// @brief Inicializa el estado del campo de texto.
  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  /// @brief Alterna la visibilidad del texto en el campo.
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  /// @brief Construye el widget del campo de texto.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa el campo de texto personalizado.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: widget.hintText,
            labelStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(widget.icon, color: Colors.white),
            suffixIcon:
                widget.obscureText
                    ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: _toggleObscureText,
                    )
                    : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 10,
            ),
          ),
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}