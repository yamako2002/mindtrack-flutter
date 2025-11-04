import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../modules/activity.dart';
import '../../services/firestore_service.dart';

class ActivityForm extends StatefulWidget {
  final CollectionReference<Map<String, dynamic>> col;
  final Activity? existing;

  const ActivityForm({super.key, required this.col, this.existing});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  String category = 'relaxation';
  double duration = 30;
  bool done = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final a = widget.existing!;
      nameCtrl.text = a.name;
      noteCtrl.text = a.note ?? '';
      category = a.category;
      duration = a.duration.toDouble();
      done = a.done;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'name': nameCtrl.text.trim(),
      'category': category,
      'duration': duration.round(),
      'done': done,
      'note': noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
    };
    if (widget.existing == null) {
      await FS.add(widget.col, data);
    } else {
      await FS.update(widget.col, widget.existing!.id, data);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'Nouvelle activité' : 'Modifier activité')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nom de l’activité',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Nom obligatoire' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: category,
              items: const [
                DropdownMenuItem(value: 'sport', child: Text('Sport')),
                DropdownMenuItem(value: 'relaxation', child: Text('Relaxation')),
                DropdownMenuItem(value: 'lecture', child: Text('Lecture')),
                DropdownMenuItem(value: 'sommeil', child: Text('Sommeil')),
              ],
              onChanged: (v) => setState(() => category = v ?? 'relaxation'),
              decoration: const InputDecoration(
                labelText: 'Catégorie',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text('Durée : ${duration.round()} min'),
            Slider(
              value: duration,
              min: 5,
              max: 180,
              divisions: 35,
              onChanged: (v) => setState(() => duration = v),
            ),
            CheckboxListTile(
              value: done,
              onChanged: (v) => setState(() => done = v ?? false),
              title: const Text('Activité effectuée'),
            ),
            TextFormField(
              controller: noteCtrl,
              decoration: const InputDecoration(
                labelText: 'Note / description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
