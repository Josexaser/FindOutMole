import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatelessWidget {
  final File imageFile;

  const ImagePreviewScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Vista previa', style: TextStyle(color: Colors.white)),
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
