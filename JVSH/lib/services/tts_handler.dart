import 'package:flutter_tts/flutter_tts.dart';

class TtsHandler {
  final FlutterTts _flutterTts = FlutterTts();

  TtsHandler() {
    _flutterTts.setLanguage("pl-PL");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(5.0);
    _flutterTts.setPitch(5.0);
  }

  Future speak(String message) async {
    if (message.isNotEmpty) {
      await _flutterTts.speak(message);
    }
  }

  void stop() {
    _flutterTts.stop();
  }
}
