import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:image_editor/image_editor.dart' as editor;
import 'dart:io';
import 'package:findoutmole/screen/FootBar.dart';

class ArchivosScreen extends StatefulWidget {
  const ArchivosScreen({super.key});

  @override
  _ArchivosScreenState createState() => _ArchivosScreenState();
}

class _ArchivosScreenState extends State<ArchivosScreen> {
  final picker.ImagePicker _picker = picker.ImagePicker();
  final List<File> _images = [];
  bool _isLoading = false;

  Future<void> _pickImage(picker.ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final editedImage = await _editImage(File(pickedFile.path));
      if (editedImage != null) {
        setState(() {
          _images.add(editedImage);
        });
      }
    }
  }

  Future<File?> _editImage(File imageFile) async {
    try {
      final editorOption = editor.ImageEditorOption();
      editorOption.addOption(
        editor.ClipOption(x: 0, y: 0, width: 500, height: 500),
      );

      final result = await editor.ImageEditor.editImage(
        image: imageFile.readAsBytesSync(),
        imageEditorOption: editorOption,
      );

      if (result != null) {
        final editedFile = File(
          '${imageFile.parent.path}/${DateTime.now().millisecondsSinceEpoch}_edited.png',
        );
        editedFile.writeAsBytesSync(result);
        return editedFile;
      }
    } catch (e) {
      print('Error al editar la imagen: $e');
    }
    return null;
  }

  void _removeImage(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar imagen'),
            content: const Text(
              '¿Estás seguro de que deseas eliminar esta imagen?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      setState(() {
        _images.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Archivos Médicos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/2.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: kToolbarHeight,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).padding.bottom + 70,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Selecciona una imagen clara y bien iluminada',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_images.isEmpty)
                    _buildEmptyImageBox()
                  else
                    _buildImageGrid(),
                  const SizedBox(height: 16),
                  _buildButtonRow(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const FooterBar(),
    );
  }

  Widget _buildEmptyImageBox() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          setState(() => _isLoading = true);
          await _pickImage(picker.ImageSource.gallery);
          setState(() => _isLoading = false);
        },
        child: Container(
          width: 250,
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_a_photo, size: 50, color: Colors.blue),
              SizedBox(height: 12),
              Text(
                'Sube una imagen clara\ny bien iluminada',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _images.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(_images[index], fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: InkWell(
                onTap: () => _removeImage(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            setState(() => _isLoading = true);
            await _pickImage(picker.ImageSource.gallery);
            setState(() => _isLoading = false);
          },
          icon: const Icon(Icons.photo_library),
          label: const Text('Galería'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.withOpacity(0.8),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            setState(() => _isLoading = true);
            await _pickImage(picker.ImageSource.camera);
            setState(() => _isLoading = false);
          },
          icon: const Icon(Icons.camera_alt),
          label: const Text('Cámara'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
