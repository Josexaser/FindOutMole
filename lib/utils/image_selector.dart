import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

/// @class ImageSelectorResult
/// @brief Encapsula el resultado de la selección o captura de imagen.
/// 
/// Contiene diferentes representaciones de la imagen dependiendo de la plataforma:
/// - `xFile`: referencia directa al archivo seleccionado (útil para trabajar con ImagePicker).
/// - `bytes`: contenido de la imagen en formato binario (para mostrar o subir).
/// - `file`: archivo físico en disco (solo disponible en dispositivos no-web).
class ImageSelectorResult {
  final XFile? xFile;
  final Uint8List? bytes;
  final File? file;

  /// @brief Constructor que permite inicializar el resultado con los campos disponibles.
  /// @param xFile Archivo seleccionado (opcional).
  /// @param bytes Contenido binario de la imagen (opcional).
  /// @param file Archivo físico en disco (opcional).
  ImageSelectorResult({this.xFile, this.bytes, this.file});
}

/// @class ImageSelector
/// @brief Utilidad para seleccionar imágenes desde galería o cámara.
/// 
/// Contiene métodos estáticos adaptados tanto para Web como para Android/iOS.
class ImageSelector {
  static final ImagePicker _picker = ImagePicker();

  /// @brief Abre la galería del dispositivo para seleccionar una imagen.
  /// 
  /// - En Web: usa `file_picker` para obtener la imagen en bytes.
  /// - En Móvil: usa `image_picker` y también lee los bytes del archivo.
  /// 
  /// @return [ImageSelectorResult] con los datos de la imagen o `null` si se cancela.
  static Future<ImageSelectorResult?> pickImageFromGallery() async {
    try {
      if (kIsWeb) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          withData: true,
        );
        if (result != null && result.files.single.bytes != null) {
          return ImageSelectorResult(bytes: result.files.single.bytes);
        }
        return null;
      } else {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile == null) return null;
        final file = File(pickedFile.path);
        final bytes = await file.readAsBytes();
        return ImageSelectorResult(xFile: pickedFile, file: file, bytes: bytes);
      }
    } catch (e) {
      print('Error al seleccionar imagen: $e');
      return null;
    }
  }

  /// @brief Abre la cámara del dispositivo para tomar una foto.
  /// 
  /// - En Web: obtiene los bytes directamente del archivo capturado.
  /// - En Móvil: convierte la ruta del archivo a un objeto [File] y obtiene los bytes.
  /// 
  /// @return [ImageSelectorResult] con los datos de la imagen o `null` si se cancela.
  static Future<ImageSelectorResult?> takePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) return null;

      if (kIsWeb) {
        final file = File(pickedFile.path);
        final bytes = await pickedFile.readAsBytes();
        return ImageSelectorResult(xFile: pickedFile, bytes: bytes, file: file);
      } else {
        final file = File(pickedFile.path);
        final bytes = await file.readAsBytes();
        return ImageSelectorResult(xFile: pickedFile, file: file, bytes: bytes);
      }
    } catch (e) {
      print('Error al tomar foto: $e');
      return null;
    }
  }
}