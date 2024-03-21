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
          color: isMe
              ? Theme.of(context).colorScheme.primary
              : Color(0x0),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Wrap(
          children: [
            Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.bold, // Pogrubiona czcionka
                fontSize: 18, // Większa czcionka
              ),
            ),
          ],
        ),
      ),
    );

    // Logika dla wyświetlania pytania, jeśli istnieje
    final questionWidget = question != null && !isMe
        ? Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 123, 255), // Unikalny kolor dla pytania
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
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!isMe) 
        answerWidget,
        questionWidget,
        SizedBox(height: 50), // Zwiększony odstęp między pytaniem a odpowiedzią
      ],
    );
  }
}
