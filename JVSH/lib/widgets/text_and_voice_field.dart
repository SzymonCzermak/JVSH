import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_model.dart';
import '../providers/chats_provider.dart';
import '../services/ai_handler.dart';
import '../services/voice_handler.dart';
import 'toggle_button.dart';

enum InputMode {
  text,
  voice,
}

class TextAndVoiceField extends ConsumerStatefulWidget {
  const TextAndVoiceField({super.key});

  @override
  ConsumerState<TextAndVoiceField> createState() => _TextAndVoiceFieldState();
}

class _TextAndVoiceFieldState extends ConsumerState<TextAndVoiceField> {
  InputMode _inputMode = InputMode.voice;
  final _messageController = TextEditingController();
  final AIHandler _openAI = AIHandler();
  final VoiceHandler voiceHandler = VoiceHandler();
  var _isReplying = false;
  var _isListening = false;

  @override
  void initState() {
    voiceHandler.initSpeech();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _openAI.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80),
            constraints: BoxConstraints(maxWidth: 0),
            child: Focus(
              autofocus: true,
              onKey: (FocusNode node, RawKeyEvent event) {
                if (event.logicalKey == LogicalKeyboardKey.numpad5) {
                  if (event is RawKeyDownEvent && !_isListening) {
                    // Zacznij nasłuchiwać przy wciśnięciu klawisza
                    sendVoiceMessage(startListening: true);
                    return KeyEventResult.handled;
                  } else if (event is RawKeyUpEvent && _isListening) {
                    // Zatrzymaj nasłuchiwać przy puszczeniu klawisza
                    sendVoiceMessage(startListening: false);
                    return KeyEventResult.handled;
                  }
                }
                return KeyEventResult.ignored;
              },
              child: Container(), // Placeholder for the child of Focus
            ),
          ),
        ),
        ToggleButton(
          isListening: _isListening,
          isReplying: _isReplying,
          inputMode: _inputMode,
          sendTextMessage: () {
            _sendMessage(); // Make sure this function does not rely on the text field
          },
          sendVoiceMessage: () {
            sendVoiceMessage(startListening: !_isListening);
          },
        ),
      ],
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      sendTextMessage(message);
      _messageController.clear();
    }
  }

  void setInputMode(InputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  void sendVoiceMessage({required bool startListening}) async {
  if (!voiceHandler.isEnabled) {
    print('Not supported');
    return;
  }

  if (startListening) {
    // Rozpocznij nasłuchiwanie
    setListeningState(true);
    final recognizedText = await voiceHandler.startListening(); // Nasłuchiwanie i rozpoznawanie tekstu
    if (recognizedText.isNotEmpty) {
      sendTextMessage(recognizedText); // Wyślij rozpoznany tekst
    }
  } else {
    // Zatrzymaj nasłuchiwanie
    await voiceHandler.stopListening();
    setListeningState(false);
  }
}




  void sendTextMessage(String message) async {
    setReplyingState(true);
    addToChatList(message, true, DateTime.now().toString());
    addToChatList('Myśle...', false, 'typing');
    setInputMode(InputMode.voice);
    final aiResponse = await _openAI.getResponse(message);
    removeTyping();
    addToChatList(aiResponse, false, DateTime.now().toString());
    setReplyingState(false);
  }

  void setReplyingState(bool isReplying) {
    setState(() {
      _isReplying = isReplying;
    });
  }

  void setListeningState(bool isListening) {
    setState(() {
      _isListening = isListening;
    });
  }

  void removeTyping() {
    final chats = ref.read(chatsProvider.notifier);
    chats.removeTyping();
  }

  void addToChatList(String message, bool isMe, String id) {
    final chats = ref.read(chatsProvider.notifier);
    chats.add(ChatModel(
      id: id,
      message: message,
      isMe: isMe,
    ));
  }
}
