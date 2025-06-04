import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findoutmole/screen/FootBar.dart'; // Importa el pie de página
import 'package:flutter/foundation.dart' show kIsWeb;

/// @class PerfilPage
/// @brief Pantalla de perfil médico del usuario.
/// 
/// Permite visualizar y editar los datos personales del usuario, como nombre, apellidos, correo, edad, peso y altura.
class PerfilPage extends StatefulWidget {
  /// @brief Constructor de la pantalla de perfil.
  /// @param key Clave opcional para el widget.
  const PerfilPage({super.key});

  /// @brief Crea el estado asociado a este widget.
  /// @return Instancia de _PerfilPageState.
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

/// @class _PerfilPageState
/// @brief Estado de la pantalla PerfilPage para manejar la lógica de edición y visualización de datos.
class _PerfilPageState extends State<PerfilPage> {
  // Controladores para los campos de texto
  late TextEditingController _nombreController;
  late TextEditingController _apellidosController;
  late TextEditingController _emailController;
  late TextEditingController _edadController;
  late TextEditingController _pesoController;
  late TextEditingController _alturaController;

  // Variable para controlar el estado de edición
  bool _isEditing = false;

  /// @brief Inicializa los controladores y carga los datos del usuario.
  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _apellidosController = TextEditingController();
    _emailController = TextEditingController();
    _edadController = TextEditingController();
    _pesoController = TextEditingController();
    _alturaController = TextEditingController();
    _loadUserData();
  }

  /// @brief Libera los recursos utilizados por los controladores de texto.
  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _edadController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  /// @brief Carga los datos del usuario desde Firebase.
  /// @return void
  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          _emailController.text = user.email ?? 'Correo no definido';
        });
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          final data = doc.data()!;
          setState(() {
            _nombreController.text = data['nombre'] ?? '';
            _apellidosController.text = data['apellidos'] ?? '';
            _edadController.text = data['edad'] ?? '';
            _pesoController.text = data['peso'] ?? '';
            _alturaController.text = data['altura'] ?? '';
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    }
  }

  /// @brief Guarda los datos del usuario en Firestore.
  /// @return void
  Future<void> _saveUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Perfil')
            .doc(user.uid)
            .set({
              'nombre': _nombreController.text,
              'apellidos': _apellidosController.text,
              'email': _emailController.text,
              'edad': _edadController.text,
              'peso': _pesoController.text,
              'altura': _alturaController.text,
            });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos guardados correctamente')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar datos: $e')),
      );
    }
  }

  /// @brief Construye el widget principal de la pantalla de perfil.
  /// @param context Contexto de la aplicación.
  /// @return Widget que representa la pantalla de perfil médico.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/2.png',
              fit: BoxFit.cover,
            ),
          ),
          // Contenido principal
          Column(
            children: [
              // Título transparente con botón de ir atrás
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      const Text(
                        'Perfil Médico',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTextField(
                        label: 'Nombre',
                        hintText: 'Nombre no definido',
                        icon: Icons.person,
                        controller: _nombreController,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Apellidos',
                        hintText: 'Apellidos no definidos',
                        icon: Icons.person_outline,
                        controller: _apellidosController,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Correo Electrónico',
                        hintText: 'Correo no definido',
                        icon: Icons.email,
                        controller: _emailController,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Edad',
                        hintText: 'Edad no definida',
                        icon: Icons.cake,
                        controller: _edadController,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Peso (kg)',
                        hintText: 'Peso no definido',
                        icon: Icons.fitness_center,
                        controller: _pesoController,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Altura (cm)',
                        hintText: 'Altura no definida',
                        icon: Icons.height,
                        controller: _alturaController,
                      ),
                      const SizedBox(height: 32),
                      // Botones para guardar o habilitar edición
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _isEditing
                                ? () async {
                                    await _saveUserData();
                                    setState(() {
                                      _isEditing = false;
                                    });
                                  }
                                : null,
                            child: const Text('Guardar Cambios'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                            child: const Text('Editar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Pie de página
              const FooterBar(),
            ],
          ),
        ],
      ),
    );
  }

  /// @brief Construye un campo de texto personalizado.
  /// @param label Etiqueta del campo.
  /// @param hintText Texto de sugerencia.
  /// @param icon Icono a mostrar.
  /// @param controller Controlador del campo.
  /// @param readOnly Indica si el campo es de solo lectura.
  /// @return Widget con el campo de texto.
  Widget _buildTextField({
    required String label,
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return SizedBox(
      width: kIsWeb ? 700 : 350,
      child: TextFormField(
        controller: controller,
        enabled: _isEditing && !readOnly,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          prefixIcon: Opacity(
            opacity: 0.5,
            child: Icon(icon, color: Color.fromARGB(255, 25, 84, 133)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          filled: true,
          fillColor: const Color.fromARGB(255, 245, 241, 241).withOpacity(0.8),
        ),
      ),
    );
  }
}