import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_logger.dart';

/// Minimal Firestore adapter used by Phase 1 scaffolding.
class FirestoreService {
  bool get isAvailable => Firebase.apps.isNotEmpty;

  FirebaseFirestore? get _db => isAvailable ? FirebaseFirestore.instance : null;

  CollectionReference<Map<String, dynamic>> postsCollection() =>
      _db!.collection('community_posts');

  Future<void> addPost(Map<String, dynamic> post) async {
    if (!isAvailable) return;
    try {
      // Ensure a server-side createdAt timestamp exists for ordering.
      final payload = Map<String, dynamic>.from(post);
      if (!payload.containsKey('createdAt')) {
        payload['createdAt'] = FieldValue.serverTimestamp();
      }
      // Attach ownerId from signed-in Firebase user when available.
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null && !payload.containsKey('ownerId')) {
        payload['ownerId'] = uid;
      }
      await postsCollection().add(payload);
    } catch (e, st) {
      logger.e('Failed to add post to Firestore', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> setPost(String id, Map<String, dynamic> post) async {
    if (!isAvailable) return;
    try {
      final payload = Map<String, dynamic>.from(post);
      if (!payload.containsKey('createdAt')) {
        payload['createdAt'] = FieldValue.serverTimestamp();
      }
      // Preserve existing ownerId; if missing and user is signed-in, attach it.
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (!payload.containsKey('ownerId') && uid != null) {
        payload['ownerId'] = uid;
      }
      await postsCollection().doc(id).set(payload);
    } catch (e, st) {
      logger.e('Failed to set post in Firestore', error: e, stackTrace: st);
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchPosts() {
    if (!isAvailable) {
      return const Stream.empty();
    }
    return postsCollection().orderBy('createdAt', descending: true).snapshots();
  }
}
