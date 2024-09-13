import 'dart:ui';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:js' as js;

class TtsHandler {
  final FlutterTts _flutterTts = FlutterTts();
  List<dynamic> _polishVoices = [];

  VoidCallback? onSpeakingStart;
  VoidCallback? onSpeakingDone;

  TtsHandler() {
    _initTts();
  }

  void _initTts() async {
    try {
      await _flutterTts.setLanguage("pl-PL");
      await _flutterTts.setSpeechRate(1.0); // Slightly slower can sound more natural
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(0.7); // Adjust pitch for better clarity

      _flutterTts.setStartHandler(() {
        onSpeakingStart?.call();
        print("Mowa rozpoczęta");
      });

      _flutterTts.setCompletionHandler(() {
        onSpeakingDone?.call();
        print("Mowa zakończona");
      });

      _flutterTts.setErrorHandler((message) {
        print("Wystąpił błąd w TTS: $message");
      });

      List<dynamic> voices = await _flutterTts.getVoices;
      _polishVoices = voices
          .where((voice) => voice['locale'].toString().startsWith('pl-'))
          .toList();

      print("Dostępne polskie głosy:");
      for (var voice in _polishVoices) {
        print(voice);
      }

      var paulinaVoice = _polishVoices.firstWhere(
        (voice) => voice['name'] == 'Microsoft Paulina - Polish (Poland)',
        orElse: () => null,
      );

      if (paulinaVoice != null) {
        await _flutterTts.setVoice(
            {"name": paulinaVoice['name'], "locale": paulinaVoice['locale']});
        print("Ustawiono głos Paulina: $paulinaVoice");
      } else {
        print("Nie znaleziono głosu Paulina. Używam Web Speech API.");
      }
    } catch (e) {
      print("Wystąpił wyjątek podczas inicjalizacji TTS: $e");
    }
  }

  Future<void> speak(String message) async {
    if (message.isNotEmpty) {
      if (_polishVoices.any(
          (voice) => voice['name'] == 'Microsoft Paulina - Polish (Poland)')) {
        print("Używam głosu Paulina do mowy.");
        await _flutterTts.speak(message);
      } else {
        print("Używam Web Speech API do mowy.");
        js.context.callMethod('speakWithWebSpeechAPI', [message]);
      }
    }
  }

  void dispose() {
    _flutterTts.stop();
  }
}
