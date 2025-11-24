import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:proyecto_titulacion/features/posts/controller/posts_list_controller.dart';
import 'package:proyecto_titulacion/features/posts/service/posts_api_service.dart';
import 'package:proyecto_titulacion/main.dart';

// Asegúrate de importar tus modelos
import '../../../models/ModelProvider.dart';

class CreatePostSheet extends ConsumerStatefulWidget {
  const CreatePostSheet({super.key});

  @override
  ConsumerState<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends ConsumerState<CreatePostSheet> {
  // Controladores
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _tagInputController = TextEditingController();

  // Estado
  bool _isUploading = false; // Para mostrar ruedita de carga
  File? _selectedImage;      // Foto local
  final List<String> _tags = []; // Etiquetas
  final List<DateTime> _dates = []; // Fechas seleccionadas

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ocupa solo lo necesario
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. CABECERA (Título y Cerrar)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nueva Publicación',
                style: Theme.of(context).textTheme.headlineSmall,
                
                
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          
          // 2. FORMULARIO SCROLLEABLE
          Expanded(
            child: ListView(
              children: [
                // --- TÍTULO ---
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // --- DESCRIPCIÓN ---
                TextField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: '¿Qué vamos a hacer?',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // --- SELECCIÓN DE FECHAS ---
                Text('Fechas', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ..._dates.map((date) => InputChip(
                          label: Text('${date.day}/${date.month}'),
                          onDeleted: () => setState(() => _dates.remove(date)),
                        )),
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 16),
                      label: const Text('Agregar fecha'),
                      onPressed: _pickDate,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- SELECCIÓN DE IMAGEN ---
                Text('Foto de portada', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                              Text('Toca para subir imagen', style: TextStyle(color: Colors.grey)),
                            ],
                          )
                        : null, // Si hay imagen, no mostramos el icono
                  ),
                ),
                const SizedBox(height: 16),

                // --- ETIQUETAS (TAGS) ---
                TextField(
                  controller: _tagInputController,
                  decoration: InputDecoration(
                    labelText: 'Etiquetas (Ej: Playa, Comida)',
                    prefixIcon: const Icon(Icons.label),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: _addTag,
                    ),
                  ),
                  onSubmitted: (_) => _addTag(),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _tags.map((tag) => Chip(
                    label: Text(tag),
                    onDeleted: () => setState(() => _tags.remove(tag)),
                  )).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. BOTÓN DE PUBLICAR
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: _isUploading ? null : _guardarTodo,
              icon: _isUploading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send),
              label: Text(_isUploading ? 'Subiendo...' : 'PUBLICAR'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- LÓGICA DE FECHAS ---
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2030),
    );
    if (picked != null && !_dates.contains(picked)) {
      setState(() {
        _dates.add(picked);
        _dates.sort();
      });
    }
  }

  // --- LÓGICA DE IMAGEN ---
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  // --- LÓGICA DE TAGS ---
  void _addTag() {
    final text = _tagInputController.text.trim();
    if (text.isNotEmpty && !_tags.contains(text)) {
      setState(() {
        _tags.add(text);
        _tagInputController.clear();
      });
    }
  }

  // --- GUARDADO MAESTRO (S3 + DYNAMODB) ---
  Future<void> _guardarTodo() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falta el título')));
      return;
    }

    setState(() => _isUploading = true);

    try {
      String? imageKey;

      if (_selectedImage != null) {
      // Usamos la función que acabamos de crear en el servicio
      imageKey = await ref.read(postsAPIServiceProvider).uploadImage(_selectedImage!);
      
      if (imageKey == null) {
        throw Exception("Falló la subida de imagen");
      }
    }

      await ref.read(postsListControllerProvider.notifier).addPost(
        title: _titleController.text.trim(), 
        description: _descController.text.trim(), 
        dates: _dates.map((d) => d.toIso8601String()).toList(), 
        tags: _tags,
        imageKey: imageKey != null ? [imageKey] : []
      );

      Navigator.pop(context);

    } catch (e) {
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }
}