import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'modules/home_shell.dart';

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
    );
  }
}
