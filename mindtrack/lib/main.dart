import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'modules/activities/activities_ai_suggestions.dart';
import 'theme/app_theme.dart';
import 'modules/home_shell.dart';
import 'modules/activities/activities_stats_screen.dart'; // ✅ Ajout ici

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MindTrackApp());
}

class MindTrackApp extends StatelessWidget {
  const MindTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeShell(),
      routes: {
        '/activities_stats': (_) => const ActivitiesStatsScreen(), // ✅ Route ajoutée
        '/activities_ai_suggestions': (context) => const ActivitiesAISuggestionsScreen(),
      },
    );
  }
}
