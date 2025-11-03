import 'package:flutter/material.dart';

class AdvicesScreen extends StatelessWidget {
  const AdvicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conseils')),
      body: const Center(
        child: Text('Page des Conseils 💡', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
