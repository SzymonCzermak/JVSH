import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String text;
  final String? question; // Pytanie, które może być null, jeśli go nie ma
  final bool isMe;
  const ChatItem({
    super.key,
    required this.text,
    this.question, // Pytanie jest opcjonalne
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    // Widget odpowiedzi
    final answerWidget = Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        decoration: BoxDecoration(
          color:
              isMe ? Theme.of(context).colorScheme.primary : Color(0x004F46CA),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Wrap(
          alignment:
              WrapAlignment.center, // Dodane wyrównanie dzieci Wrap do środka
          children: [
            Text(
              text,
              textAlign: TextAlign.center, // Dodane wyśrodkowanie tekstu
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.bold, // Pogrubiona czcionka
                fontSize: 18, // Większa czcionka
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.1, 1.1), // Przesunięcie cienia
                    blurRadius: 3.0, // Rozmycie cienia
                    color: Color.fromARGB(
                        255, 0, 0, 0), // Kolor cienia, tutaj czarny
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    // Logika dla wyświetlania pytania, jeśli istnieje
    final questionWidget = question != null && !isMe
        ? Container(
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                  255, 0, 123, 255), // Unikalny kolor dla pytania
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              question!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.bold, // Pogrubiona czcionka
                fontSize: 18, // Większa czcionka
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
