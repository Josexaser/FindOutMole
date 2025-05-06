import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../models/prediction.dart';

class PredictionScreen extends StatefulWidget {
  final String token;

  const PredictionScreen({required this.token, Key? key}) : super(key: key);

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  XFile? _imageFile;
  Uint8List? _imageBytes;
  File? _imageFileMobile;
  Prediction? _prediction;
  bool _isLoading = false;
  String? _errorMessage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        print('Imagen seleccionada: ${pickedFile.path}');
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _imageFile = pickedFile;
            _imageBytes = bytes;
            _imageFileMobile = null;
            _prediction = null;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _imageFile = pickedFile;
            _imageFileMobile = File(pickedFile.path);
            _imageBytes = null;
            _prediction = null;
            _errorMessage = null;
          });
        }
      } else {
        print('Selección de imagen cancelada');
      }
    } catch (e) {
      print('Error en _pickImageFromGallery: $e');
      setState(() {
        _errorMessage = 'Error al seleccionar la imagen: $e';
      });
    }
  }

  Future<void> _takePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        print('Foto tomada: ${pickedFile.path}');
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _imageFile = pickedFile;
            _imageBytes = bytes;
            _imageFileMobile = null;
            _prediction = null;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _imageFile = pickedFile;
            _imageFileMobile = File(pickedFile.path);
            _imageBytes = null;
            _prediction = null;
            _errorMessage = null;
          });
        }
      } else {
        print('Captura de foto cancelada');
      }
    } catch (e) {
      print('Error en _takePhoto: $e');
      setState(() {
        _errorMessage = 'Error al tomar la foto: $e';
      });
    }
  }

  Future<void> _predictImage() async {
    if (_imageFile == null) {
      setState(() {
        _errorMessage = 'Por favor, selecciona o toma una foto primero.';
      });
      return;
    }

    print('Iniciando predicción con imagen: ${_imageFile!.path}');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prediction = await ApiService().predict(_imageFile, widget.token);
      setState(() {
        _prediction = prediction;
        _isLoading = false;
      });
    } catch (e) {
      print('Error en _predictImage: $e');
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FindOutMole',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _imageFile == null
                  ? Center(
                      child: Text(
                        'No hay imagen seleccionada',
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.memory(
                              _imageBytes!,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _imageFileMobile!,
                              fit: BoxFit.cover,
                            ),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo, size: 20),
                  label: Text(
                    'Galería',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt, size: 20),
                  label: Text(
                    'Cámara',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _predictImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Analizar Imagen',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: GoogleFonts.poppins(
                    color: Colors.red[700],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_prediction != null) ...[
              const Divider(height: 30),
              Text(
                'Resultado: ${_prediction!.prediction}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Tipo: ${_prediction!.type}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Probabilidades:',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              ..._prediction!.probabilities.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                      Text(
                        '${entry.value.toStringAsFixed(2)}%',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}