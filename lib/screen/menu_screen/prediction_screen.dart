/// Pantalla principal para mostrar el resultado del análisis de imagen
/// y generar un informe en PDF en Flutter Web y Android
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:findoutmole/utils/image_selector.dart';
import '../../services/api_service.dart';
import '../../models/prediction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Widget de pantalla que permite cargar una imagen, enviar al backend
/// para predicción y generar un PDF con los resultados
class PredictionScreen extends StatefulWidget {
  final String token;

  /// Constructor que requiere el token JWT del usuario autenticado
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

  /// Selecciona una imagen desde la galería y actualiza el estado
  Future<void> _pickImageFromGallery() async {
    final result = await ImageSelector.pickImageFromGallery();
    if (result != null) {
      setState(() {
        _imageBytes = result.bytes;
        _imageFile = result.file;
        _prediction = null;
      });
      print('Bytes de imagen seleccionada: ${_imageBytes?.length}');
    }
  }

  /// Captura una foto con la cámara del dispositivo
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

  /// Envia la imagen seleccionada al backend para análisis
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

  /// Genera y muestra un PDF con los resultados del análisis
  Future<void> generarPDF({
    required Map<String, dynamic> perfilData,
    required Prediction prediction,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Orientación Diagnóstica',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),

              /// Mostrar la imagen analizada si está disponible
              if (_imageBytes != null) ...[
                pw.Text('Imagen analizada:'),
                pw.SizedBox(height: 10),
                pw.Image(pw.MemoryImage(_imageBytes!), height: 200),
                pw.SizedBox(height: 20),
              ],
              pw.Text('Resultado: ${prediction.prediction}'),
              pw.Text('Tipo: ${prediction.type}'),
              pw.SizedBox(height: 20),
              pw.Text(
                'Paciente: ${perfilData['nombre']} ${perfilData['apellidos']}',
              ),
              pw.Text('Correo: ${perfilData['email']}'),
              pw.Text('Edad: ${perfilData['edad']} años'),
              pw.Text('Peso: ${perfilData['peso']} kg'),
              pw.Text('Altura: ${perfilData['altura']} m'),
              pw.SizedBox(height: 20),
              pw.Text(
                'Probabilidades del análisis:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              ...prediction.probabilities.entries.map(
                (entry) => pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(entry.key),
                    pw.Text('${entry.value.toStringAsFixed(2)}%'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// Muestra la imagen seleccionada en pantalla
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

  /// Muestra los resultados de la predicción en texto en formato lista
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

  /// Construcción del widget principal de la pantalla
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
          /// Fondo de pantalla con imagen
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

          /// Contenido principal dentro de un área segura
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

                    /// Botones para seleccionar imagen desde galería o cámara
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
                    const SizedBox(height: 60),

                    /// Botones de acción: Analizar imagen y generar diagnóstico
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Botón "Analizar Imagen"
                        Container(
                          height: 50,
                          width: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4DD0E1), Color(0xFF1976D2)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _sendToBackend,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.zero,

                              /// importante para respetar tu ancho
                            ),
                            child: Center(
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
                          ),
                        ),
                        const SizedBox(width: 20),

                        /// espacio entre botones
                        /// Botón "Diagnóstico"
                        Container(
                          height: 50,
                          width: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4DD0E1), Color(0xFF1976D2)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_prediction == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Primero debes analizar una imagen.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) return;
                              final perfilDoc =
                                  await FirebaseFirestore.instance
                                      .collection('Perfil')
                                      .doc(user.uid)
                                      .get();
                              final perfilData = perfilDoc.data();
                              if (perfilData == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'No se encontraron datos del perfil médico.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              /// Extraer datos del perfil médico
                              final nombre =
                                  perfilData['nombre'] ?? 'No definido';
                              final apellidos = perfilData['apellidos'] ?? '';
                              final edad = perfilData['edad'] ?? 'No definido';
                              final peso = perfilData['peso'] ?? 'No definido';
                              final altura =
                                  perfilData['altura'] ?? 'No definido';
                              final correo = user.email ?? 'No definido';
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    contentPadding: const EdgeInsets.all(20),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Orientación Diagnóstica',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'Resultado: ${_prediction!.prediction}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            'Tipo: ${_prediction!.type}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const Divider(height: 30),
                                          Text(
                                            'Paciente: $nombre $apellidos',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          Text(
                                            'Correo: $correo',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          Text(
                                            'Edad: $edad años',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          Text(
                                            'Peso: $peso kg',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          Text(
                                            'Altura: $altura m',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          const Divider(height: 30),
                                          Text(
                                            'Probabilidades del análisis:',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ..._prediction!.probabilities.entries.map((
                                            entry,
                                          ) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 2,
                                                  ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      entry.key,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 14,
                                                          ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${entry.value.toStringAsFixed(2)}%',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),

                                    /// Botones de guardar y cerrar diálogo emergente
                                    actions: [
                                      TextButton(
                                        child: const Text('Cerrar'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();

                                          /// cerrar el diálogo
                                          /// Asegura que los bytes estén disponibles
                                          if (_imageBytes == null &&
                                              _imageFile != null) {
                                            _imageBytes =
                                                await _imageFile!.readAsBytes();
                                          }
                                          await generarPDF(
                                            perfilData: perfilData!,
                                            prediction: _prediction!,
                                          );
                                        },
                                        child: Text("Guardar"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: Center(
                              child: Text(
                                'Diagnóstico',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Mensaje de error en caso de fallo
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

                    /// Resultados de la predicción
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
