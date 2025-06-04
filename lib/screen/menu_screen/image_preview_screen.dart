import 'dart:io';
import 'package:flutter/material.dart';

/// @class ImagePreviewScreen
/// @brief Pantalla para mostrar la vista previa de una imagen seleccionada.
/// 
/// Permite al usuario visualizar la imagen con opciones de zoom y desplazamiento.
class ImagePreviewScreen extends StatelessWidget {
  /// @brief Archivo de imagen a mostrar.
  final File imageFile;

  /// @brief Constructor de la pantalla de vista previa de imagen.
  /// @param imageFile Archivo de imagen a mostrar.
  /// @param key Clave opcional para el widget.
  const ImagePreviewScreen({super.key, required this.imageFile});

  /// @brief Construye el widget principal de la pantalla de vista previa.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa la pantalla de vista previa de imagen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Vista previa', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // puedes mover la imagen
          scaleEnabled: true, // puedes hacer zoom
          minScale: 1,
          maxScale: 5,
          child: Image.file(imageFile, fit: BoxFit.contain),
        ),
      ),
    );
  }
}