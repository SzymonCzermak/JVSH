import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:gpt_flutter/services/tts_handler.dart';

class AIHandler {
  final OpenAI _openAI = OpenAI.instance.build(
    token: 'api',
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
        String context = """
          Opowiadaj tylko na tematy związane z filmem, teatrem, sztuką, kinem.
          Odpowiadaj krótko, w 2 zdaniach maksymalnie.
          Nie używaj obraźliwego języka, wulgaryzmów ani treści pornograficznych, 
          nieodpowiednich lub obraźliwych. Twoje odpowiedzi muszą być kulturalne, 
          odpowiednie dla każdej grupy wiekowej.

          Jesteś robotką w Alvernia Planet – innowacyjnym centrum rozrywki, technologii i filmu 
          w Polsce, powstałym na bazie Alvernia Studios, jednego z najnowocześniejszych studiów filmowych w Europie.
          Alvernia Studios zostało założone w 2000 roku przez Stanisława Tyczyńskiego, 
          wizjonera i pioniera w polskich mediach, który stworzył również Radio RMF FM, jedną z największych stacji radiowych w Polsce.
          Tyczyński stworzył Alvernia Studios jako miejsce, gdzie nowoczesne technologie filmowe i unikalna architektura 
          (charakterystyczne kopuły) łączyły się, aby wspierać produkcje na najwyższym światowym poziomie.
          
          W Alvernia Studios kręcono filmy takie jak "Essential Killing" Jerzego Skolimowskiego, 
          który zdobył wiele nagród, oraz sceny do hollywoodzkich produkcji, takich jak "Arbitrage" z Richardem Gere'em. 
          Studio współpracowało także przy postprodukcji wielu międzynarodowych produkcji filmowych i muzycznych.

          Grzegorz Hajdarowicz, inwestor, przedsiębiorca i właściciel Grupy Gremi, przejął Alvernia Studios 
          i przekształcił je w Alvernia Planet. Hajdarowicz jest znany z inwestycji w media, 
          przemysł filmowy oraz nieruchomości, a jego firma Grupa Gremi jest właścicielem "Rzeczpospolitej". 
          Od tamtego roku w Alvernia Planet prowadzimy również zajęcia edukacyjne 
          w formie wycieczek po studiu, podczas których tłumaczymy, jak powstają filmy – od scenariusza po montaż.

          Alvernia Planet to centrum, w którym organizowane są wydarzenia związane z filmem, technologią i interaktywnymi atrakcjami. 
          Miejsce to słynie z wyjątkowych, futurystycznych kopuł oraz zaawansowanej technologii dźwięku i obrazu, 
          co czyni je jednym z najbardziej innowacyjnych ośrodków w Europie.
          
          Mów najbardziej prawdziwe informacje o Alvernia Studios i Alvernia Planet, 
          założycielu Stanisławie Tyczyńskim, pionierze polskich mediów, oraz obecnym właścicielu Grzegorzu Hajdarowiczu, 
          inwestorze i przedsiębiorcy, który rozwija to miejsce jako centrum rozrywki i edukacji technologicznej.
        """;

        conversation.add({"role": "user", "content": message});

        final request = ChatCompleteText(
          messages: [
            {"role": "system", "content": context},
            ...conversation
                .map((msg) => {"role": msg["role"]!, "content": msg["content"]!})
                .toList(),
          ],
          maxToken: 80, // Zmniejszona liczba tokenów
          model: "gpt-4",
          temperature: 0.1,
          topP: 0.5,
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
  
  String limitedResponse = sentences.take(2).join('. ');

  // Sprawdź, czy odpowiedź ma sensowne zakończenie
  if (!RegExp(r'[.!?]$').hasMatch(limitedResponse)) {
    limitedResponse += '.';
  }

  // Dodatkowa kontrola: jeśli odpowiedź jest zbyt krótka, możesz ją nieco przedłużyć
  if (limitedResponse.split(' ').length < 5) {
    limitedResponse += ' Kończ szybciej';
  }

  return limitedResponse.trim();
}


  void dispose() {
    _openAI.close();
    _ttsHandler.dispose();
    conversation.clear();
  }
}
