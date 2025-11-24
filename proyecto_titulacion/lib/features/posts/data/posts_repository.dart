import 'package:proyecto_titulacion/features/posts/service/posts_api_service.dart';
import 'package:proyecto_titulacion/models/Post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsRepositoryProvider = Provider<PostsRepository>((ref) {
 final postsAPIService = ref.read(postsAPIServiceProvider);
 return PostsRepository(postsAPIService);
});

class PostsRepository {
 PostsRepository(this.postsAPIService);

 final PostsAPIService postsAPIService;

 Future<List<Post>> getPosts() {
   return postsAPIService.getPosts();
 }

 Future<void> add(Post post, tags) async {
   return postsAPIService.addPost(post, tags);
 }

 Future<void> update(Post updatedPost) async {
   return postsAPIService.updatePost(updatedPost);
 }

 Future<void> delete(Post deletedPost) async {
   return postsAPIService.deletePost(deletedPost);
 }

 Future<Post> getTrip(String postId) async {
   return postsAPIService.getPost(postId);
 }
}