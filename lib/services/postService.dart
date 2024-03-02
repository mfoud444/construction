import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction/models/post.dart';

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<void> addFood(Post post) async {
    try {
      DocumentReference docRef =
          await _db.collection('post').add(post.toJson());
      String id = docRef.id;
      await docRef.update({'id': id});
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Post>> getAllPosts(String restaurantId) async {
    try {
      final QuerySnapshot snapshot = await _db
          .collection('post')
          .where('rorgnizeId', isEqualTo: restaurantId)
          .get();
      final List<Post> foods = snapshot.docs
          .map((DocumentSnapshot doc) =>
              Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return foods;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Post>> getPostsByCategory(
      String restaurantId, String category) async {
    try {
      final QuerySnapshot snapshot = await _db
          .collection('post')
          .where('restaurantId', isEqualTo: restaurantId)
          .where('category', isEqualTo: category)
          .get();
      final List<Post> foods = snapshot.docs
          .map((DocumentSnapshot doc) =>
              Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return foods;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Post>> getPostById(String id) async {
    try {
      final QuerySnapshot snapshot =
          await _db.collection('post').where('id', isEqualTo: id).get();
      final List<Post> foods = snapshot.docs
          .map((DocumentSnapshot doc) =>
              Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return foods;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateFood(Post post) async {
    try {
      await _db.collection('post').doc(post.id).update(post.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFood(String id) async {
    try {
      await _db.collection('foods').doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
