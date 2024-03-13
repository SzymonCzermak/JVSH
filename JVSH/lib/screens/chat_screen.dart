import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chats_provider.dart';
import '../widgets/chat_item.dart';
import '../widgets/animated_speaking_indicator.dart'; // Upewnij się, że importujesz ten plik
import '../services/tts_handler.dart'; // Upewnij się, że importujesz ten plik
import '../widgets/text_and_voice_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isSpeaking = false;

  late final TtsHandler ttsHandler;

  @override
  void initState() {
    super.initState();
    ttsHandler = TtsHandler()
      ..onSpeakingStart = () {
        setState(() {
          isSpeaking = true; // Rozpoczęcie animacji po inicjalizacji
        });
      }
      ..onSpeakingDone = () {
        setState(() {
          isSpeaking = false;
        });
      };

    // Tylko do testów - usunąć później
    setState(() {
      isSpeaking = true;
    });
  }

  @override
  void dispose() {
    ttsHandler.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final chats = ref.watch(chatsProvider).reversed.toList();
                  return ListView.builder(
                    reverse: true,
                    itemCount: chats.length,
                    itemBuilder: (context, index) => ChatItem(
                      text: chats[index].message,
                      isMe: chats[index].isMe,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: TextAndVoiceField(),
            ),
            if (isSpeaking) const AnimatedSpeakingIndicator(isSpeaking: true),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
