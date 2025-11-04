import 'package:flutter/material.dart';
import '../../modules/activity.dart';

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

  IconData _iconFor(String category) {
    switch (category.toLowerCase()) {
      case 'sport':
        return Icons.fitness_center;
      case 'relaxation':
        return Icons.spa;
      case 'lecture':
        return Icons.book;
      case 'sommeil':
        return Icons.nightlight_round;
      default:
        return Icons.favorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Icon(_iconFor(activity.category),
            color: Theme.of(context).colorScheme.primary),
        title: Text(activity.name),
        subtitle: Text('${activity.duration} min • ${activity.category}'),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'edit') onEdit();
            if (v == 'delete') onDelete();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Modifier')),
            PopupMenuItem(value: 'delete', child: Text('Supprimer')),
          ],
        ),
      ),
    );
  }
}
