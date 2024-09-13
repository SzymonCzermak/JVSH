import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String text;
  final String? question; // Pytanie, które może być null, jeśli go nie ma
  final bool isMe;
  const ChatItem({
    Key? key,
    required this.text,
    this.question, // Pytanie jest opcjonalne
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Widget odpowiedzi z ulepszonym stylem
    final answerWidget = Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(0, 160, 1, 192).withOpacity(0.3),
              Color.fromARGB(0, 105, 0, 126).withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [  
            // Dodanie cienia do kontenera
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 35,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 4.0,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );

    // Widget pytania (jeśli istnieje)
    final questionWidget = question != null && !isMe
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(99, 88, 0, 129),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                // Dodanie cienia do kontenera pytania
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              question!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2.0,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          )
        : SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!isMe) answerWidget,
        questionWidget,
        SizedBox(height: 50),
      ],
    );
  }
}
