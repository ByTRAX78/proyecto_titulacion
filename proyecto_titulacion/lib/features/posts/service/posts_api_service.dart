import 'dart:async';
import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsAPIServiceProvider = Provider<PostsAPIService>((ref) {
  final service = PostsAPIService();
  return service;
});

class PostsAPIService {
  PostsAPIService();

  Future<String?> uploadImage(File imageFile) async {
    try {
      final extension = imageFile.path.split('.').last;
      final key = 'post_${DateTime.now().millisecondsSinceEpoch}.$extension';

      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(imageFile.path),
        key: key,
        
        onProgress: (progress) {
          safePrint('Subiendo: ${progress.fractionCompleted * 100}%');
        },
    ).result;

    safePrint('✅ Imagen subida: ${result.uploadedItem.key}');
    
    return result.uploadedItem.key;

    } catch (e) {
      safePrint('❌ Error subiendo imagen: ${e}');
      return null;
    }
  }

  Future<List<Post>> getPosts() async {
    try {
      final request = ModelQueries.list(Post.classType, where: Post.TYPE.eq("Post"),);
      final response = await Amplify.API.query(request: request).response;

      final posts = response.data?.items.whereType<Post>().toList() ?? [];
      posts.sort((a,b) => b.createdAt!.compareTo(a.createdAt!));
      return posts;
  
    } on Exception catch (error) {
      safePrint('getposts failed: $error');

      return const [];
    }
  }


  Future<void> addPost(Post post, List<String> tagsParaBusqueda) async {
    try {
      final request = ModelMutations.create(post);
      final response = await Amplify.API.mutate(request: request).response;

      final createdPost = response.data;
      if (createdPost == null) {
        safePrint('addPost errors: ${response.errors}');
        return;
      }
      for (String tag in tagsParaBusqueda) {
        final tagIndex = PostTag(
          tagName: tag.toLowerCase().trim(), // Normalizamos a minúsculas
          postId: createdPost.id,            // Conectamos con el ID del post creado
          createdAt: TemporalDateTime.now(), 
          updatedAt: TemporalDateTime.now()// Para ordenar búsquedas
        );
        
        // No necesitamos esperar (await) a que termine cada uno para seguir, 
        // pero sí enviarlos a la nube.
        await Amplify.API.mutate(request: ModelMutations.create(tagIndex)).response;
      }
      safePrint('Post y tags guardados.');
    } on Exception catch (error) {
      safePrint('addPost failed: $error');
    }
  }

  Future<void> deletePost(Post post) async {
    try {
      await Amplify.API
          .mutate(
            request: ModelMutations.delete(post),
            
          )
          .response;
          safePrint('Post borrado.');
    } on Exception catch (error) {
      safePrint('deletePost failed: $error');
    }
  }

  Future<void> updatePost(Post updatedPost) async {
    try {
      await Amplify.API
          .mutate(
            request: ModelMutations.update(updatedPost),
          )
          .response;
    } on Exception catch (error) {
      safePrint('updatePost failed: $error');
    }
  }

  Future<Post> getPost(String postId) async {
    try {
      final request = ModelQueries.get(
        Post.classType,
        PostModelIdentifier(id: postId),
      );
      final response = await Amplify.API.query(request: request).response;

      final post = response.data!;
      return post;
    } on Exception catch (error) {
      safePrint('getPost failed: $error');
      rethrow;
    }
  }
}