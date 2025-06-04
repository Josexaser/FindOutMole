import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// @class CarpetasScreen
/// @brief Pantalla para seleccionar una carpeta y guardar una imagen.
/// 
/// Permite al usuario ver, seleccionar y eliminar carpetas donde puede guardar una imagen.
class CarpetasScreen extends StatefulWidget {
  /// @brief Ruta de la imagen que se desea guardar.
  final String imagePath;

  /// @brief Constructor de la pantalla de carpetas.
  /// @param imagePath Ruta de la imagen a guardar.
  /// @param key Clave opcional para el widget.
  const CarpetasScreen({required this.imagePath, super.key});

  /// @brief Crea el estado asociado a este widget.
  /// @return Instancia de _CarpetasScreenState.
  @override
  _CarpetasScreenState createState() => _CarpetasScreenState();
}

/// @class _CarpetasScreenState
/// @brief Estado de la pantalla CarpetasScreen para manejar la lógica de carpetas.
class _CarpetasScreenState extends State<CarpetasScreen> {
  /// @brief Lista de carpetas encontradas.
  List<String> _folders = [];

  /// @brief Inicializa el estado y carga las carpetas existentes.
  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  /// @brief Carga las carpetas existentes en el directorio de documentos.
  /// @return void
  Future<void> _loadFolders() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = directory.path;

      final folderDirectory = Directory(folderPath);
      final folders =
          folderDirectory
              .listSync()
              .whereType<Directory>()
              .map((entity) => entity.path.split(Platform.pathSeparator).last)
              .toList();

      setState(() {
        _folders = folders;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar carpetas: $e')));
    }
  }

  /// @brief Elimina una carpeta seleccionada.
  /// @param folderName Nombre de la carpeta a eliminar.
  /// @return void
  Future<void> _deleteFolder(String folderName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = '${directory.path}/$folderName';
      final folder = Directory(folderPath);

      if (folder.existsSync()) {
        folder.deleteSync(recursive: true);
        setState(() {
          _folders.remove(folderName);
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

  /// @brief Guarda la imagen en la carpeta seleccionada.
  /// @param folderName Nombre de la carpeta donde se guardará la imagen.
  /// @return void
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

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar la imagen: $e')));
    }
  }

  /// @brief Muestra un diálogo de confirmación para eliminar una carpeta.
  /// @param folderName Nombre de la carpeta a eliminar.
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

  /// @brief Construye el widget principal de la pantalla.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa la pantalla de selección de carpetas.
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
              child: _folders.isEmpty
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
                                  color: Colors.yellow.withOpacity(0.5),
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
                                    color: Colors.red,
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