import 'dart:ui';
import 'dart:js' as js;

class TtsHandler {
  VoidCallback? onSpeakingStart;
  VoidCallback? onSpeakingDone;

  TtsHandler() {
    _initTts();
  }

  void _initTts() {
    // Ponieważ używamy tylko Web Speech API, nie musimy inicjalizować FlutterTts
    print("Zainicjowano handler Web Speech API.");
  }

  Future<void> speak(String message) async {
    if (message.isNotEmpty) {
      print("Używam Web Speech API do mowy.");
      js.context.callMethod('speakWithWebSpeechAPI', [message]);
    }
  }

  void dispose() {
    // Ponieważ nie używamy FlutterTts, nie musimy nic zwalniać
    print("Zwalnianie zasobów nie jest wymagane.");
  }
}
