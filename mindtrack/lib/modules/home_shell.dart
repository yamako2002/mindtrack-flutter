import 'package:flutter/material.dart';
import 'moods/moods_screen.dart';
import 'activities/activities_screen.dart';
import 'advices/advices_screen.dart';
import 'profile/profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  final pages = const [
    MoodsScreen(),
    ActivitiesScreen(),
    AdvicesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.mood), label: 'Humeurs'),
          NavigationDestination(icon: Icon(Icons.spa), label: 'Activités'),
          NavigationDestination(icon: Icon(Icons.tips_and_updates), label: 'Conseils'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
