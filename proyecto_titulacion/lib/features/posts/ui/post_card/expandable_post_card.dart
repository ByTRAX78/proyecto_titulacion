import 'package:flutter/material.dart';

class ExpandablePostCard extends StatefulWidget {
  final int index;
  const ExpandablePostCard({super.key, required this.index});

  @override
  State<ExpandablePostCard> createState() => _ExpandablePostCardState();
}

class _ExpandablePostCardState extends State<ExpandablePostCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, 
      margin: const EdgeInsets.only(bottom: 12),
      // Color gris suave constante (como pediste en la imagen de small screens)
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      
      child: InkWell(
        // Al tocar, solo cambiamos el booleano
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Column(
          children: [
            // 1. ENCABEZADO (Siempre visible y SIEMPRE IGUAL)
            // No cambia de forma, por eso no se traba.
            ListTile(
              contentPadding: const EdgeInsets.all(12),
              // Imagen pequeña a la izquierda
              leading: Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage('https://picsum.photos/seed/${widget.index}/200'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Textos
              title: Text('Juego #${widget.index}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(isExpanded ? 'Detalles mostrados' : 'Toca para expandir'),
              // La flecha gira sola, es una animación muy barata para el CPU
              trailing: AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.keyboard_arrow_down),
              ),
            ),

            // 2. CONTENIDO OCULTO (Solo aparece abajo)
            // AnimatedSize solo tiene que "empujar" los pixeles, no redibujar imágenes.
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: isExpanded 
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen grande
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.network(
                          'https://picsum.photos/seed/${widget.index}/500/300',
                          fit: BoxFit.cover,
                        ),
                      ),
                      
                      // Texto de descripción
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Aquí está el resto de la información. Al mantener el encabezado fijo y solo deslizar esto hacia abajo, el rendimiento es mucho mejor.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),

                      // Botones
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(onPressed: (){}, child: const Text('Cerrar')),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: (){}, 
                              icon: const Icon(Icons.download, size: 18),
                              label: const Text('Instalar')
                            ),
                          ],
                        ),
                      )
                    ],
                  ) 
                : const SizedBox.shrink(), // Si está cerrado, no ocupa espacio
            ),
          ],
        ),
      ),
    );
  }
}