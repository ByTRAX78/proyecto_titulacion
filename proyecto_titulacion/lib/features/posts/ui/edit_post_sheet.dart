import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:proyecto_titulacion/features/posts/controller/posts_list_controller.dart';
import 'package:proyecto_titulacion/features/posts/service/posts_api_service.dart'; // Para subir foto si la cambian

class EditPostSheet extends ConsumerStatefulWidget {
  final Post post; 

  const EditPostSheet({super.key, required this.post});

  @override
  ConsumerState<EditPostSheet> createState() => _EditPostSheetState();
}

class _EditPostSheetState extends ConsumerState<EditPostSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  final _tagInputController = TextEditingController();

  bool _isUploading = false;
  File? _newImageFile; 
  List<String> _tags = [];
  List<DateTime> _dates = [];

  @override
  void initState() {
    super.initState();
    // 1. PRE-LLENAR LOS DATOS
    _titleController = TextEditingController(text: widget.post.title);
    _descController = TextEditingController(text: widget.post.description);
    
    // Recuperar tags
    if (widget.post.tags != null) {
      _tags = List.from(widget.post.tags!);
    }
    
    // Recuperar fechas (convirtiendo de TemporalDate a DateTime)
    if (widget.post.dates != null) {
      _dates = widget.post.dates!.map((t) => DateTime.parse(t.toString())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Editar Publicación', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          
          Expanded(
            child: ListView(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                Text('Fechas', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    ..._dates.map((date) => InputChip(
                      label: Text('${date.day}/${date.month}'),
                    )),
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 16),
                      label: const Text('Agregar Fecha'),
                      onPressed: _pickDate,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // FOTO
                GestureDetector(
                  onTap: _pickNewImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: _newImageFile != null
                        ? Image.file(_newImageFile!, fit: BoxFit.cover) // Muestra la nueva
                        : (widget.post.images != null && widget.post.images!.isNotEmpty)
                            ? const Center(child: Text("Imagen actual guardada (Toca para cambiar)")) // O usa tu StorageImage aquí
                            : const Center(child: Icon(Icons.add_a_photo)),
                  ),
                ),
                
                // ... (Aquí iría tu código de Tags y Dates igual que en Create) ...
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: _isUploading ? null : _guardarCambios,
              child: Text(_isUploading ? 'Guardando...' : 'ACTUALIZAR'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickNewImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _newImageFile = File(image.path));
    }
  }

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

  Future<void> _guardarCambios() async {
    setState(() => _isUploading = true);
    try {
      String? newImageKey;

      // Solo subimos foto si el usuario eligió una NUEVA
      if (_newImageFile != null) {
        newImageKey = await ref.read(postsAPIServiceProvider).uploadImage(_newImageFile!);
      }

      // LLAMAMOS AL UPDATE DEL CONTROLLER
      await ref.read(postsListControllerProvider.notifier).updatePost(
        originalPost: widget.post, // Pasamos el original para conservar ID
        title: _titleController.text,
        description: _descController.text,
        dates: _dates,
        tags: _tags,
        newImageKey: newImageKey, // Si es null, el controller mantendrá la vieja
      );

      if (mounted) {
        Navigator.pop(context); // Cerrar hoja
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Actualizado!')));
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }
}