import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ActivitiesStatsScreen extends StatelessWidget {
  const ActivitiesStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'demo';
    final col = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('activities');

    return Scaffold(
      appBar: AppBar(title: const Text("Statistiques des catégories 📊")),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: col.snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;

          // Compter les catégories
          final Map<String, int> categoryCount = {};
          for (var d in docs) {
            final cat = d.data()['category'] ?? 'autre';
            categoryCount[cat] = (categoryCount[cat] ?? 0) + 1;
          }

          final total = categoryCount.values.fold(0, (a, b) => a + b);

          if (total == 0) {
            return const Center(child: Text("Aucune activité enregistrée."));
          }

          // Transformation pour Pie Chart
          final sections = categoryCount.entries.map((entry) {
            final percentage = (entry.value / total) * 100;
            return PieChartSectionData(
              value: entry.value.toDouble(),
              title: "${entry.key}\n${percentage.toStringAsFixed(1)}%",
              radius: 60,
            );
          }).toList();

          return Center(
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 4,
              ),
            ),
          );
        },
      ),
    );
  }
}
