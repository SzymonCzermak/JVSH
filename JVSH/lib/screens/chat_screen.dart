import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../providers/chats_provider.dart';
import '../widgets/chat_item.dart';
import '../services/tts_handler.dart';
import '../widgets/text_and_voice_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isSpeaking = false;
  late final TtsHandler ttsHandler;
  late VideoPlayerController _controller;
  late VideoPlayerController _starTalkController;
  bool _isControllerInitialized = false;
  bool _isStarTalkInitialized = false;

  @override
  void initState() {
    super.initState();

    // Inicjalizacja głosowego TTS
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

    // Inicjalizacja wideo dla Robo_IDE.mp4
    _initializeVideoControllers();
  }

  void _initializeVideoControllers() {
    // Kontroler dla Robo_IDE
    _controller = VideoPlayerController.asset('assets/new/Robo_IDE.mp4')
      ..initialize().then((_) {
        setState(() {
          _isControllerInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play().catchError((error) {
          print("Błąd odtwarzania wideo Robo_IDE: $error");
        });
      }).catchError((error) {
        print("Błąd ładowania wideo Robo_IDE: $error");
      });

    // Kontroler dla StarTalkLogo
    _starTalkController = VideoPlayerController.asset('assets/new/StarTalkLogo.mp4')
      ..initialize().then((_) {
        setState(() {
          _isStarTalkInitialized = true;
        });
        _starTalkController.setLooping(true);
        _starTalkController.play().catchError((error) {
          print("Błąd odtwarzania wideo StarTalk: $error");
        });
      }).catchError((error) {
        print("Błąd ładowania wideo StarTalkLogo: $error");
      });
  }

  @override
  void dispose() {
    ttsHandler.dispose();
    _controller.dispose();
    _starTalkController.dispose();
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
            // Wyświetlanie StarTalk jako wideo
            Positioned(
              left: 400,
              top: 50,
              child: SizedBox(
                width: 300,
                height: 300,
                child: _isStarTalkInitialized
                    ? VideoPlayer(_starTalkController)
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
            // Wyświetlanie Robo_IDE jako wideo
            Positioned(
              top: 300,
              left: 130,
              child: SizedBox(
                width: 800,
                height: 800,
                child: _isControllerInitialized
                    ? VideoPlayer(_controller)
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
            // Wyświetlanie czatu
            Consumer(
              builder: (context, ref, child) {
                final chats = ref.watch(chatsProvider).reversed.toList();
                if (chats.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: 1,
                      itemBuilder: (context, index) => Column(
                        children: [
                          ChatItem(
                            text: chats[0].message,
                            isMe: chats[0].isMe,
                          ),
                          SizedBox(height: 250.0),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.753,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextAndVoiceField(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
