import 'package:flutter/material.dart';
import 'package:findoutmole/screen/FootBar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// @class ContactoScreen
/// @brief Pantalla de contacto para que el usuario pueda comunicarse con el equipo de soporte.
/// 
/// Incluye información de contacto, redes sociales, ubicación y un formulario para enviar mensajes.
class ContactoScreen extends StatelessWidget {
  /// @brief Constructor de la pantalla de contacto.
  /// @param key Clave opcional para el widget.
  const ContactoScreen({super.key});

  /// @brief Construye el widget principal de la pantalla de contacto.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa la pantalla de contacto.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 118, 198, 232),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: const FooterBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Contacto'),
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset('assets/images/2.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // Para permitir desplazamiento
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de la pantalla
                    const SizedBox(height: 20),
                    const Text(
                      '¿Necesitas ayuda?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Aquí tienes varias maneras de ponerte en contacto con nosotros:',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 24),

                    // Correo electrónico
                    _buildContactRow(
                      icon: Icons.email,
                      color: Colors.blue,
                      text: 'contacto@miapp.com',
                    ),
                    const SizedBox(height: 12),

                    // Teléfono
                    _buildContactRow(
                      icon: Icons.phone,
                      color: Colors.green,
                      text: '+34 848 233 111',
                    ),
                    const SizedBox(height: 12),

                    // Dirección
                    _buildContactRow(
                      icon: Icons.location_on,
                      color: Colors.red,
                      text: 'Calle Falsa, 123 - Majarromaque, España',
                    ),
                    const SizedBox(height: 24),

                    // Redes sociales
                    const Text(
                      'Síguenos en nuestras redes sociales:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.facebook,
                            color: Colors.blue,
                            size: 50,
                          ),
                          onPressed: () {
                            // Aquí puedes agregar un enlace a Facebook
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.instagram,
                          color: Colors.purple,
                          size: 32,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '@miapp_instagram',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.xTwitter,
                          color: Colors.black,
                          size: 32,
                        ),
                        SizedBox(width: 10),
                        Text('@miapp_oficial', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 50),

                    // Mapa de ubicación (solo un contenedor visual por ahora)
                    const Text(
                      'Nuestra ubicación:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      width: double.infinity,
                      color:
                          Colors.grey[300], // Aquí podrías agregar un mapa real
                      child: const Center(
                        child: Text('Mapa interactivo (próximamente)'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Formulario de contacto
                    const Text(
                      'Envíanos un mensaje:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField('Nombre', Icons.person),
                    const SizedBox(height: 12),
                    _buildTextField('Correo electrónico', Icons.email),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Mensaje',
                      Icons.message,
                      isMultiline: true,
                    ),
                    const SizedBox(height: 16),

                    // Botón de enviar mensaje
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para enviar el mensaje
                      },
                      child: const Text('Enviar mensaje'),
                    ),
                    const SizedBox(height: 30),

                    // Mensaje de agradecimiento
                    const Center(
                      child: Text(
                        'Gracias por usar nuestra app máquina ❤️',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
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

  /// @brief Crea una fila de contacto reutilizable.
  /// @param icon Icono a mostrar.
  /// @param color Color del icono.
  /// @param text Texto de contacto.
  /// @return Widget con la fila de contacto.
  Widget _buildContactRow({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  /// @brief Crea un campo de texto reutilizable (con opción para multilinea).
  /// @param label Etiqueta del campo.
  /// @param icon Icono a mostrar.
  /// @param isMultiline Indica si el campo es multilínea.
  /// @return Widget con el campo de texto.
  Widget _buildTextField(
    String label,
    IconData icon, {
    bool isMultiline = false,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      maxLines: isMultiline ? null : 1,
    );
  }
}