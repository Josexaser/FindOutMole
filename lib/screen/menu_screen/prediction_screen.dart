import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:findoutmole/utils/image_selector.dart';
import '../../services/api_service.dart';
import '../../models/prediction.dart';

class PredictionScreen extends StatefulWidget {
  final String token;

  const PredictionScreen({super.key, required this.token});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  Uint8List? _imageBytes;
  File? _imageFile;
  Prediction? _prediction;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickImageFromGallery() async {
    final result = await ImageSelector.pickImageFromGallery();
    if (result != null) {
      setState(() {
        _imageBytes = result.bytes;
        _imageFile = result.file;
        _prediction = null;
      });
    }
  }

  Future<void> _takePhoto() async {
    final result = await ImageSelector.takePhoto();
    if (result != null) {
      setState(() {
        _imageBytes = result.bytes;
        _imageFile = result.file;
        _prediction = null;
      });
    }
  }

  Future<void> _sendToBackend() async {
    if (_imageBytes == null && _imageFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      Prediction prediction;

      if (kIsWeb && _imageBytes != null) {
        prediction = await apiService.predict(_imageBytes!, widget.token);
      } else if (!kIsWeb && _imageFile != null) {
        prediction = await apiService.predict(_imageFile!, widget.token);
      } else {
        throw Exception('No se ha proporcionado una imagen válida');
      }

      setState(() {
        _prediction = prediction;
      });
    } catch (e) {
      print('Error al predecir: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar la imagen al backend')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildImageBox() {
    return Container(
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
      child:
          _imageBytes == null && _imageFile == null
              ? Center(
                child: Text(
                  'No hay imagen seleccionada',
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
              )
              : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    kIsWeb
                        ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                        : Image.file(_imageFile!, fit: BoxFit.cover),
              ),
    );
  }

  Widget _buildPredictionResults() {
    if (_prediction == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 30),
        Text(
          'Resultado: ${_prediction!.prediction}',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          'Tipo: ${_prediction!.type}',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          'Probabilidades:',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        ..._prediction!.probabilities.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(entry.key, style: GoogleFonts.poppins())),
                Text(
                  '${entry.value.toStringAsFixed(2)}%',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'FindOutMole',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/2.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white54,
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: kToolbarHeight + 16,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildImageBox(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImageFromGallery,
                          icon: const Icon(Icons.photo),
                          label: Text('Galería', style: GoogleFonts.poppins()),
                        ),
                        ElevatedButton.icon(
                          onPressed: _takePhoto,
                          icon: const Icon(Icons.camera_alt),
                          label: Text('Cámara', style: GoogleFonts.poppins()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _sendToBackend,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Text(
                                'Analizar Imagen',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
                          style: GoogleFonts.poppins(color: Colors.red[700]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    _buildPredictionResults(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
