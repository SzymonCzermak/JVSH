import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:gpt_flutter/services/tts_handler.dart';

class AIHandler {
  final _openAI = OpenAI.instance.build(
    token:
        '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', // Zastąp 'twoj-klucz-api' swoim faktycznym kluczem API
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
    ),
  );

  final TtsHandler _ttsHandler = TtsHandler(); // Dodanie instancji TtsHandler

  Future<String> getResponse(String message) async {
    try {
      final request = ChatCompleteText(messages: [
        Map.of({"role": "user", "content": message})
      ], maxToken: 200, model: kChatGptTurbo0301Model);

      final response = await _openAI.onChatCompletion(request: request);
      if (response != null && response.choices.isNotEmpty) {
        String textResponse = response.choices[0].message.content.trim();
        _ttsHandler
            .speak(textResponse); // Wywołanie TTS do odczytania odpowiedzi
        return textResponse;
      }

      return 'Something went wrong';
    } catch (e) {
      return 'Bad response';
    }
  }

  void dispose() {
    _openAI.close();
    _ttsHandler.stop(); // Zatrzymaj TTS przy zamykaniu
  }
}
