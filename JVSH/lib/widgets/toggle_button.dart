import 'package:flutter/material.dart';
import 'text_and_voice_field.dart';

class ToggleButton extends StatefulWidget {
  final VoidCallback _sendTextMessage;
  final VoidCallback _sendVoiceMessage;
  final InputMode _inputMode;
  final bool _isReplying;
  final bool _isListening;

  const ToggleButton({
    super.key,
    required InputMode inputMode,
    required VoidCallback sendTextMessage,
    required VoidCallback sendVoiceMessage,
    required bool isReplying,
    required bool isListening,
  })  : _inputMode = inputMode,
        _sendTextMessage = sendTextMessage,
        _sendVoiceMessage = sendVoiceMessage,
        _isReplying = isReplying,
        _isListening = isListening;

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(
            10), // Zmniejszony padding, aby powiększyć przycisk
        minimumSize: Size(
            60, 60), // Ustaw minimalny rozmiar przycisku, aby go powiększyć
      ),
      onPressed: widget._isReplying
          ? null
          : widget._inputMode == InputMode.text
              ? widget._sendTextMessage
              : widget._sendVoiceMessage,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Color.fromARGB(169, 60, 1, 116),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
          border: Border.all(
            color: Color.fromARGB(
                255, 202, 54, 21), // Możesz zmienić kolor ramki tutaj
            width: 4,
          ),
        ),
        child: Text(
          widget._inputMode == InputMode.text
              ? 'Wyślij wiadomość'
              : widget._isListening
                  ? 'Mów a jak skończysz puść przycisk!'
                  : 'Przyztrzymaj przycisk i zadaj mi pytanie!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36,
            color: Colors.black,
            fontFamily: 'BungeeSpice', // Ustawienie czcionki
          ),
        ),
      ),
    );
  }
}
