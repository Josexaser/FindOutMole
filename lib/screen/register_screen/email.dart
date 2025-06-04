import 'package:flutter/material.dart';

/// @class EmailField
/// @brief Campo de texto para ingresar el correo electrónico con validación visual.
/// 
/// Muestra un campo de correo electrónico y valida que cumpla el formato adecuado.
class EmailField extends StatefulWidget {
  /// @brief Controlador para el correo electrónico.
  final TextEditingController controller;

  /// @brief Constructor del campo de correo electrónico.
  /// @param controller Controlador para el correo electrónico.
  /// @param key Clave opcional para el widget.
  const EmailField({
    super.key,
    required this.controller,
  });

  /// @brief Crea el estado asociado a este widget.
  /// @return Instancia de _EmailFieldState.
  @override
  _EmailFieldState createState() => _EmailFieldState();
}

/// @class _EmailFieldState
/// @brief Estado del campo de correo electrónico para manejar la lógica de validación.
class _EmailFieldState extends State<EmailField> {
  String _email = '';
  String? _errorText;

  /// @brief Valida el formato del correo electrónico.
  /// @param value Valor ingresado en el campo de correo.
  void _validateEmail(String value) {
    final RegExp regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (value.isEmpty) {
      setState(() {
        _errorText = 'El correo electrónico no puede estar vacío';
        _email = '';
      });
    } else if (!regex.hasMatch(value)) {
      setState(() {
        _errorText = 'Por favor, ingresa un correo electrónico válido';
        _email = '';
      });
    } else {
      setState(() {
        _errorText = null;
        _email = value;
      });
    }
  }

  /// @brief Construye el widget del campo de correo electrónico.
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
                const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              labelStyle: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.email,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 10.0,
              ),
              errorText: _errorText,
            ),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
            onChanged: (value) {
              setState(() {
                _email = value;
                _validateEmail(_email);
              });
            },
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              _errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}