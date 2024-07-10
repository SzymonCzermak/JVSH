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
    await _flutterTts
        .setSpeechRate(1.0); // Slightly slower can sound more natural
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0); // Adjust pitch for better clarity

    _flutterTts.setStartHandler(() {
      onSpeakingStart?.call();
    });

    _flutterTts.setCompletionHandler(() {
      onSpeakingDone?.call();
    });

    _flutterTts.setErrorHandler((message) {
      print("Wystąpił błąd w TTS: $message");
    });

    List<dynamic> voices = await _flutterTts.getVoices;
    _polishVoices = voices
        .where((voice) => voice['locale'].toString().startsWith('pl-'))
        .toList();

    var zosiaVoice = _polishVoices
        .firstWhere((voice) => voice['name'] == 'Zosia', orElse: () => null);
    if (zosiaVoice != null) {
      await _flutterTts.setVoice(zosiaVoice);
      print("Ustawiono głos Zosia: $zosiaVoice");
    } else {
      // If Zosia is not found, try to find another female voice
      var femaleVoice = _polishVoices.firstWhere(
          (voice) =>
              voice['name'].toString().contains('fem') ||
              voice['gender'] == 'female',
          orElse: () => null);
      if (femaleVoice != null) {
        await _flutterTts.setVoice(femaleVoice);
        print("Ustawiono żeński głos: $femaleVoice");
      } else {
        print("Nie znaleziono żeńskiego głosu.");
      }
    }

    _polishVoices.forEach((voice) {
      print("Głos dostępny: $voice");
    });
  }

  Future<void> speak(String message) async {
    if (message.isNotEmpty) {
      onSpeakingStart?.call();
      await _flutterTts.speak(message);
    }
  }

  void dispose() {
    _flutterTts.stop();
    onSpeakingDone?.call();
  }
}
