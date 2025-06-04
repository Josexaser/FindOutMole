import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:findoutmole/screen/login_screen/login_screen.dart';

/// @class WelcomeScreen
/// @brief Pantalla de bienvenida con advertencias e información.
/// 
/// Muestra mensajes importantes y redirige automáticamente a la pantalla de login.
class WelcomeScreen extends StatefulWidget {
  /// @brief Constructor de la pantalla de bienvenida.
  /// @param key Clave opcional para el widget.
  const WelcomeScreen({super.key});

  /// @brief Crea el estado asociado a este widget.
  /// @return Instancia de _WelcomeScreenState.
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

/// @class _WelcomeScreenState
/// @brief Estado de la pantalla WelcomeScreen para manejar la lógica de navegación.
class _WelcomeScreenState extends State<WelcomeScreen> {
  /// @brief Inicializa el estado y navega a login tras 6 segundos.
  @override
  void initState() {
    super.initState();
    // Navega a la pantalla de login después de 6 segundos
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  /// @brief Construye el widget principal de la pantalla de bienvenida.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa la pantalla de bienvenida.
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
          // Capa con degradado para mejorar el contraste del texto
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black45,
                  Colors.transparent,
                  Colors.black45,
                ],
              ),
            ),
          ),
          // Contenido con desenfoque
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          // Contenido de la pantalla
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ícono central
                    const Icon(
                      Icons.warning,
                      color: Color.fromARGB(255, 255, 191, 1),
                      size: 80,
                    ),
                    const SizedBox(height: 24),
                    // Título
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text(
                          'Bienvenido a FindOutMole',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Mensaje informativo
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Text(
                              'Esta aplicación ofrece una evaluación preliminar basada en imágenes, '
                              'pero no reemplaza el diagnóstico médico profesional.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Advertencia
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.medical_services,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Text(
                              'Si tienes dudas o notas cambios en tu piel, consulta siempre a un dermatólogo. '
                              'Tu salud es lo primero.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Cargando...
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}