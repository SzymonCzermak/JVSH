import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:gpt_flutter/services/tts_handler.dart';

class AIHandler {
  final OpenAI _openAI = OpenAI.instance.build(
    token: 'api',
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
    ),
  );

  final TtsHandler _ttsHandler = TtsHandler();
  final List<Map<String, String>> conversation = [];

  Future<String> getResponse(String message) async {
    try {
      String context = "Opowiadaj tylko na tematy związane z filmem, teatrem, sztuką, kinem. Odpowiadaj zwięźle i na temat.";
      conversation.add({"role": "user", "content": message});

      final request = ChatCompleteText(
        messages: [
          {"role": "system", "content": context},
          ...conversation.map((msg) => {"role": msg["role"]!, "content": msg["content"]!}).toList(),
        ],
        maxToken: 50, // Zmniejszona liczba tokenów
        model: "gpt-4",
      );

      final response = await _openAI.onChatCompletion(request: request);
      if (response != null && response.choices.isNotEmpty) {
        String textResponse = response.choices[0].message.content.trim();

        // Możesz tutaj dodać logikę weryfikującą związek odpowiedzi z filmem, teatrem, sztuką, kinem
        // Na przykład sprawdzając kluczowe słowa lub frazy w odpowiedzi

        textResponse = _limitResponseToThreeSentences(textResponse);

        conversation.add({"role": "assistant", "content": textResponse});

        _ttsHandler.speak(textResponse);
        return textResponse;
      }

      return 'Nie udało się uzyskać odpowiedzi.';
    } catch (e) {
      print('Error: $e');
      return 'Proszę powtórz.';
    }
  }

  String _limitResponseToThreeSentences(String response) {
    var sentences = response.split(RegExp(r'[.!?]')).where((sentence) => sentence.trim().isNotEmpty).toList();
    return sentences.take(3).join('. ') + (sentences.length > 3 ? '.' : '');
  }

  void dispose() {
    _openAI.close();
    _ttsHandler.stop();
    conversation.clear();
  }
}
