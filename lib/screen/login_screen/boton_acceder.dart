import 'package:findoutmole/screen/menu_screen/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Botón personalizado para acceder/iniciar sesión en la aplicación.
/// 
/// Recibe dos controladores de texto: uno para el usuario (correo electrónico)
/// y otro para la contraseña. Al presionarlo, intenta autenticar al usuario
/// usando Firebase Authentication. Si la autenticación es exitosa, navega a la
/// pantalla principal (`HomePage`). Si ocurre un error, muestra un mensaje
/// adecuado en un `SnackBar`.
class BotonAcceder extends StatelessWidget {
  /// Controlador para el campo de usuario (correo electrónico).
  final TextEditingController userController;

  /// Controlador para el campo de contraseña.
  final TextEditingController passwordController;

  /// Constructor del botón, requiere los controladores de usuario y contraseña.
  const BotonAcceder({
    super.key,
    required this.userController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
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
          // Acción al presionar el botón: intenta iniciar sesión con Firebase.
          onPressed: () async {
            final user = userController.text.trim();
            final password = passwordController.text.trim();

            try {
              // Intenta iniciar sesión con Firebase Authentication.
              UserCredential userCredential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: user, password: password);

              // Obtiene el token de autenticación del usuario.
              String? token = await userCredential.user?.getIdToken();

              // Navega a la pantalla principal, pasando el token.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(token: token ?? ''),
                ),
              );
            } on FirebaseAuthException catch (e) {
              // Manejo de errores específicos de Firebase Authentication.
              String errorMessage = 'Error al iniciar sesión';

              if (e.code == 'user-not-found') {
                errorMessage = 'No se encontró ningún usuario con ese correo';
              } else if (e.code == 'wrong-password') {
                errorMessage = 'Contraseña incorrecta';
              }

              // Muestra el mensaje de error en un SnackBar.
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(errorMessage)));
            } catch (e) {
              // Manejo de otros errores inesperados.
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          },
          child: const Text(
            'Acceder',
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
}