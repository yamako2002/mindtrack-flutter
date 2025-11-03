import 'package:flutter/material.dart';

class MoodsScreen extends StatelessWidget {
  const MoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Humeurs')),
      body: const Center(
        child: Text('Page des Humeurs 🧠', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
