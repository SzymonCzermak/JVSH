import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
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
          isSpeaking = true;
        });
      }
      ..onSpeakingDone = () {
        setState(() {
          isSpeaking = false;
        });
      };
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
            image: AssetImage("assets/ALVF.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -1.42),
              child: SizedBox(
                  width: 650, // Szerokość animacji
                  height: 650, // Wysokość animacji
                    child: Lottie.asset('assets/Alien.json'), // Ta animacja będzie teraz mniejsza.
  ),
),
            Align(
              alignment: Alignment(0, 0),
              child: Lottie.asset('assets/answer.json'), // Ta animacja będzie na górze

            ),
            

            // List of messages
            Consumer(
              builder: (context, ref, child) {
                final chats = ref.watch(chatsProvider).reversed.toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: chats.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      ChatItem(
                        text: chats[index].message,
                        isMe: chats[index].isMe,
                      ),
                      SizedBox(height: 250),
                    ],
                  ),
                );
              },
            ),

            Align(
              alignment:
                  Alignment.center, // Position at the center of the screen
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height *
                      0.753, // Adjust the value to bring the field up
                ),
                child: TextAndVoiceField(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}