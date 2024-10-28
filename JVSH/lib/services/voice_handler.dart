import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceHandler {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  // Inicjalizacja rozpoznawania mowy
  Future<void> initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (error) => print("Speech recognition error: $error"),
      onStatus: (status) => print("Speech recognition status: $status"),
    );
    print("Speech recognition enabled: $_speechEnabled"); // Debug log potwierdzający inicjalizację
  }

  // Rozpoczęcie nasłuchiwania i przetwarzanie wyniku
  Future<String> startListening() async {
    print("Attempting to start listening..."); // Debug log
    final completer = Completer<String>();

    if (_speechEnabled) {
      print("Listening enabled. Starting to listen..."); // Debug log
      _speechToText.listen(
        onResult: (result) {
          print("Recognized words: ${result.recognizedWords}"); // Debug log z rozpoznanymi słowami
          if (result.finalResult) {
            completer.complete(result.recognizedWords);
          }
        },
        listenFor: Duration(seconds: 10),
        localeId: "pl_PL", // Ustawienie języka na polski
        onSoundLevelChange: (level) => print("Sound level: $level"), // Debug log z poziomem dźwięku
        cancelOnError: true,
        partialResults: true,
      );
    } else {
      print("Speech recognition not enabled."); // Debug log w przypadku braku inicjalizacji
      completer.completeError("Speech recognition not enabled");
    }

    return completer.future;
  }

  // Zatrzymanie nasłuchiwania
  Future<void> stopListening() async {
    print("Stopping listening..."); // Debug log
    await _speechToText.stop();
    print("Listening stopped."); // Potwierdzenie zakończenia nasłuchiwania
  }

  // Getter do sprawdzenia, czy rozpoznawanie mowy jest aktywne
  SpeechToText get speechToText => _speechToText;
  bool get isEnabled => _speechEnabled;
}
