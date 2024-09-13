import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    // Inicjalizacja zasobów graficznych
    _initializeGraphics();
  }

  void _initializeGraphics() {
    setState(() {
      _isControllerInitialized = true;
      _isStarTalkInitialized = true;
    });
  }

  @override
  void dispose() {
    ttsHandler.dispose();
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
            // Wyświetlanie StarTalk jako obraz
            Positioned(
              left: 330,
              top: 5,
              child: SizedBox(
                width: 450,
                height: 450,
                child: _isStarTalkInitialized
                    ? Image.asset('assets/new/StarTalkLogo.webp') // Wyświetlanie obrazu .webp
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
            // Wyświetlanie Robo_IDE jako obraz
            Positioned(
  top: 400,
  left: 200,
  child: SizedBox(
    width: 700,
    height: 700,
    child: _isControllerInitialized
        ? InteractiveViewer(
            minScale: 1.0, // Minimalna skala (domyślna)
            maxScale: 5.0, // Maksymalna skala
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: ClipRect(
                    child: Transform.translate(
                      offset: Offset(8, 14), // Dostosuj offset, aby przesunąć obraz w dół
                      child: Transform.scale(
                        scale: 1.70, // Dostosuj skalę, aby uzyskać efekt powiększenia
                        child: Stack(
                          children: [
                            Image.asset('assets/new/Robo_IDE.webp'),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: Offset(1, 3),
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(0, 94, 94, 94),
                                      Color.fromARGB(0, 160, 1, 192).withOpacity(0.3), // Zamień kolor na wybrany
                                    ],
                                    stops: [0.1, 1.5],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
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
