import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  static const apiKey = "AIzaSyDSRfvYkDN7JYTdHLLJ-9Fz0JN8IazcQNE"; // Ne change rien d'autre

  static Future<List<String>> suggestActivities(List<String> previous) async {
    final model = GenerativeModel(
      model: 'gemini-2.5-flash', // ✅ modèle correct
      apiKey: apiKey,
    );

    final prompt = """
Je suis une application de bien-être. 
Voici les activités déjà effectuées par l'utilisateur:
${previous.join(", ")}

Propose-moi 5 nouvelles activités simples, relaxantes et accessibles.
Format: une activité par ligne, sans numérotation et sans explication.
""";

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text ?? "";

    return text
        .split("\n")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}
