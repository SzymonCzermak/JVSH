import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chats_provider.dart';
import '../widgets/chat_item.dart';
import '../services/tts_handler.dart';
import '../widgets/text_and_voice_field.dart';
import '../services/ai_handler.dart'; // Import klasy AIHandler

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final AIHandler _aiHandler; // Instancja AIHandler

  @override
  void initState() {
    super.initState();
    _aiHandler = AIHandler();
  }

  @override
  void dispose() {
    _aiHandler.dispose();
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
            // Animacja robotki StarTalk
            Positioned(
              left: 330,
              top: 5,
              child: SizedBox(
                width: 450,
                height: 450,
                child: Image.asset('assets/new/StarTalkLogo.webp'),
              ),
            ),
            // Animacja Robo_IDE
            Positioned(
              top: 400,
              left: 200,
              child: SizedBox(
                width: 700,
                height: 700,
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 5.0,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: ClipRect(
                          child: Transform.translate(
                            offset: Offset(8, 14),
                            child: Transform.scale(
                              scale: 1.70,
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
                                            Color.fromARGB(0, 160, 1, 192).withOpacity(0.3),
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
                ),
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
            // Pozycjonowanie licznika czasu
            Positioned(
  left: 10,
  bottom: 20, // Ustawienie odpowiedniej pozycji licznika
  child: _aiHandler.isWaiting
      ? Container(
          padding: EdgeInsets.all(8), // Dodanie paddingu
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5), // Tło dla tekstu z półprzezroczystością
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Możesz zadać kolejne pytanie za: ${_aiHandler.remainingSeconds} s',
            style: TextStyle(
              fontSize: 300, // Zwiększenie rozmiaru czcionki
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow( // Dodanie cienia do tekstu dla lepszej widoczności
                  offset: Offset(2, 2),
                  blurRadius: 3,
                  color: Colors.black.withOpacity(0.8),
                ),
              ],
            ),
          ),
        )
      : Container(),
),

            // Pole do wpisywania tekstu
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.753,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _aiHandler.isWaiting
                        ? Container() // Jeśli licznik aktywny, nie wyświetla pola
                        : TextAndVoiceField(), // Wyświetlanie pola do zadawania pytań, gdy licznik zakończony
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
