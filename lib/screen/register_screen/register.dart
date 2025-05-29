import 'package:findoutmole/screen/register_screen/condiciones.dart';
import 'package:findoutmole/screen/register_screen/cuentraPrevia.dart';
import 'package:flutter/material.dart';
import 'package:findoutmole/screen/register_screen/confirmar_Contraseña.dart';
import 'package:findoutmole/screen/register_screen/contraseña.dart';
import 'package:findoutmole/screen/register_screen/email.dart';
import 'package:findoutmole/screen/register_screen/registerButtom.dart';
import 'package:findoutmole/screen/register_screen/textoInicial.dart';
import 'package:findoutmole/screen/FootBar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  bool aceptoCondiciones = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      bottomNavigationBar: const FooterBar(),
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset('assets/images/2.png', fit: BoxFit.cover),
          ),
          // Contenido principal
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const TextoInicial(),
                      SizedBox(height: screenHeight * 0.03),
                      EmailField(controller: emailController),
                      SizedBox(height: screenHeight * 0.03),
                      PasswordField(controller: passController),
                      SizedBox(height: screenHeight * 0.03),
                      ConfirmPasswordField(
                        controller: confirmPassController,
                        passwordController: passController,
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Condiciones(
                        onChanged: (valor) {
                          setState(() {
                            aceptoCondiciones = valor;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      RegisterButton(
                        passwordController: passController,
                        emailController: emailController,
                        confirmPasswordController: confirmPassController,
                        enabled: aceptoCondiciones,
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      const CuentaExiste(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    passController.dispose();
    emailController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
}
