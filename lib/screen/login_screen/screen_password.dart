import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findoutmole/screen/FootBar.dart';

/// @class ScreenPassword
/// @brief Pantalla para la recuperación de contraseña mediante correo electrónico.
/// 
/// Permite al usuario introducir su correo para recibir un enlace de restablecimiento de contraseña.
class ScreenPassword extends StatefulWidget {
  /// @brief Constructor de la pantalla de recuperación de contraseña.
  /// @param key Clave opcional para el widget.
  const ScreenPassword({super.key});

  /// @brief Crea el estado asociado a este widget.
  /// @return Instancia de ScreenPasswordState.
  @override
  ScreenPasswordState createState() => ScreenPasswordState();
}

/// @class ScreenPasswordState
/// @brief Estado de la pantalla de recuperación de contraseña.
class ScreenPasswordState extends State<ScreenPassword> {
  /// @brief Controlador para el campo de correo electrónico.
  final TextEditingController comprobacionCorreo = TextEditingController();

  /// @brief Construye el widget principal de la pantalla.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa la pantalla de recuperación de contraseña.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: configuracionAppBar(context),
      bottomNavigationBar: const FooterBar(), // Pie de página
      body: Stack(
        children: [
          imagenDeFondo(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: contenidoPagina(context),
            ),
          ),
        ],
      ),
    );
  }

  /// @brief Configura el AppBar transparente con botón de retroceso.
  /// @param context Contexto de la aplicación.
  /// @return AppBar personalizado.
  AppBar configuracionAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  /// @brief Devuelve la imagen de fondo ocupando toda la pantalla.
  /// @return Widget con la imagen de fondo.
  Widget imagenDeFondo() {
    return SizedBox.expand(
      child: Image.asset('assets/images/2.png', fit: BoxFit.cover),
    );
  }

  /// @brief Construye el contenido principal del formulario de recuperación.
  /// @param context Contexto de la aplicación.
  /// @return Widget con el contenido de la página.
  Widget contenidoPagina(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        const Text(
          'Recuperar Contraseña',
          style: TextStyle(
            color: Colors.white,
            fontSize: 44,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        textoBienvenida1(),
        const SizedBox(height: 10),
        textoBienvenida2(),
        const SizedBox(height: 40),
        palabraCorreo(),
        const SizedBox(height: 8),
        campoCorreo(),
        const SizedBox(height: 20),
        botonEnviar(context),
      ],
    );
  }

  /// @brief Texto de bienvenida principal.
  /// @return Widget con el texto de bienvenida.
  Widget textoBienvenida1() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '¿No recuerdas tu contraseña?',
        style: TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  /// @brief Texto de bienvenida secundario.
  /// @return Widget con el texto de ayuda.
  Widget textoBienvenida2() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '¡No te preocupes, nos pasa a todos! Introduce tu correo y te ayudaremos.',
        style: TextStyle(color: Colors.white, fontSize: 14),
        textAlign: TextAlign.left,
      ),
    );
  }

  /// @brief Muestra el texto "Correo" sobre el campo de entrada.
  /// @return Widget con el texto "Correo".
  Widget palabraCorreo() {
    return Container(
      alignment: Alignment.centerLeft,
      child: const Text(
        'Correo',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// @brief Campo de texto para el correo electrónico.
  /// @return Widget con el campo de correo.
  Widget campoCorreo() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
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
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: comprobacionCorreo,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Correo electrónico',
          labelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.email, color: Colors.white),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 10.0,
          ),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 16.0),
      ),
    );
  }

  /// @brief Botón para enviar el correo de recuperación.
  /// @param context Contexto de la aplicación.
  /// @return Widget con el botón de envío.
  Widget botonEnviar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF4DD0E1), Color(0xFF1976D2)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: TextButton(
          onPressed: () => funcionalidadEnvio(context),
          child: const Text(
            'Enviar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// @brief Envía el correo de recuperación de contraseña.
  /// @param context Contexto de la aplicación.
  /// @return void
  void funcionalidadEnvio(BuildContext context) async {
    final correo = comprobacionCorreo.text.trim().toLowerCase();
    if (correo.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Campo vacío'),
          content: const Text(
            'Por favor, introduce tu correo electrónico.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      return;
    }
    // Validación: formato de correo inválido
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(correo)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Correo no válido'),
          content: const Text(
            'Introduce un correo electrónico válido, por favor.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      return;
    }
    // Intento de envío del correo de recuperación
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: correo);
      // Diálogo de éxito
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Correo enviado'),
          content: const Text(
            'Hemos enviado un correo para restablecer tu contraseña. Revisa tu bandeja de entrada.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(
            'Ocurrió un error al enviar el correo: ${e.toString()}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }
}