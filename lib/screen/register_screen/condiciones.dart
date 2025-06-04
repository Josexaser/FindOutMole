import 'package:findoutmole/screen/register_screen/terms_Screen.dart';
import 'package:flutter/material.dart';

/// @class Condiciones
/// @brief Widget para aceptar los términos y condiciones.
/// 
/// Muestra un checkbox y un enlace a los términos y condiciones.
/// Llama a [onChanged] cuando el usuario acepta o desmarca la casilla.
class Condiciones extends StatefulWidget {
  /// @brief Callback que se ejecuta cuando cambia el estado del checkbox.
  final void Function(bool accepted)? onChanged;

  /// @brief Constructor del widget Condiciones.
  /// @param key Clave opcional para el widget.
  /// @param onChanged Callback para cambios en el checkbox.
  const Condiciones({
    super.key,
    this.onChanged,
  });

  /// @brief Crea el estado asociado a este widget.
  /// @return Instancia de _CondicionesState.
  @override
  State<Condiciones> createState() => _CondicionesState();
}

/// @class _CondicionesState
/// @brief Estado del widget Condiciones para manejar la lógica del checkbox.
class _CondicionesState extends State<Condiciones> {
  bool _isChecked = false;

  /// @brief Construye el widget de condiciones.
  /// @param context Contexto de la aplicación.
  /// @return Widget con checkbox y enlace a términos.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (value) {
            setState(() {
              _isChecked = value ?? false;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(_isChecked);
            }
          },
        ),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Acepto los ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TermsScreen()),
                  );
                },
                style: estiloBoton(),
                child: const Text(
                  'términos y condiciones',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// @brief Estilo personalizado para el botón de términos.
  /// @return [ButtonStyle] con fondo transparente y overlay blanco.
  ButtonStyle estiloBoton() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
      overlayColor: WidgetStateProperty.all<Color>(
        Colors.white.withOpacity(0.1),
      ),
      padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
    );
  }
}