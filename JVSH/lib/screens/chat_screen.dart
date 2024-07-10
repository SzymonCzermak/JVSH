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
    ttsHandler.dispose(); // Change to dispose to ensure proper cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/new/TalkBackground.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 400, // Centruje poziomo animację
              top:
                  50, // Ustawia animację na określonej wysokości (-1.3 * wysokość animacji)
              child: SizedBox(
                width: 300, // Szerokość animacji
                height: 300, // Wysokość animacji
                child: Image.asset(
                    'assets/new/StarTalkLogoTrans.gif'), // Ta animacja będzie teraz mniejsza.
              ),
            ),
            Positioned(
              left: 250, // Centruje poziomo animację
              bottom:
                  450, // Ustawia animację na określonej wysokości (-1.3 * wysokość animacji)
              child: SizedBox(
                width: 650, // Szerokość animacji
                height: 650, // Wysokość animacji
                child: Lottie.asset(
                    'assets/talking.json'), // Ta animacja będzie teraz mniejsza.
              ),
            ),
            // Positioned(
            //   top: 100,
            //   left: 0,
            //   right: 0,
            //   child: Lottie.asset('assets/textbar.json'),
            // ),
            // Positioned(
            //   left: 215, // Centruje poziomo animację
            //   top:
            //       1355, // Ustawia animację na określonej wysokości (-1.3 * wysokość animacji)
            //   child: SizedBox(
            //     width: 650, // Szerokość animacji
            //     height: 650, // Wysokość animacji
            //     child: Lottie.asset(
            //         'assets/answer.json'), // Ta animacja będzie teraz mniejsza.
            //   ),
            // ),
            Consumer(
              builder: (context, ref, child) {
                final chats = ref.watch(chatsProvider).reversed.toList();
                if (chats.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 100.0), // Adjust the padding as needed
                    child: ListView.builder(
                      reverse: true,
                      itemCount: 1, // Show only one item
                      itemBuilder: (context, index) => Column(
                        children: [
                          ChatItem(
                            text: chats[0]
                                .message, // Always show the latest message
                            isMe: chats[0].isMe,
                          ),
                          SizedBox(
                              height: 250.0), // Adjust the height as needed
                        ],
                      ),
                    ),
                  );
                } else {
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
