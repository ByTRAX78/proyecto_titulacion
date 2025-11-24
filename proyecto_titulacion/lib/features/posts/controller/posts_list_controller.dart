import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:path/path.dart';
import 'package:proyecto_titulacion/features/posts/data/posts_repository.dart';
import 'package:proyecto_titulacion/models/ModelProvider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_list_controller.g.dart';

@riverpod
class PostsListController extends _$PostsListController {


 Future<List<Post>> _fetchPosts() async {
   final postsRepository = ref.read(postsRepositoryProvider);
   final posts = await postsRepository.getPosts();
   return posts;
 }

 @override
 FutureOr<List<Post>> build() async {
   return _fetchPosts();
 }

 Future<void> addPost({
   required String title,
   required String description,
   required List<String> dates,
   required List<String> tags,
   required List<String> imageKey,
 }) async {
   final parsedDates = dates 
      .map((d) => TemporalDate(DateTime.parse(d)))
      .toList();

   
    final currentUser = await Amplify.Auth.getCurrentUser();
    final userId = currentUser.userId;

    String nombreAutor = currentUser.username;

    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();

      final nameAttr = attributes.firstWhere(
        (attr) => attr.userAttributeKey == CognitoUserAttributeKey.name,
        orElse: () => const AuthUserAttribute(userAttributeKey: CognitoUserAttributeKey.name, value: ""),
      );

      nombreAutor = nameAttr.value;

    } catch (e) {
      safePrint(e);
    }

   final post = Post(
     title: title,
     description: description,
     dates: parsedDates,
     createdAt: TemporalDateTime.now(),
     updatedAt: TemporalDateTime.now(),
     authorId: userId,
     tags: tags,
     images: imageKey,
     authorName: nombreAutor,
   );

   state = const AsyncValue.loading();

   state = await AsyncValue.guard(() async {
     final postsRepository = ref.read(postsRepositoryProvider);
     await postsRepository.add(post, tags);
     return _fetchPosts();
   });
 }

 Future<void> removePost(Post post) async {
   state = const AsyncValue.loading();
   state = await AsyncValue.guard(() async {
     final postsRepository = ref.read(postsRepositoryProvider);
     await postsRepository.delete(post);

     return _fetchPosts();
   });
 }

 Future<void> updatePost({
  required Post originalPost,
  required String title,
  required String description,
  required List<DateTime> dates,
  required List<String> tags,
  String? newImageKey,
 }) async {
  final parsedDate = dates.map((d) => TemporalDate(d)).toList();
  final updatePost = originalPost.copyWith(
    title: title,
    description: description,
    dates: parsedDate,
    tags: tags,
    images: newImageKey != null ? [newImageKey] : originalPost.images,
    updatedAt: TemporalDateTime.now(),
  );
  state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final postsRepository = ref.read(postsRepositoryProvider);
      await postsRepository.update(updatePost); 

      return _fetchPosts(); 
    });
 }
}