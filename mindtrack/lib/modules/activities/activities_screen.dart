import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../modules/activity.dart';
import 'activity_form.dart';
import 'activity_tile.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final TextEditingController searchCtrl = TextEditingController();
  String search = '';

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'demo';
    final col = FS.colUserSub(userId, 'activities');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activités bien-être 🌿'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: "Suggestions IA",
            onPressed: () => Navigator.pushNamed(context, '/activities_ai_suggestions'),
          ),
          IconButton(
            icon: const Icon(Icons.pie_chart),
            tooltip: "Statistiques",
            onPressed: () => Navigator.pushNamed(context, '/activities_stats'),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ActivityForm(col: col)),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),

      body: Column(
        children: [
          // 🔍 Barre de recherche
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: "Rechercher une activité...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() => search = value),
            ),
          ),

          // 📡 Stream des données Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: col.orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snap.data?.docs ?? [];
                var activities = docs.map((d) => Activity.fromDoc(d.id, d.data())).toList();

                // 🔍 Filtrage par nom
                if (search.isNotEmpty) {
                  activities = activities.where((a) =>
                      a.name.toLowerCase().contains(search.toLowerCase())
                  ).toList();
                }

                // 📊 Statistiques du jour
                final today = DateTime.now();
                final doneToday = activities.where((a) {
                  final date = a.createdAt.toDate();
                  return a.done &&
                      date.year == today.year &&
                      date.month == today.month &&
                      date.day == today.day;
                }).toList();

                final completedCount = doneToday.length;
                final totalDuration = doneToday.fold<int>(0, (sum, a) => sum + a.duration);

                return Column(
                  children: [
                    // 🟩 Carte des stats
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Statistiques du jour", style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 8),
                            Text("✅ Activités complétées : $completedCount"),
                            Text("⏱️ Temps total : $totalDuration min"),
                          ],
                        ),
                      ),
                    ),

                    // 📋 Liste filtrée
                    Expanded(
                      child: activities.isEmpty
                          ? const Center(child: Text("Aucune activité trouvée."))
                          : ListView.builder(
                        itemCount: activities.length,
                        itemBuilder: (context, i) {
                          final activity = activities[i];
                          return ActivityTile(
                            activity: activity,
                            onEdit: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ActivityForm(col: col, existing: activity),
                              ),
                            ),
                            onDelete: () => FS.remove(col, activity.id),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
