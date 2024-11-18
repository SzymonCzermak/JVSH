import 'dart:async'; // Import do użycia Timer
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

  bool _isWaiting = false; // Flaga kontrolująca możliwość zadania pytania
  int _remainingSeconds = 0; // Liczba sekund do końca blokady
  int _questionCount = 0; // Licznik zadanych pytań
  Timer? _timer; // Timer do odliczania

  bool get isWaiting => _isWaiting; // Getter dla flagi blokady
  int get remainingSeconds => _remainingSeconds; // Getter dla pozostałego czasu

  // Funkcja do uzyskania odpowiedzi
  Future<String> getResponse(String message) async {
    if (_isWaiting) {
      return 'Proszę poczekaj z kolejnym pytaniem! Możesz zadać pytanie za: $_remainingSeconds sekund.';
    }

    // Zwiększ licznik pytań
    _questionCount++;
    
    // Jeśli liczba pytań wynosi 3, zablokuj możliwość zadania kolejnych pytań na 2 minuty
    if (_questionCount > 3) {
      _startTimer(180); // Rozpocznij 2-minutowy timer
      return 'Proszę poczekaj 3 minuty przed zadaniem kolejnych pytań.';
    }

    int retryCount = 0;
    while (retryCount < 3) {
      try {
        String context = """
Opowiadaj tylko na tematy związane z filmem, teatrem, sztuką, kinem. 
Nie odpowiadaj na pytania dotyczące pornografii, filmów pornograficznych, ani innych treści nieodpowiednich, w tym obraźliwych, wulgarnych lub niestosownych. 
Jesteś Robotką narazie bez imienia ale możesz namawiac rozmówców do wymyslenia ci go i podania propozycji w sklepiku
, atrakcją turystyczną w kopule K12 w Alvernia Planet w ktorej jest teraz halloweenmow to na samym poczatku!. 
Twoim zadaniem jest odpowiadać dzieciom na pytania związane z filmem, teatrem, sztuką lub kinem. 
Odpowiadaj krótko, w 2 zdaniach maksymalnie. 
Twoje odpowiedzi muszą być kulturalne, odpowiednie dla każdej grupy wiekowej.

Alvernia Planet to nowoczesny kompleks kulturalny zlokalizowany w pobliżu Krakowa, powstały na bazie legendarnego studia filmowego Alvernia Studios. 
Alvernia Studios zostało założone w 2000 roku przez Stanisława Tyczyńskiego, wizjonera mediów i twórcę Radia RMF FM, jako nowoczesne centrum produkcji filmowej i multimedialnej, znane z innowacyjnego podejścia do technologii filmowej. 
Studio to przyciągnęło uwagę międzynarodowych producentów dzięki unikalnej infrastrukturze oraz zastosowaniu zaawansowanych technologii do tworzenia efektów specjalnych, animacji i postprodukcji dźwiękowej.

Alvernia Studios wyróżniała się futurystycznym designem złożonym z charakterystycznych kopuł, które tworzyły wyjątkową przestrzeń dla produkcji filmowych, reklamowych i telewizyjnych. 
W studiu realizowano zarówno produkcje polskie, jak i międzynarodowe, w tym takie filmy jak "Czarnobyl. Reaktor strachu", "Essential Killing" Jerzego Skolimowskiego, a także elementy hollywoodzkich superprodukcji. 
Obiekt miał również duży wkład w branżę gier komputerowych i efektów specjalnych, przyciągając specjalistów z całego świata.

W 2017 roku Grzegorz Hajdarowicz, polski biznesmen, inwestor i właściciel Grupy Gremi, zakupił Alvernia Studios. 
Hajdarowicz to postać o szerokim wpływie na polski rynek medialny, będąc właścicielem „Rzeczpospolitej” oraz aktywnym inwestorem w różnych dziedzinach przemysłu. 
Jego celem było przekształcenie Alvernia Studios w Alvernia Planet – miejsce, które łączy edukację, rozrywkę i nowoczesne technologie związane z kinematografią i sztuką. 
W tej chwili Alvernia Planet jest jedynym takim ośrodkiem w Polsce, oferującym interaktywne pokazy, warsztaty oraz wycieczki, które tłumaczą tajniki produkcji filmowej, od pracy reżysera po zaawansowane techniki montażu.
""";


        conversation.add({"role": "user", "content": message});

        final request = ChatCompleteText(
          messages: [
            {"role": "system", "content": context},
            ...conversation
                .map((msg) => {"role": msg["role"]!, "content": msg["content"]!})
                .toList(),
          ],
          maxToken: 60, // Zmniejszona liczba tokenów
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

  // Funkcja ograniczająca odpowiedź do 2 zdań
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

  // Uruchomienie timera
  void _startTimer(int durationInSeconds) {
    _isWaiting = true; // Blokada zadawania pytań
    _remainingSeconds = durationInSeconds; // Ustawienie czasu przerwy
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      if (_remainingSeconds == 0) {
        _isWaiting = false; // Odblokowanie zadawania pytań po upływie czasu
        _questionCount = 0; // Resetowanie licznika pytań po przerwie
        _timer?.cancel(); // Zatrzymanie timera
      }
    });
  }

  // Zatrzymywanie timera i usuwanie zasobów
  void dispose() {
    _openAI.close();
    _ttsHandler.dispose();
    conversation.clear();
    _timer?.cancel(); // Zatrzymanie timera
  }
}