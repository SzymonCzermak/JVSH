import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../providers/chats_provider.dart';
import '../widgets/chat_item.dart';
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
            image: AssetImage("assets/FINAL.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -1.3),
              child: SizedBox(
                  width: 650, // Szerokość animacji
                  height: 650, // Wysokość animacji
                    child: Image.asset('assets/Robotka_trans.gif'), // Ta animacja będzie teraz mniejsza.
                    ),
              ),

            Align(
              alignment: Alignment(0, 0.15),
              child: Lottie.asset('assets/textbar.json'), // Ta animacja będzie na górze

            ),
                
            Align(
              alignment: Alignment(0, 0.92),
              child: Lottie.asset('assets/answer.json'), // Ta animacja będzie na górze

            ),
            

            // List of messages
            Consumer(
  builder: (context, ref, child) {
    final chats = ref.watch(chatsProvider).reversed.toList();
    if (chats.isNotEmpty) {
      // Make sure there is at least one message
      return Padding(
        padding: const EdgeInsets.only(bottom: 100.0), // Adjust the padding as needed
        child: ListView.builder(
          reverse: true,
          itemCount: 1, // Show only one item
          itemBuilder: (context, index) => Column(
            children: [
              ChatItem(
                text: chats[0].message, // Always show the latest message
                isMe: chats[0].isMe,
              ),
              SizedBox(height: 250.0), // Adjust the height as needed
              // You can add more widgets here if needed
            ],
          ),
        ),
      );
    } else {
      // If there are no messages, you could return an empty container or some placeholder
      return Container(); // or any other widget to indicate the list is empty
    }
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