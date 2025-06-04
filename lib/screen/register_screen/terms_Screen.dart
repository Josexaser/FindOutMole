import 'package:flutter/material.dart';

/// @class TermsScreen
/// @brief Pantalla que muestra los términos y condiciones de uso de la aplicación.
/// 
/// Permite al usuario leer los términos y regresar a la pantalla anterior.
class TermsScreen extends StatelessWidget {
  /// @brief Constructor del widget TermsScreen.
  /// @param key Clave opcional para el widget.
  const TermsScreen({super.key});

  /// @brief Construye el widget principal de la pantalla de términos y condiciones.
  /// @param context Contexto de la aplicación.
  /// @return Widget con los términos y condiciones.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/2.png',
              fit: BoxFit.cover,
            ),
          ),
          // Contenido principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // Regresa a la pantalla anterior
                        },
                      ),
                      const Text(
                        'Términos y Condiciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Contenido desplazable
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          '''
Términos y Condiciones de Uso

1. **Propósito de la Aplicación**:
   Esta aplicación tiene como objetivo proporcionar información y herramientas para el usuario. Sin embargo, no debe ser utilizada como un sustituto de asesoramiento médico profesional, diagnóstico o tratamiento.

2. **Consulta Médica**:
   En caso de dudas sobre tu salud o cualquier condición médica, siempre debes consultar a un médico o profesional de la salud calificado. Nunca ignores el consejo médico ni retrases la búsqueda de ayuda profesional debido a algo que hayas leído en esta aplicación.

3. **Uso Responsable**:
   El usuario es responsable de utilizar la aplicación de manera adecuada y de acuerdo con las leyes y regulaciones aplicables.

4. **Limitación de Responsabilidad**:
   Los desarrolladores de esta aplicación no se hacen responsables de cualquier daño, pérdida o perjuicio derivado del uso de la misma.

5. **Privacidad**:
   La aplicación recopila y utiliza datos personales de acuerdo con nuestra política de privacidad. Al usar esta aplicación, aceptas los términos de nuestra política de privacidad.

6. **Modificaciones**:
   Nos reservamos el derecho de modificar estos términos y condiciones en cualquier momento. Es responsabilidad del usuario revisar periódicamente los términos actualizados.

Al aceptar estos términos, confirmas que has leído, entendido y aceptado las condiciones de uso de esta aplicación.
                          ''',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}