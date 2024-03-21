import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:gpt_flutter/services/tts_handler.dart';

class AIHandler {
  final OpenAI _openAI = OpenAI.instance.build(
    token: 'apikey', // Zastąp 'twoj-klucz-api' swoim faktycznym kluczem API
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
    ),
  );

  final TtsHandler _ttsHandler = TtsHandler(); // Dodanie instancji TtsHandler
  final List<Map<String, String>> conversation = []; // Lista do przechowywania historii rozmowy

  Future<String> getResponse(String message) async {
    try {
      String context = "Odpowiadaj możliwie najkrócej, ale kompleksowo, na pytania związane z filmem, aktorami, teatrem oraz pisarzami. Na pytania poza tym zakresem odpowiadaj, że to nie twoje kompetencje.";
      String fullMessage = context + message; // Łączymy kontekst z wiadomością użytkownika

      // Dodajemy wiadomość użytkownika do historii rozmowy
      conversation.add({"role": "user", "content": message});

      final request = ChatCompleteText(
        messages: conversation, // Przekazujemy całą historię rozmowy
        maxToken: 200,
        model: kChatGptTurbo0301Model);

      final response = await _openAI.onChatCompletion(request: request);
      if (response != null && response.choices.isNotEmpty) {
        String textResponse = response.choices[0].message.content.trim();

        // Dodajemy odpowiedź modelu do historii rozmowy
        conversation.add({"role": "assistant", "content": textResponse});

        // Sprawdzamy, czy odpowiedź jest związana z zadanymi tematami
        if (isResponseRelated(textResponse)) {
          _ttsHandler.speak(textResponse); // Wywołanie TTS do odczytania odpowiedzi
          return textResponse;
        } else {
          String unrelatedResponse = "Przykro mi, ale to pytanie wykracza poza moje kompetencje. Skupiam się tylko na filmach, aktorach, teatrze i pisarstwie.";
          _ttsHandler.speak(unrelatedResponse);
          return unrelatedResponse;
        }
      }

      return 'Something went wrong';
    } catch (e) {
      return 'Bad response';
    }
  }

  bool isResponseRelated(String response) {
    // Tu możesz dodać bardziej zaawansowaną logikę sprawdzającą słowa kluczowe itp.
    // Poniżej jest bardzo prosty przykład
    List<String> keywords = ['film', 'aktor', 'teatr', 'pisarz', 'reżyser', 'scenariusz'];
    for (var keyword in keywords) {
      if (response.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  void dispose() {
    _openAI.close();
    _ttsHandler.stop(); // Zatrzymaj TTS przy zamykaniu
    conversation.clear(); // Opcjonalnie czyścimy historię rozmowy przy zamykaniu
  }
}