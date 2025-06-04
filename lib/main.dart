import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:findoutmole/screen/WelcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

/// @class MainApp
/// @brief Widget principal de la aplicación.
/// 
/// Inicializa la app y muestra la pantalla de bienvenida.
class MainApp extends StatelessWidget {
  /// @brief Constructor del widget MainApp.
  /// @param key Clave opcional para el widget.
  const MainApp({super.key});

  /// @brief Construye el widget principal de la aplicación.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa la app.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}