import 'package:findoutmole/screen/login_screen/boton_nuevo_usuario.dart';
import 'package:findoutmole/screen/login_screen/boton_acceder.dart';
import 'package:findoutmole/screen/login_screen/boton_recuperar_contrasena.dart';
import 'package:findoutmole/screen/login_screen/text_find_out.dart';
import 'package:findoutmole/screen/login_screen/textfield_user.dart';
import 'package:flutter/material.dart';
import 'package:findoutmole/screen/login_screen/text_mole.dart';
import 'package:findoutmole/screen/FootBar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController userController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    return Scaffold(
      // Scaffold proporciona la estructura visual básica de la app (barra superior, body, etc.)
      body: Stack(
        // Stack permite superponer widgets uno encima de otro
        children: [
          SizedBox.expand(
            child: Image.asset('assets/images/2.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                FindOutText(),
                MoleText(),
                Expanded(child: SizedBox(height: 280)),

                TexfieldUsuarioPassw(
                  hintText: 'Usuario', // Texto dentro del campo
                  icon: Icons.person, // Icono de usuario
                  obscureText: false,
                  controller: userController,
                ),

                SizedBox(height: 20),

                TexfieldUsuarioPassw(
                  hintText: 'Contraseña',
                  icon: Icons.lock,
                  obscureText: true,
                  controller: passController,
                ),

                SizedBox(height: 30),
                BotonAcceder(
                  userController: userController,
                  passwordController: passController,
                ),
                SizedBox(height: 10),
                BotonRecuperarContrasena(),
                BotonNuevoUsuario(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: FooterBar(),
    );
  }
}
