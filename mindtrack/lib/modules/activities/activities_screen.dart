import 'package:flutter/material.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Activités')),
      body: const Center(
        child: Text('Page des Activités 🌿', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
