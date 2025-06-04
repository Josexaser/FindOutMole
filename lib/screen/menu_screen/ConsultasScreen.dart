import 'package:findoutmole/screen/menu_screen/carpetas_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:findoutmole/services/api_service.dart';
import 'package:findoutmole/models/prediction.dart';
import 'package:findoutmole/screen/FootBar.dart';

/// @class ConsultasScreen
/// @brief Pantalla que muestra el historial de diagnósticos del usuario.
/// 
/// Permite visualizar, eliminar y guardar diagnósticos en carpetas.
class ConsultasScreen extends StatefulWidget {
  /// @brief Token de autenticación del usuario.
  final String token;

  /// @brief Constructor de la pantalla de consultas.
  /// @param token Token de autenticación.
  /// @param key Clave opcional para el widget.
  const ConsultasScreen({required this.token, super.key});

  /// @brief Crea el estado asociado a este widget.
  /// @return Instancia de _ConsultasScreenState.
  @override
  State<ConsultasScreen> createState() => _ConsultasScreenState();
}

/// @class _ConsultasScreenState
/// @brief Estado de la pantalla ConsultasScreen para manejar la lógica de diagnósticos.
class _ConsultasScreenState extends State<ConsultasScreen> {
  /// @brief Lista de diagnósticos obtenidos.
  List<Prediction> _diagnostics = [];
  /// @brief Indica si se están cargando los diagnósticos.
  bool _isLoading = true;
  /// @brief Mensaje de error si ocurre algún problema al cargar los diagnósticos.
  String? _errorMessage;

  /// @brief Inicializa el estado y carga los diagnósticos.
  @override
  void initState() {
    super.initState();
    _fetchDiagnostics();
  }

  /// @brief Obtiene los diagnósticos del usuario desde la API.
  /// @return void
  Future<void> _fetchDiagnostics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final diagnostics = await ApiService().getDiagnostics(widget.token);
      setState(() {
        _diagnostics = diagnostics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  /// @brief Elimina un diagnóstico seleccionado.
  /// @param diagnosticId Identificador del diagnóstico a eliminar.
  /// @return void
  Future<void> _deleteDiagnostic(String diagnosticId) async {
    try {
      await ApiService().deleteDiagnostic(diagnosticId, widget.token);
      setState(() {
        _diagnostics.removeWhere((diag) => diag.diagnosticId == diagnosticId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diagnóstico eliminado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar diagnóstico: $e')),
      );
    }
  }

  /// @brief Abre la pantalla de carpetas para guardar una imagen.
  /// @param context Contexto de la aplicación.
  /// @param imagePath Ruta de la imagen a guardar.
  void _openCarpetasScreen(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarpetasScreen(imagePath: imagePath),
      ),
    );
  }

  /// @brief Muestra un diálogo de confirmación para eliminar un diagnóstico.
  /// @param diagnosticId Identificador del diagnóstico a eliminar.
  void _confirmDeleteDiagnostic(String diagnosticId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: const Text('¿Deseas eliminar este diagnóstico?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteDiagnostic(diagnosticId);
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

  /// @brief Construye la tarjeta visual para cada diagnóstico.
  /// @param diagnostic Objeto Prediction con los datos del diagnóstico.
  /// @return Widget Card con la información del diagnóstico.
  Widget _buildDiagnosticCard(Prediction diagnostic) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: kIsWeb ? 16 : 8,
          horizontal: kIsWeb ? 16 : 8,
        ),
        child: Row(
          children: [
            diagnostic.imageUrl != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    diagnostic.imageUrl!,
                    width: kIsWeb ? 64 : 36,
                    height: kIsWeb ? 64 : 36,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) =>
                            const Icon(Icons.error, color: Colors.red),
                  ),
                )
                : Container(
                  width: kIsWeb ? 64 : 36,
                  height: kIsWeb ? 64 : 36,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.image_not_supported),
                ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diagnostic.prediction,
                    style: GoogleFonts.poppins(
                      fontSize: kIsWeb ? 15 : 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tipo: ${diagnostic.type}',
                    style: GoogleFonts.poppins(
                      fontSize: kIsWeb ? 13 : 10,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    diagnostic.timestamp != null
                        ? DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(diagnostic.timestamp!)
                        : 'Sin fecha',
                    style: GoogleFonts.poppins(
                      fontSize: kIsWeb ? 13 : 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: kIsWeb ? 20 : 16,
                  ),
                  onPressed:
                      () => _confirmDeleteDiagnostic(diagnostic.diagnosticId!),
                ),
                IconButton(
                  icon: Icon(
                    Icons.folder,
                    color: Colors.blueAccent,
                    size: kIsWeb ? 20 : 16,
                  ),
                  onPressed:
                      () => _openCarpetasScreen(
                        context,
                        diagnostic.imageUrl ?? '',
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// @brief Construye el widget principal de la pantalla de consultas.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa la pantalla de historial de diagnósticos.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Historial de Diagnósticos',
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
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + kToolbarHeight,
              bottom: 60,
            ),
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorMessage!,
                            style: GoogleFonts.poppins(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchDiagnostics,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    )
                    : _diagnostics.isEmpty
                    ? Center(
                      child: Text(
                        'No hay diagnósticos disponibles',
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: _diagnostics.length,
                      itemBuilder: (context, index) {
                        return _buildDiagnosticCard(_diagnostics[index]);
                      },
                    ),
          ),
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () => _openCarpetasScreen(context, ''),
                child: const Text('Crear Carpeta'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const FooterBar(),
    );
  }
}