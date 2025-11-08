import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../modules/activity.dart';
import '../../services/ai_service.dart';
import '../../services/firestore_service.dart';

class ActivitiesAISuggestionsScreen extends StatefulWidget {
  const ActivitiesAISuggestionsScreen({super.key});

  @override
  State<ActivitiesAISuggestionsScreen> createState() => _ActivitiesAISuggestionsScreenState();
}

class _ActivitiesAISuggestionsScreenState extends State<ActivitiesAISuggestionsScreen> {
  List<String> suggestions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSuggestions();
  }

  Future<void> loadSuggestions() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'demo';
    final col = FS.colUserSub(userId, 'activities');
    final snap = await col.get();
    final activities = snap.docs.map((d) => Activity.fromDoc(d.id, d.data()));

    final previousNames = activities.map((a) => a.name).toList();

    final result = await AIService.suggestActivities(previousNames);

    setState(() {
      suggestions = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Suggestions IA ✨")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : suggestions.isEmpty
          ? const Center(child: Text("Aucune suggestion disponible."))
          : ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, i) {
          final suggestion = suggestions[i];
          return ListTile(
            leading: const Icon(Icons.auto_awesome, color: Colors.amber),
            title: Text(suggestion),
          );
        },
      ),
    );
  }
}
