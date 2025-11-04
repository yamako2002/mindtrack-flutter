import 'package:cloud_firestore/cloud_firestore.dart';

class FS {
  static final db = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> colUserSub(
      String userId, String sub) =>
      db.collection('users').doc(userId).collection(sub);

  static Future<String> add(
      CollectionReference<Map<String, dynamic>> col, Map<String, dynamic> data) async {
    final doc = await col.add({...data, 'createdAt': FieldValue.serverTimestamp()});
    return doc.id;
  }

  static Future<void> update(
      CollectionReference<Map<String, dynamic>> col, String id, Map<String, dynamic> data) =>
      col.doc(id).update({...data, 'updatedAt': FieldValue.serverTimestamp()});

  static Future<void> remove(
      CollectionReference<Map<String, dynamic>> col, String id) => col.doc(id).delete();
}
