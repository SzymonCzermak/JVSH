import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedSpeakingIndicator extends StatefulWidget {
  final bool isSpeaking;

  const AnimatedSpeakingIndicator({Key? key, required this.isSpeaking})
      : super(key: key);

  @override
  State<AnimatedSpeakingIndicator> createState() =>
      _AnimatedSpeakingIndicatorState();
}

class _AnimatedSpeakingIndicatorState extends State<AnimatedSpeakingIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _sizeAnimation;
  late AnimationController
      _lottieAnimationController; // Dodany kontroler dla Lottie

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 10),
    )..repeat(reverse: true);
    _sizeAnimation = Tween<double>(begin: 24.0, end: 32.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );

    // Inicjalizacja kontrolera animacji Lottie
    _lottieAnimationController = AnimationController(
      vsync: this,
    );

    if (!widget.isSpeaking) {
      _animationController!.stop();
      _lottieAnimationController
          .stop(); // Zatrzymanie animacji Lottie, gdy nie mówi
    } else {
      _lottieAnimationController.repeat(); // Pętla animacji Lottie, gdy mówi
    }
  }

  @override
  void didUpdateWidget(AnimatedSpeakingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpeaking) {
      _animationController!.repeat(reverse: true);
      _lottieAnimationController.repeat(); // Kontynuacja animacji Lottie
    } else {
      _animationController!.stop();
      _lottieAnimationController.stop(); // Zatrzymanie animacji Lottie
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _lottieAnimationController.dispose(); // Usunięcie kontrolera Lottie
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: Lottie.asset(
          "assets/animations/talk.json",
          repeat: true,
          width: 250,
          height: 250,
        ))
      ],
    );
  }
}
