import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
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
  late Timer _refreshTimer;
  late Timer _countdownTimer;
  int remainingTime = 60; // Czas do odświeżenia w sekundach

  @override
  void initState() {
    super.initState();

    // Timer do odświeżania aplikacji co minutę
    _refreshTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _reloadPage();
        remainingTime = 60; // Resetowanie odliczania
      });
    });

    // Timer do aktualizacji odliczania co sekundę
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        }
      });
    });

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

    _controller = VideoPlayerController.asset('assets/new/Robo_IDE.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  void _reloadPage() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (a, b, c) => ChatScreen(),
        transitionDuration: Duration(seconds: 0),
      ),
    );
  }

  @override
  void dispose() {
    _refreshTimer
        .cancel(); // Anulowanie Timer w celu uniknięcia wycieków pamięci
    _countdownTimer.cancel(); // Anulowanie Timer odliczania
    ttsHandler.dispose();
    _controller.dispose();
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
              left: 400,
              top: 50,
              child: SizedBox(
                width: 300,
                height: 300,
                child: Image.asset('assets/new/StarTalkLogoTrans.gif'),
              ),
            ),
            Positioned(
              left: 250,
              bottom: 450,
              child: SizedBox(
                width: 650,
                height: 650,
                child: Lottie.asset('assets/talking.json'),
              ),
            ),
            Positioned(
              top: 300,
              left: 130,
              child: SizedBox(
                width: 800,
                height: 800,
                child: _controller.value.isInitialized
                    ? VideoPlayer(_controller)
                    : Container(), // Pusty kontener, jeśli wideo nie jest zainicjalizowane
              ),
            ),
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
                    SizedBox(height: 10),
                    Text(
                      'Strona odswiezy sie za: $remainingTime sekund',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
