import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:findoutmole/screen/menu_screen/Perfil.dart';
import 'package:findoutmole/screen/FootBar.dart';
import 'package:findoutmole/screen/menu_screen/Contacto.dart';
import 'package:findoutmole/screen/menu_screen/prediction_screen.dart';
import 'package:findoutmole/screen/menu_screen/ConsultasScreen.dart';
import 'package:findoutmole/screen/login_screen/login_screen.dart';

/// @class HomePage
/// @brief Pantalla principal de la aplicación tras iniciar sesión.
/// 
/// Permite acceder a las funcionalidades principales: agregar archivos, ver perfil, consultar historial y contactar.
class HomePage extends StatelessWidget {
  /// @brief Token de autenticación del usuario.
  final String token;

  /// @brief Constructor de la pantalla principal.
  /// @param token Token de autenticación.
  /// @param key Clave opcional para el widget.
  const HomePage({super.key, required this.token});

  /// @brief Construye el widget principal de la pantalla de inicio.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa la pantalla principal.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: configuracionAppBar(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/2.png', fit: BoxFit.cover),
          ),
          kIsWeb
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildButtonWeb(
                          Icons.upload_file,
                          'Agregar Archivos',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PredictionScreen(token: token),
                              ),
                            );
                          },
                        ),
                        _buildButtonWeb(Icons.person, 'Mi Perfil', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PerfilPage(),
                            ),
                          );
                        }),
                        _buildButtonWeb(Icons.search, 'Consultas', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ConsultasScreen(token: token),
                            ),
                          );
                        }),
                        _buildButtonWeb(Icons.contact_mail, 'Contacto', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ContactoScreen(),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildButtonMobile(
                            Icons.upload_file,
                            'Agregar Archivos',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PredictionScreen(token: token),
                                ),
                              );
                            },
                          ),
                          _buildButtonMobile(Icons.person, 'Mi Perfil', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PerfilPage(),
                              ),
                            );
                          }),
                          _buildButtonMobile(Icons.search, 'Consultas', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ConsultasScreen(token: token),
                              ),
                            );
                          }),
                          _buildButtonMobile(Icons.contact_mail, 'Contacto', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactoScreen(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
        ],
      ),
      bottomNavigationBar: const FooterBar(),
    );
  }

  /// @brief Crea un botón estilizado para la versión web.
  /// @param icon Icono del botón.
  /// @param label Texto del botón.
  /// @param onPressed Acción al presionar el botón.
  /// @return Widget con el botón web.
  Widget _buildButtonWeb(IconData icon, String label, VoidCallback onPressed) {
    return SizedBox(
      width: 300,
      height: 300,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.6),
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            const SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  /// @brief Crea un botón estilizado para la versión móvil.
  /// @param icon Icono del botón.
  /// @param label Texto del botón.
  /// @param onPressed Acción al presionar el botón.
  /// @return Widget con el botón móvil.
  Widget _buildButtonMobile(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.8),
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  /// @brief Configura el AppBar de la pantalla principal.
  /// @param context Contexto de la aplicación.
  /// @return AppBar personalizado.
  AppBar configuracionAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'FindOutMole',
        style: TextStyle(
          color: Colors.white,
          fontSize: 44,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Tooltip(
          message: 'Cerrar sesión',
          child: IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ),
      ],
    );
  }
}