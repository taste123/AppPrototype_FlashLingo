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
          Opacity(
            opacity: 0.55,
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
