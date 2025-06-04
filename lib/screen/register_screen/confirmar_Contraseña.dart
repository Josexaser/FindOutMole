import 'package:flutter/material.dart';

/// @class ConfirmPasswordField
/// @brief Campo de texto para confirmar la contraseña con validación visual.
/// 
/// Muestra un campo de confirmación de contraseña y valida que coincida con la contraseña principal.
class ConfirmPasswordField extends StatefulWidget {
  /// @brief Controlador para la confirmación de contraseña.
  final TextEditingController controller;
  /// @brief Controlador para la contraseña principal.
  final TextEditingController passwordController;

  /// @brief Constructor del campo de confirmación de contraseña.
  /// @param controller Controlador para la confirmación.
  /// @param passwordController Controlador para la contraseña principal.
  /// @param key Clave opcional para el widget.
  const ConfirmPasswordField({
    super.key,
    required this.controller,
    required this.passwordController,
  });

  /// @brief Crea el estado asociado a este widget.
  /// @return Instancia de _ConfirmPasswordFieldState.
  @override
  _ConfirmPasswordFieldState createState() => _ConfirmPasswordFieldState();
}

/// @class _ConfirmPasswordFieldState
/// @brief Estado del campo de confirmación de contraseña para manejar la lógica de validación.
class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _isObscured = true;
  String? _errorText;

  /// @brief Valida que la confirmación de contraseña no esté vacía y coincida.
  /// @param value Valor ingresado en el campo de confirmación.
  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorText = 'La confirmación de la contraseña no puede estar vacía';
      } else if (value != widget.passwordController.text) {
        _errorText = 'Las contraseñas no coinciden';
      } else {
        _errorText = null; // No hay error
      }
    });
  }

  /// @brief Construye el widget del campo de confirmación de contraseña.
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
              labelText: 'Confirmar Contraseña',
              labelStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.lock, color: Colors.white),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
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
            style: const TextStyle(color: Colors.black, fontSize: 16.0),
            onChanged: _validateConfirmPassword,
          ),
        ),
      ],
    );
  }
}