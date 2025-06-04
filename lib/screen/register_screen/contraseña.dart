import 'package:flutter/material.dart';

/// @class PasswordField
/// @brief Campo de texto para ingresar la contraseña con validación visual.
/// 
/// Muestra un campo de contraseña y valida que cumpla los requisitos de seguridad.
class PasswordField extends StatefulWidget {
  /// @brief Controlador para la contraseña.
  final TextEditingController controller;

  /// @brief Constructor del campo de contraseña.
  /// @param controller Controlador para la contraseña.
  /// @param key Clave opcional para el widget.
  const PasswordField({
    super.key,
    required this.controller,
  });

  /// @brief Crea el estado asociado a este widget.
  /// @return Instancia de _PasswordFieldState.
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

/// @class _PasswordFieldState
/// @brief Estado del campo de contraseña para manejar la lógica de validación.
class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;
  String? _errorText;

  /// @brief Valida que la contraseña cumpla los requisitos de seguridad.
  /// @param value Valor ingresado en el campo de contraseña.
  void _validatePassword(String value) {
    final RegExp regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{6,}$',
    );

    setState(() {
      if (value.isEmpty) {
        _errorText = null; // No mostramos error si el campo está vacío
      } else if (!regex.hasMatch(value)) {
        _errorText =
            'Debe tener al menos 6 caracteres, 1 letra mayúscula, 1 número y 1 carácter especial';
      } else {
        _errorText = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Validamos desde el principio si ya hay algo escrito
    _validatePassword(widget.controller.text);

    widget.controller.addListener(() {
      _validatePassword(widget.controller.text);
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {
      _validatePassword(widget.controller.text);
    });
    super.dispose();
  }

  /// @brief Construye el widget del campo de contraseña.
  /// @param context Contexto de la aplicación.
  /// @return Widget con el campo de texto y validación.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 253, 253, 253).withOpacity(0.3),
                const Color.fromARGB(255, 251, 252, 252).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 253, 253, 253).withOpacity(0.1),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: _isObscured,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              labelStyle: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.lock,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 10.0,
              ),
              errorText: _errorText,
            ),
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 16.0,
            ),
            onChanged: _validatePassword,
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}