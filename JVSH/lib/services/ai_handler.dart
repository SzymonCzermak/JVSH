import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:gpt_flutter/services/tts_handler.dart';

class AIHandler {
  final OpenAI _openAI = OpenAI.instance.build(
    token: 'apikey',
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
    ),
  );

  final TtsHandler _ttsHandler = TtsHandler();
  final List<Map<String, String>> conversation = [];

  Future<String> getResponse(String message) async {
  try {
    String context = "Opowiadaj tylko na tematy związane z filmem, teatrem, sztuką, kinem. Na inne pytania nie odpowiadaj.";
    String fullMessage = context + message;

    conversation.add({"role": "user", "content": message});

    final request = ChatCompleteText(
        messages: conversation,
        maxToken: 200,
        model: kChatGptTurbo0301Model);

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
    return 'Prosze Powtórz.';
  }
}

  String _limitResponseToThreeSentences(String response) {
    var sentences = response.split(RegExp(r'[.!?]')).where((sentence) => sentence.trim().isNotEmpty).toList();
    return sentences.take(2).join('. ') + (sentences.length > 2 ? '.' : '');
  }

  void dispose() {
    _openAI.close();
    _ttsHandler.stop();
    conversation.clear();
  }
}
