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
        margin: const EdgeInsets.only(left: 60, right: 60, top: 25, bottom: 25),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.4,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.primary
              : const Color.fromARGB(255, 196, 35, 35),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Wrap(
          children: [
            Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );

    // Logika dla wyświetlania pytania, jeśli istnieje
    final questionWidget = question != null && !isMe
        ? Container(
            margin:
                const EdgeInsets.only(left: 40, right: 50, top: 50, bottom: 50),
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
              ),
            ),
          )
        : SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!isMe) questionWidget,
        answerWidget, // Najpierw wyświetl pytanie, jeśli wiadomość nie jest od nas // Następnie wyświetl odpowiedź
      ],
    );
  }
}
