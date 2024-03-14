import 'dart:ui';

import 'package:flutter_tts/flutter_tts.dart';

class TtsHandler {
  final FlutterTts _flutterTts = FlutterTts();

  VoidCallback? onSpeakingStart;
  VoidCallback? onSpeakingDone;

  TtsHandler() {
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("pl-PL-Wavenet-B");
    await _flutterTts
        .setSpeechRate(1.0); // Zmieniono na bardziej naturalne tempo
    await _flutterTts.setVolume(1.0); // Ustawiono maksymalną zalecaną głośność
    await _flutterTts
        .setPitch(0.5); // Ustawiono bardziej naturalną wysokość tonu

    // Pobierz dostępne głosy i wybierz męski głos
    // var voices = await _flutterTts.getVoices;
    // var maleVoice = voices.firstWhere(
    //     (voice) =>
    //         voice["gender"] == "male" && voice["locale"].startsWith("pl-"),
    //     orElse: () => null);

    // if (maleVoice != null) {
    //   await _flutterTts.setVoice(maleVoice);
    // } else {
    //   print(
    //       "Nie znaleziono męskiego głosu dla języka polskiego, używam domyślnego.");
    // }

    // Dodanie obsługi callbacków
    _flutterTts.setStartHandler(() {
      onSpeakingStart?.call();
    });

    _flutterTts.setCompletionHandler(() {
      onSpeakingDone?.call();
    });

    _flutterTts.setErrorHandler((message) {
      print("Wystąpił błąd w TTS: $message");
    });
  }

  Future<void> speak(String message) async {
    if (message.isNotEmpty) {
      onSpeakingStart
          ?.call(); // Możesz również przenieść to wywołanie w setStartHandler jeśli chcesz
      await _flutterTts.speak(message);
    }
  }

  void stop() async {
    await _flutterTts.stop();
    onSpeakingDone
        ?.call(); // Możesz również przenieść to wywołanie w setCompletionHandler jeśli chcesz
  }
}
