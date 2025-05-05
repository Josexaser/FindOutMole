import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser; // Importar http_parser para MediaType
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../models/prediction.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  //Para web, conectandose desde el navegador en local 'http://127.0.0.1:8000'; // 
  // En navegador se corre con: flutter run -d chrome --web-port=8080 --verbose
  // Para emulador: static const String baseUrl = 'http://10.0.2.2:8000';
  // Para dispositivo físico: usa la IP de tu máquina, ej: 'http://192.168.1.X:8000'

  Future<Prediction> predict(dynamic imageData, String token) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/predict'));
      request.headers['Authorization'] = 'Bearer $token';

      if (kIsWeb) {
        // En Flutter Web, imageData es un XFile
        final xFile = imageData as XFile;
        final bytes = await xFile.readAsBytes();
        // Obtener el nombre del archivo original si está disponible, o usar un nombre genérico
        String filename = xFile.name.isNotEmpty ? xFile.name : 'uploaded_image.jpg';
        // Determinar el content_type basado en la extensión del archivo
        String extension = path.extension(filename).toLowerCase();
        String mimeType = _getMimeType(extension);

        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename,
          contentType: http_parser.MediaType('image', mimeType), // Usar http_parser.MediaType
        ));
      } else {
        // En móvil, imageData es un XFile que convertimos a File
        final xFile = imageData as XFile;
        final file = File(xFile.path);
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
        ));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return Prediction.fromJson(jsonDecode(responseBody));
      } else {
        throw Exception(jsonDecode(responseBody)['detail']);
      }
    } catch (e) {
      throw Exception('Error al realizar la predicción: $e');
    }
  }

  // Método auxiliar para determinar el MIME type basado en la extensión
  String _getMimeType(String extension) {
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'jpeg';
      case '.png':
        return 'png';
      case '.gif':
        return 'gif';
      case '.bmp':
        return 'bmp';
      default:
        return 'jpeg'; // Por defecto, asumimos JPEG
    }
  }
}