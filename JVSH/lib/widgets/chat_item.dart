import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String text;
  final bool isMe;
  const ChatItem({
    super.key,
    required this.text,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    // Zmodyfikowane ułożenie, aby obie wiadomości były zawsze od dołu.
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMe) ProfileContainer(isMe: isMe),
            if (!isMe)
              const SizedBox(width: 40), // Odstęp miedzy ikoną a dymkiem
            Container(
              padding: const EdgeInsets.all(
                  20), // Zmniejszony padding dla lepszego dopasowania
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width *
                    0.75, // Zwiększony maksymalny rozmiar dla lepszego dopasowania
              ),
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: Radius.circular(isMe ? 15 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 15),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
            if (isMe)
              const SizedBox(
                  width: 40), // Zmniejszony rozmiar dla lepszego wyświetlania
            if (isMe) ProfileContainer(isMe: isMe),
          ],
        ),
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    super.key,
    required this.isMe,
  });

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 20, // Zmieniony rozmiar dla lepszego dopasowania
      height: 20, // Zmieniony rozmiar dla lepszego dopasowania
      decoration: BoxDecoration(
        color: isMe
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
