import 'package:flutter/material.dart';
import 'package:proyecto_titulacion/features/posts/ui/post_card/expandable_post_card.dart';

class PostsListPage extends StatelessWidget {
  const PostsListPage({super.key});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20), 
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), 
            child: SearchBar(
              hintText: 'Buscar Post...',
              leading: const Icon(Icons.search),

              onTap: () {
                
              },

              onChanged: (value) {
                print("Buscando: $value");
              },
            )
          ),
        ),
      ),
      body: ListView.builder(

        

        itemBuilder: (context, index) {
        
          return ExpandablePostCard(index: index);
         
          
        },
      )
    );
  }
}