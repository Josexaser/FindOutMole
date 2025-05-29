// import 'package:findoutmole/screen/login_screen/screen_new_password.dart'; En un principio no es necesario
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findoutmole/screen/FootBar.dart';

class ScreenPassword extends StatefulWidget {
  const ScreenPassword({super.key});
  //Estructura principal del widget
  @override
  ScreenPasswordState createState() => ScreenPasswordState();
}

class ScreenPasswordState extends State<ScreenPassword> {
  final TextEditingController comprobacionCorreo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: configuracionAppBar(context),
      bottomNavigationBar: const FooterBar(), // Pie de página
      body: Stack(
        // Stack es un Contenedor que permite colocar varios widgets en la pantalla y que los widgets se superpongan unos de otros.
        children: [
          imagenDeFondo(), // Metodo de configuracion de la imagen de fondo
          SafeArea(
            // SafeArea asegura que el contenido no se superponga a la barra de estado y la barra de navegación
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: contenidoPagina(context),
            ),
          ),
        ],
      ),
    );
  }

  // AppBar transparente con botón de retroceso. Permite que el appBar sea transparente y que el contenido de la pantalla se vea detrás de ella.
  AppBar configuracionAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // AppBar transparente
      elevation: 0, // Elimina la sombra del AppBar
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  // Imagen de fondo ocupando toda la pantalla
  Widget imagenDeFondo() {
    return SizedBox.expand(
      child: Image.asset('assets/images/2.png', fit: BoxFit.cover),
    );
  }

  // Contenido del formulario de recuperación
  Widget contenidoPagina(BuildContext context) {
    // Column principal centrada verticalmente con espacio alrededor
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        // Título principal de la pantalla
        const Text(
          'Recuperar Contraseña',
          style: TextStyle(
            color: Colors.white,
            fontSize: 44,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40), // Espacio entre título y textos
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

  // Texto de bienvenida1
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

  // Texto de bienvenida2
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

  // Texto Correo electrónico
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

  // Campo de texto para el correo electrónico (estilo Register)
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

  // Botón para enviar el correo (estilo Register)
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

  //Funcionalidad del botón para enviar el correo
  void funcionalidadEnvio(BuildContext context) async {
    final correo = comprobacionCorreo.text.trim().toLowerCase();
    ;
    if (correo.isEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
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
        builder:
            (context) => AlertDialog(
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
        builder:
            (context) => AlertDialog(
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
        builder:
            (context) => AlertDialog(
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
