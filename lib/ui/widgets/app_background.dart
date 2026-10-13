import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFCFE3EA),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            color: const Color.fromRGBO(255, 255, 255, 0.55),
            colorBlendMode: BlendMode.modulate,
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
