import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CarpetasScreen extends StatefulWidget {
  final String imagePath; // Ruta de la imagen que se desea guardar

  const CarpetasScreen({required this.imagePath, super.key});

  @override
  _CarpetasScreenState createState() => _CarpetasScreenState();
}

class _CarpetasScreenState extends State<CarpetasScreen> {
  List<String> _folders = []; // Lista de carpetas

  @override
  void initState() {
    super.initState();
    _loadFolders(); // Cargar las carpetas existentes al iniciar
  }

  Future<void> _loadFolders() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = directory.path;
      print('Directorio de documentos: $folderPath'); // Corregido

      // Crear carpetas de prueba (descomentar para probar)
      // Directory('$folderPath/Test1').createSync();
      // Directory('$folderPath/Test2').createSync();

      final folderDirectory = Directory(folderPath);
      final folders =
          folderDirectory
              .listSync()
              .whereType<Directory>()
              .map((entity) => entity.path.split(Platform.pathSeparator).last)
              .toList();

      print(
        'Carpetas encontradas: $folders',
      ); // Depuración para verificar carpetas

      setState(() {
        _folders = folders;
      });
    } catch (e) {
      print('Error al cargar carpetas: $e'); // Depuración
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar carpetas: $e')));
    }
  }

  Future<void> _deleteFolder(String folderName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = '${directory.path}/$folderName';
      final folder = Directory(folderPath);

      if (folder.existsSync()) {
        folder.deleteSync(recursive: true);
        setState(() {
          _folders.remove(folderName); // Eliminar la carpeta de la lista
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Carpeta "$folderName" eliminada')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La carpeta "$folderName" no existe')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la carpeta: $e')),
      );
    }
  }

  Future<void> _saveImageToFolder(String folderName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = '${directory.path}/$folderName';
      final folder = Directory(folderPath);

      if (!folder.existsSync()) {
        folder.createSync(recursive: true);
      }

      final imageFile = File(widget.imagePath);
      final newImagePath = '$folderPath/${imageFile.uri.pathSegments.last}';
      await imageFile.copy(newImagePath);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Imagen guardada en $folderName')));

      Navigator.pop(context); // Regresa a la pantalla anterior
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar la imagen: $e')));
    }
  }

  void _confirmDeleteFolder(String folderName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Text(
              '¿Estás seguro de que deseas eliminar la carpeta "$folderName"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteFolder(folderName);
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar Carpeta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Selecciona una carpeta para guardar la imagen:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _folders.isEmpty
                      ? const Center(child: Text('No se encontraron carpetas'))
                      : GridView.builder(
                        clipBehavior: Clip.none,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: _folders.length,
                        itemBuilder: (context, index) {
                          final folder = _folders[index];
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              InkWell(
                                onTap: () => _saveImageToFolder(folder),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.withOpacity(
                                      0.5,
                                    ), // Fondo para depuración
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.blueAccent,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.folder,
                                        size: 50,
                                        color: Colors.blueAccent,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        folder,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => _confirmDeleteFolder(folder),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color:
                                          Colors
                                              .red, // Fondo rojo para depuración
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
