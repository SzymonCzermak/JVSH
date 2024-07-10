import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:gpt_flutter/services/tts_handler.dart';

class AIHandler {
  final OpenAI _openAI = OpenAI.instance.build(
    token: 'apikey',
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 120),
      connectTimeout: const Duration(seconds: 120),
    ),
  );

  final TtsHandler _ttsHandler = TtsHandler();
  final List<Map<String, String>> conversation = [];

  Future<String> getResponse(String message) async {
    int retryCount = 0;
    while (retryCount < 3) {
      try {
        String context =
            "Opowiadaj tylko na tematy związane z filmem, teatrem, sztuką, kinem. Odpowiadaj krótko w 2 zdaniach maksymalnie.";
        conversation.add({"role": "user", "content": message});

        final request = ChatCompleteText(
          messages: [
            {"role": "system", "content": context},
            ...conversation
                .map(
                    (msg) => {"role": msg["role"]!, "content": msg["content"]!})
                .toList(),
          ],
          maxToken: 50,
          model: "gpt-4",
        );

        final response = await _openAI.onChatCompletion(request: request);
        if (response != null && response.choices.isNotEmpty) {
          String textResponse = response.choices[0].message.content.trim();

          textResponse = _limitResponseToTwoSentences(textResponse);

          conversation.add({"role": "assistant", "content": textResponse});

          _ttsHandler.speak(textResponse);
          return textResponse;
        }

        return 'Nie udało się uzyskać odpowiedzi.';
      } catch (e) {
        print('Error: $e');
        retryCount++;
        if (retryCount == 3) {
          return 'Proszę powtórz.';
        }
      }
    }
    return 'Proszę powtórz.';
  }

  String _limitResponseToTwoSentences(String response) {
    var sentences = response
        .split(RegExp(r'[.!?]'))
        .where((sentence) => sentence.trim().isNotEmpty)
        .toList();
    return sentences.take(2).join('. ') + (sentences.length > 2 ? '.' : '');
  }

  void dispose() {
    _openAI.close();
    _ttsHandler.dispose();
    conversation.clear();
  }
}
