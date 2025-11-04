import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../modules/activity.dart';
import 'activity_form.dart';
import 'activity_tile.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'demo';
    final col = FS.colUserSub(userId, 'activities');

    return Scaffold(
      appBar: AppBar(title: const Text('Activités bien-être 🌿')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ActivityForm(col: col)),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: col.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Aucune activité enregistrée.'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final d = docs[i];
              final activity = Activity.fromDoc(d.id, d.data());
              return ActivityTile(
                activity: activity,
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ActivityForm(col: col, existing: activity)),
                ),
                onDelete: () => FS.remove(col, activity.id),
              );
            },
          );
        },
      ),
    );
  }
}
