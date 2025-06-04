import 'package:findoutmole/screen/register_screen/condiciones.dart';
import 'package:findoutmole/screen/register_screen/cuentraPrevia.dart';
import 'package:flutter/material.dart';
import 'package:findoutmole/screen/register_screen/confirmar_Contraseña.dart';
import 'package:findoutmole/screen/register_screen/contraseña.dart';
import 'package:findoutmole/screen/register_screen/email.dart';
import 'package:findoutmole/screen/register_screen/registerButtom.dart';
import 'package:findoutmole/screen/register_screen/textoInicial.dart';
import 'package:findoutmole/screen/FootBar.dart';

/// @class RegisterPage
/// @brief Pantalla de registro de usuario.
/// 
/// Permite al usuario crear una cuenta ingresando correo, contraseña, confirmación y aceptando condiciones.
class RegisterPage extends StatefulWidget {
  /// @brief Constructor del widget RegisterPage.
  /// @param key Clave opcional para el widget.
  const RegisterPage({super.key});

  /// @brief Crea el estado asociado a este widget.
  /// @return Instancia de _RegisterPageState.
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

/// @class _RegisterPageState
/// @brief Estado de la pantalla de registro para manejar la lógica de validación y envío.
class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  bool aceptoCondiciones = false;

  /// @brief Construye el widget principal de la pantalla de registro.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa la pantalla de registro.
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

  /// @brief Libera los recursos de los controladores de texto.
  @override
  void dispose() {
    passController.dispose();
    emailController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
}