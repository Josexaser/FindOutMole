import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ImageSelectorResult {
  final XFile? xFile;
  final Uint8List? bytes;
  final File? file;

  ImageSelectorResult({this.xFile, this.bytes, this.file});
}

class ImageSelector {
  static final ImagePicker _picker = ImagePicker();

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
        return ImageSelectorResult(xFile: pickedFile, file: file);
      }
    } catch (e) {
      print('Error al seleccionar imagen: $e');
      return null;
    }
  }

  static Future<ImageSelectorResult?> takePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) return null;

      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        return ImageSelectorResult(xFile: pickedFile, bytes: bytes);
      } else {
        final file = File(pickedFile.path);
        return ImageSelectorResult(xFile: pickedFile, file: file);
      }
    } catch (e) {
      print('Error al tomar foto: $e');
      return null;
    }
  }
}
