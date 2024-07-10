import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceHandler {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  Future<void> initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (error) => print("Speech recognition error: $error"),
      onStatus: (status) => print("Speech recognition status: $status"),
    );
  }

  Future<String> startListening() async {
    final completer = Completer<String>();

    if (_speechEnabled) {
      _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            completer.complete(result.recognizedWords);
          }
        },
        listenFor: Duration(seconds: 10),
        localeId: "pl_PL", // Ustawienie odpowiedniego języka
        onSoundLevelChange: (level) => print("Sound level: $level"),
        cancelOnError: true,
        partialResults: true,
      );
    } else {
      completer.completeError("Speech recognition not enabled");
    }

    return completer.future;
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  SpeechToText get speechToText => _speechToText;
  bool get isEnabled => _speechEnabled;
}
