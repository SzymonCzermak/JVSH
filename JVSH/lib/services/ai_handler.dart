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
  final List<Map<String, String>> conversation =
      []; // Lista do przechowywania historii rozmowy

  Future<String> getResponse(String message) async {
    try {
      String context =
          "Udawaj że jesteś kosmitą, jesteś asystentem glosowym który odpowiada na pytania związane z filmem, teatrem, pisarstwem i muzyką.Odpowiadaj w 3 zdaniach maksymalnie.";
      String fullMessage =
          context + message; // Łączymy kontekst z wiadomością użytkownika

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
          _ttsHandler
              .speak(textResponse); // Wywołanie TTS do odczytania odpowiedzi
          return textResponse;
        } else {
          String unrelatedResponse =
              "Przykro mi, ale to pytanie wykracza poza moje kompetencje. Skupiam się tylko na filmach, aktorach, teatrze i pisarstwie.";
          _ttsHandler.speak(unrelatedResponse);
          return unrelatedResponse;
        }
      }

      return 'Something went wrong';
    } catch (e) {
      return 'Powtórz!';
    }
  }

  bool isResponseRelated(String response) {
    // Tu możesz dodać bardziej zaawansowaną logikę sprawdzającą słowa kluczowe itp.
    // Poniżej jest bardzo prosty przykład
    List<String> keywords =  ['pirotechnik filmowy', 'kaskader motocyklowy', 'kaskader wysokościowy', 'koordynator efektów pirotechnicznych', 'specjalista od efektów specjalnych', 'specjalista ds. bezpieczeństwa na planie', 'dubler akcji', 'trener walk scenicznych', 'koordynator scen walki', 'specjalista ds. efektów mechanicznych', 'operator kamery akcji', 'projektant kostiumów akcji', 'kreator makijażu specjalnego', 'charakteryzator efektów specjalnych', 'specjalista ds. sztucznej krwi', 'konstruktor rekwizytów specjalnych', 'rzeźbiarz rekwizytów', 'modelarz rekwizytów', 'technik CGI efektów specjalnych', 'operator dronów do scen akcji', 'specjalista ds. imitacji materiałów', 'szkło cukrowe', 'imitacja ognia', 'sztuczna krew', 'fałszywe blizny', 'sztuczne tatuaże', 'imitacja deszczu', 'imitacja śniegu', 'imitacja wiatru', 'fałszywe monety', 'fałszywe dokumenty', 'imitacja broni', 'sztuczna roślinność', 'fałszywe jedzenie', 'imitacja zwłok', 'sztuczna woda', 'fałszywa broń palna', 'fałszywe artefakty', 'sztuczne zwierzęta', 'imitacja skał', 'fałszywe diamenty', 'sztuczna mgła', 'fałszywy dym', 'sztuczne ognie', 'imitacja lustra', 'fałszywe ślady', 'sztuczne ślady krwi', 'fałszywe papiery wartościowe', 'sztuczne eksplozje', 'fałszywe pancerze', 'imitacja rany', 'sztuczne blizny', 'fałszywe skarby', 'imitacja złota', 'sztuczne perły', 'fałszywe skóry zwierzęce', 'sztuczne futra', 'imitacja marmuru', 'fałszywe kamienie szlachetne', 'sztuczne meteoryty', 'fałszywe fosyli', 'imitacja rdzy', 'sztuczna rdza', 'fałszywy kurz', 'imitacja brudu', 'sztuczny pot', 'fałszywy śnieg', 'imitacja lodu', 'sztuczny lód', 'fałszywe płomienie', 'sztuczne dymy', 'imitacja pożaru', 'sztuczne pożary', 'fałszywa krwawa mgła', 'imitacja zabrudzeń', 'sztuczne zabrudzenia','projekt scenografii', 'makietowanie', 'tekstury', 'palette kolorów', 'przestrzeń sceniczna', 'model 3D scenografii', 'realizacja scenografii', 'elementy ruchome scenografii', 'tło malarskie', 'rekwizyty sceniczne', 'meble sceniczne', 'światła sceniczne', 'elementy multimedialne', 'projekcje wideo', 'konstrukcje sceniczne', 'kostiumy epokowe', 'maski', 'płaszczyzny sceniczne', 'elementy naturalne (roślinność, woda)', 'efekty specjalne scenografii', 'dekoracje podłogowe', 'transpozycje sceniczne', 'zaciemnienia', 'kulisy', 'elementy wiszące', 'tapety sceniczne', 'okna sceniczne', 'drzwi sceniczne', 'podesty', 'schody sceniczne', 'pomosty', 'mosty sceniczne', 'ścianki działowe', 'płótna sceniczne', 'zasłony teatralne', 'ekrany projekcyjne', 'wagony sceniczne', 'symulacje architektoniczne', 'symulacje krajobrazu', 'elementy interaktywne', 'instalacje artystyczne', 'elementy modułowe scenografii', 'rekwizyty techniczne', 'tekstylia sceniczne', 'rekwizyty użytkowe', 'mobilne systemy scenograficzne', 'rekwizyty do akcji specjalnych', 'akcesoria kostiumowe', 'elementy oświetleniowe', 'efekty dymne i mgłowe', 'efekty lustrzane', 'rekwizyty historyczne', 'elementy futurystyczne', 'rekwizyty fantastyczne', 'materiały eksploatacyjne scenografii', 'symulacje materiałów (drewno, metal)', 'efekty wodne', 'elementy pirotechniczne', 'akcesoria do efektów specjalnych', 'techniki malarskie scenografii', 'środki przekazu wizualnego', 'imitacje tekstur', 'motywy symboliczne', 'motywy narracyjne', 'adaptacje przestrzenne', 'projekty adaptacyjne', 'sztuka uliczna', 'instalacje przestrzenne', 'koncepcje przestrzenne', 'sztuka performance', 'projekty interdyscyplinarne', 'sztuka interaktywna', 'dekoracje tematyczne', 'rekwizyty specjalistyczne', 'projekty unikatowe', 'scenografia cyfrowa', 'virtual set design', 'augmented reality scenography', 'scenografia eventowa', 'projekcje mappingowe', 'scenografia filmowa', 'scenografia telewizyjna', 'scenografia teatralna', 'scenografia operowa', 'scenografia baletowa', 'scenografia dla dzieci', 'scenografia muzealna', 'scenografia wystawiennicza', 'scenografia reklamowa', 'dekoracje świąteczne', 'aranżacje wnętrz scenicznych', 'scenografia koncertowa', 'scenografia festiwalowa', 'design narracyjny', 'scenografia edukacyjna','film', 'aktor', 'teatr', 'pisarz', 'reżyser', 'scenariusz', 'broń butaforska', 'rekwizyt', 'scenografia', 'kostium', 'montaż', 'efekty specjalne', 'casting', 'światło', 'dźwięk', 'muzyka', 'postprodukcja', 'kadr', 'plan zdjęciowy', 'producent', 'operator kamery', 'asystent reżysera', 'scenograf', 'kostiumograf', 'charakteryzator', 'oświetleniowiec', 'dźwiękowiec', 'kompozytor', 'montażysta', 'kaskader', 'statysta', 'fotograf planu', 'projektant produkcji', 'grafik komputerowy', 'animator', 'efekty wizualne', 'colorista', 'scenarzysta', 'dialogista', 'sufler', 'kierownik produkcji', 'koordynator kaskaderów', 'reżyser castingu', 'kierownik planu', 'kierownik postprodukcji', 'skryptowiec', 'asystent kamery', 'mikser dźwięku', 'technik efektów specjalnych', 'projektant efektów specjalnych', 'operator steadicam', 'operator drona', 'logistyk produkcji', 'specjalista ds. rekwizytów', 'konsultant historyczny', 'konsultant naukowy', 'choreograf', 'trener aktorski', 'trener dialogów', 'reżyser drugiej ekipy', 'asystent scenarzysty', 'operator wideo', 'technik sceny', 'pracownik catering', 'asystent kostiumografa', 'prawnik ds. praw autorskich', 'doradca artystyczny', 'lektor', 'dubler', 'specjalista ds. lokalizacji', 'kierownik transportu', 'redaktor muzyki', 'dokumentalista', 'archiwista materiałów filmowych', 'inspicjent', 'krytyk filmowy', 'agent aktorski', 'dystrybutor filmowy', 'kurier filmowy', 'konsultant ds. dialogów', 'projektant tytułów', 'edytor dźwięku', 'specjalista ds. marketingu filmowego', 'konsultant ds. scenariusza', 'asystent reżysera drugiej ekipy', 'asystent ds. efektów wizualnych', 'kierownik sceny', 'koordynator postprodukcji dźwięku'];





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
    conversation
        .clear(); // Opcjonalnie czyścimy historię rozmowy przy zamykaniu
  }
}
