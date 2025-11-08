import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../modules/activity.dart';
import '../../services/firestore_service.dart';

class ActivityTile extends StatelessWidget {
  final Activity activity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ActivityTile({
    super.key,
    required this.activity,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final col = FS.colUserSub(FirebaseFirestore.instance.app.options.projectId, 'activities');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: activity.done,
          onChanged: (value) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid ?? 'demo')
                .collection('activities')
                .doc(activity.id)
                .update({'done': value});
          },
        ),
        title: Text(
          activity.done ? "✅ ${activity.name}" : activity.name,
          style: TextStyle(
            decoration: activity.done ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text("${activity.category} • ${activity.duration} min"),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text("Modifier")),
            const PopupMenuItem(value: 'delete', child: Text("Supprimer")),
          ],
        ),
      ),
    );
  }
}
