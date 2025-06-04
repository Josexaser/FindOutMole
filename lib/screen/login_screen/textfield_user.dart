import 'package:flutter/material.dart';

/// @class TexfieldUsuarioPassw
/// @brief Widget personalizado para campos de texto de usuario y contraseña.
/// 
/// Permite mostrar un campo de texto con icono, opción de ocultar el texto (para contraseñas)
/// y estilos personalizados.
class TexfieldUsuarioPassw extends StatefulWidget {
  /// @brief Texto de sugerencia para el campo.
  final String hintText;
  /// @brief Icono a mostrar en el campo.
  final IconData icon;
  /// @brief Indica si el texto debe ocultarse (para contraseñas).
  final bool obscureText;
  /// @brief Controlador del campo de texto.
  final TextEditingController controller;

  /// @brief Constructor del widget TexfieldUsuarioPassw.
  /// @param hintText Texto de sugerencia.
  /// @param icon Icono a mostrar.
  /// @param obscureText Indica si el texto debe ocultarse.
  /// @param controller Controlador del campo.
  /// @param key Clave opcional para el widget.
  const TexfieldUsuarioPassw({
    this.hintText = '',
    this.icon = Icons.person,
    this.obscureText = false,
    required this.controller,
    super.key,
  });

  /// @brief Crea el estado asociado a este widget.
  /// @return Instancia de _TexfieldUsuarioPasswState.
  @override
  State<TexfieldUsuarioPassw> createState() => _TexfieldUsuarioPasswState();
}

/// @class _TexfieldUsuarioPasswState
/// @brief Estado del widget TexfieldUsuarioPassw para manejar la visibilidad del texto.
class _TexfieldUsuarioPasswState extends State<TexfieldUsuarioPassw> {
  /// @brief Indica si el texto está oculto (para contraseñas).
  late bool _isObscured;

  /// @brief Inicializa el estado del campo de texto.
  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  /// @brief Construye el widget del campo de texto.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa el campo de texto personalizado.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        obscureText: _isObscured,
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon, color: Colors.white),
          hintText: widget.hintText,
          filled: true,
          fillColor: const Color.fromRGBO(255, 255, 255, 0.4),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}