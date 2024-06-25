import 'dart:ui';

import 'package:flutter_tts/flutter_tts.dart';

class TtsHandler {
  final FlutterTts _flutterTts = FlutterTts();
  List<dynamic> _polishVoices = [];

  VoidCallback? onSpeakingStart;
  VoidCallback? onSpeakingDone;

  TtsHandler() {
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("pl-PL");
  await _flutterTts.setSpeechRate(1.0);  // Slightly slower can sound more natural
  await _flutterTts.setVolume(1.0);
  await _flutterTts.setPitch(1.0);  // Adjust pitch for better clarity


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

    // Sprawdzenie dostępnych głosów
    List<dynamic> voices = await _flutterTts.getVoices;
    _polishVoices = voices.where((voice) => voice['locale'].toString().startsWith('pl-')).toList();

    // Ustawienie głosu Zosia jako domyślnego
    var zosiaVoice = _polishVoices.firstWhere((voice) => voice['name'] == 'Zosia', orElse: () => null);
    if (zosiaVoice != null) {
      await _flutterTts.setVoice(zosiaVoice);
      print("Ustawiono głos Zosia: $zosiaVoice");
    } else {
      print("Nie znaleziono głosu Zosia.");
    }

    _polishVoices.forEach((voice) {
      print("Głos dostępny: $voice");
    });
  }

  Future<void> speak(String message) async {
    if (message.isNotEmpty) {
      onSpeakingStart?.call(); // Możesz również przenieść to wywołanie w setStartHandler jeśli chcesz
      await _flutterTts.speak(message);
    }
  }

  void stop() async {
    await _flutterTts.stop();
    onSpeakingDone?.call(); // Możesz również przenieść to wywołanie w setCompletionHandler jeśli chcesz
  }
}
