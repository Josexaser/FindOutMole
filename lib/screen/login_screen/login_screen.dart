import 'package:findoutmole/screen/login_screen/boton_nuevo_usuario.dart';
import 'package:findoutmole/screen/login_screen/boton_recuperar_contrasena.dart';
import 'package:findoutmole/screen/login_screen/text_find_out.dart';
import 'package:findoutmole/screen/login_screen/text_mole.dart';
import 'package:findoutmole/screen/FootBar.dart';
import 'package:flutter/material.dart';
import 'package:findoutmole/screen/login_screen/boton_acceder.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController userController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/images/2.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FindOutText(),
                const MoleText(),
                const Expanded(child: SizedBox(height: 280)),

                _StyledInputField(
                  hintText: 'Usuario',
                  icon: Icons.person,
                  controller: userController,
                  obscureText: false,
                ),
                const SizedBox(height: 20),

                _StyledInputField(
                  hintText: 'Contraseña',
                  icon: Icons.lock,
                  controller: passController,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                BotonAcceder(
                  userController: userController,
                  passwordController: passController,
                ),
                const SizedBox(height: 10),
                const BotonRecuperarContrasena(),
                const BotonNuevoUsuario(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const FooterBar(),
    );
  }
}

class _StyledInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;

  const _StyledInputField({
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.obscureText,
  });

  @override
  State<_StyledInputField> createState() => _StyledInputFieldState();
}

class _StyledInputFieldState extends State<_StyledInputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: widget.hintText,
            labelStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(widget.icon, color: Colors.white),
            suffixIcon:
                widget.obscureText
                    ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: _toggleObscureText,
                    )
                    : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 10,
            ),
          ),
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}
