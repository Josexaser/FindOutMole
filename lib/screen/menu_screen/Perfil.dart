import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findoutmole/screen/FootBar.dart'; // Importa el pie de página
import 'package:flutter/foundation.dart' show kIsWeb;

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

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

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores de texto
    _nombreController = TextEditingController();
    _apellidosController = TextEditingController();
    _emailController = TextEditingController();
    _edadController = TextEditingController();
    _pesoController = TextEditingController();
    _alturaController = TextEditingController();

    // Cargar datos del usuario al iniciar
    _loadUserData();
  }

  @override
  void dispose() {
    // Libera los recursos utilizados por los controladores de texto
    _nombreController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _edadController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  // Método para cargar los datos del usuario desde Firebase
  Future<void> _loadUserData() async {
    try {
      final user =
          FirebaseAuth.instance.currentUser; // Obtiene el usuario autenticado
      if (user != null) {
        // Asignar el correo electrónico directamente desde FirebaseAuth
        setState(() {
          _emailController.text = user.email ?? 'Correo no definido';
        });

        // Obtener otros datos del usuario desde Firestore
        final doc =
            await FirebaseFirestore.instance
                .collection('users') // Colección en Firestore
                .doc(user.uid) // Documento basado en el UID del usuario
                .get();

        if (doc.exists) {
          final data = doc.data()!;
          setState(() {
            // Asigna los datos obtenidos a los controladores
            _nombreController.text = data['nombre'] ?? '';
            _apellidosController.text = data['apellidos'] ?? '';
            _edadController.text = data['edad'] ?? '';
            _pesoController.text = data['peso'] ?? '';
            _alturaController.text = data['altura'] ?? '';
          });
        }
      }
    } catch (e) {
      // Muestra un mensaje de error si ocurre algún problema
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar datos: $e')));
    }
  }

  // Método para guardar los datos del usuario en Firestore
  Future<void> _saveUserData() async {
    try {
      final user =
          FirebaseAuth.instance.currentUser; // Obtiene el usuario autenticado
      if (user != null) {
        // Guarda los datos en la colección 'Perfil' en Firestore
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
        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos guardados correctamente')),
        );
      }
    } catch (e) {
      // Muestra un mensaje de error si ocurre algún problema
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar datos: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/2.png', // Ruta de la imagen
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
                          Navigator.pop(
                            context,
                          ); // Regresar a la pantalla anterior
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
                      // Campos de texto para los datos del usuario
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
                        readOnly: true, // Campo de solo lectura
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
                            onPressed:
                                _isEditing
                                    ? () async {
                                      await _saveUserData();
                                      setState(() {
                                        _isEditing =
                                            false; // Deshabilitar edición
                                      });
                                    }
                                    : null,
                            child: const Text('Guardar Cambios'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = true; // Habilitar edición
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
              const FooterBar(), // Asegúrate de que FootBar esté implementado correctamente
            ],
          ),
        ],
      ),
    );
  }

  // Método para construir un campo de texto

  Widget _buildTextField({
    required String label,
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return SizedBox(
      width: kIsWeb ? 700 : 350, // más ancho en web
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
