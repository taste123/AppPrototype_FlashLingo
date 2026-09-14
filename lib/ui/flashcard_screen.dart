import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learn/data/content.dart';
import 'package:learn/data/models.dart';
import 'package:learn/data/progress_manager.dart';
import 'package:learn/ui/quiz_screen.dart';
import 'package:learn/ui/widgets/app_background.dart';
import 'package:learn/ui/widgets/buttons.dart';

class FlashcardScreen extends StatefulWidget {
  final Category category;
  final ProgressManager progressManager;

  const FlashcardScreen({
    super.key,
    required this.category,
    required this.progressManager,
  });

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  late List<VocabItem> _vocabList;
  int _currentIndex = 0;
  bool _isFlipped = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  Color get _catColor =>
      Color(int.parse(widget.category.colorHex.replaceFirst('#', '0xFF')));

  @override
  void initState() {
    super.initState();
    _vocabList =
        vocabularyData[widget.category.id] ?? vocabularyData['default']!;
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_flipController.isAnimating) return;
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    _isFlipped = !_isFlipped;
  }

  void _nextCard() {
    if (_currentIndex < _vocabList.length - 1) {
      setState(() {
        _currentIndex++;
        if (_isFlipped) {
          _isFlipped = false;
          _flipController.value = 0;
        }
      });
    }
  }

  void _prevCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        if (_isFlipped) {
          _isFlipped = false;
          _flipController.value = 0;
        }
      });
    }
  }

  void _startQuiz() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          category: widget.category,
          vocabList: _vocabList,
          progressManager: widget.progressManager,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLast = _currentIndex == _vocabList.length - 1;
    final bool showQuiz =
        isLast && !widget.progressManager.isComingSoonLevel(widget.category.id);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // The flashcard (centered, bigger)
                  _buildFlashcardStack(),
                  // Prev button — outside the card, at screen left
                  Positioned(
                    left: 8,
                    child: RoundButton(
                      icon: Icons.chevron_left_rounded,
                      onPressed: _prevCard,
                      disabled: _currentIndex == 0,
                    ),
                  ),
                  // Next button — outside the card, at screen right
                  Positioned(
                    right: 8,
                    child: RoundButton(
                      icon: Icons.chevron_right_rounded,
                      onPressed: _nextCard,
                      disabled: isLast,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                          offset: Offset(0, 1),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${_vocabList.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  if (showQuiz) ...[
                    const SizedBox(height: 16),
                    ChunkButton(
                      text: 'Start Quiz',
                      onPressed: _startQuiz,
                      backgroundColor: _catColor,
                    ),
                  ] else ...[
                    const SizedBox(height: 16 + 50),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        children: [
          RoundButton(
            icon: Icons.chevron_left_rounded,
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 44), // balance back button
              child: Column(
                children: [
                  Text(
                    widget.category.level.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4B5563),
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    widget.category.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardStack() {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.78;
    final cardHeight = cardWidth * 1.35;

    return SizedBox(
      width: cardWidth + 48, // extra space for the floating hint
      height: cardHeight + 24,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Simulated stacked cards
          Transform.translate(
            offset: const Offset(0, 11),
            child: Transform.rotate(
              angle: -0.04,
              child: Container(
                width: cardWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(82),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, 7),
            child: Transform.rotate(
              angle: 0.05,
              child: Container(
                width: cardWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(140),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          // Active Card with attached 3D flipping interaction hint
          TactileScale(
            onTap: _flipCard,
            pressedScale: 0.97,
            child: AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final angle = _flipAnimation.value;
                final isBack = angle >= pi / 2;
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        isBack
                            ? Transform(
                                transform: Matrix4.identity()..rotateY(pi),
                                alignment: Alignment.center,
                                child: _buildCardSide(
                                  isBack: true,
                                  cardWidth: cardWidth,
                                  cardHeight: cardHeight,
                                ),
                              )
                            : _buildCardSide(
                                isBack: false,
                                cardWidth: cardWidth,
                                cardHeight: cardHeight,
                              ),
                        Positioned(
                          top: -12,
                          right: -12,
                          child: isBack
                              ? Transform(
                                  transform: Matrix4.identity()..rotateY(pi),
                                  alignment: Alignment.center,
                                  child: _InteractionHint(),
                                )
                              : _InteractionHint(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSide({
    required bool isBack,
    required double cardWidth,
    required double cardHeight,
  }) {
    final item = _vocabList[_currentIndex];
    // Slightly darken for back
    final sideColor = isBack
        ? Color.lerp(_catColor, const Color(0xFF64707D), 0.45)!
        : _catColor;

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: sideColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(31, 41, 55, 0.35),
            offset: Offset(0, 10),
            blurRadius: 18,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 3),
              ),
              clipBehavior: Clip.hardEdge,
              child: _VocabImage(
                imagePath: isBack ? (item.backImg ?? item.img) : item.img,
                isGrayscale: isBack,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            (isBack ? 'Bahasa Indonesia' : 'English').toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isBack ? item.id : item.en,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 1.1,
              shadows: [
                Shadow(
                  color: Color.fromRGBO(31, 41, 55, 0.18),
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _VocabImage extends StatelessWidget {
  final String imagePath;
  final bool isGrayscale;

  const _VocabImage({required this.imagePath, this.isGrayscale = false});

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (imagePath.startsWith('dummy:')) {
      final emoji = imagePath.substring(6);
      child = Container(
        color: const Color(0xFF7FB6D8),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 80)),
      );
    } else if (imagePath.endsWith('.svg')) {
      child = SvgPicture.asset(imagePath, fit: BoxFit.cover);
    } else {
      child = Image.asset(imagePath, fit: BoxFit.cover);
    }

    if (isGrayscale) {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.33,
          0.33,
          0.33,
          0,
          0,
          0.33,
          0.33,
          0.33,
          0,
          0,
          0.33,
          0.33,
          0.33,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: child,
      );
    }
    return child;
  }
}

class _InteractionHint extends StatefulWidget {
  @override
  State<_InteractionHint> createState() => _InteractionHintState();
}

class _InteractionHintState extends State<_InteractionHint>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: -3,
      end: 3,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) =>
          Transform.translate(offset: Offset(0, _anim.value), child: child),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(31, 41, 55, 0.25),
              offset: Offset(0, 6),
              blurRadius: 14,
              spreadRadius: -6,
            ),
          ],
        ),
        child: const Icon(Icons.touch_app_rounded, color: Color(0xFF1F2937)),
      ),
    );
  }
}
