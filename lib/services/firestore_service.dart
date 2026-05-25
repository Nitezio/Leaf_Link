import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Minimal Firestore adapter used by Phase 1 scaffolding.
class FirestoreService {
  bool get isAvailable => Firebase.apps.isNotEmpty;

  FirebaseFirestore? get _db => isAvailable ? FirebaseFirestore.instance : null;

  CollectionReference<Map<String, dynamic>> postsCollection() =>
      _db!.collection('community_posts');

  Future<void> addPost(Map<String, dynamic> post) async {
    if (!isAvailable) return;
    await postsCollection().add(post);
  }

  Future<void> setPost(String id, Map<String, dynamic> post) async {
    if (!isAvailable) return;
    await postsCollection().doc(id).set(post);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchPosts() {
    if (!isAvailable) {
      return const Stream.empty();
    }
    return postsCollection().orderBy('createdAt', descending: true).snapshots();
  }
}
