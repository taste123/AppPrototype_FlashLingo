import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

enum CardTransitionDirection { next, prev, none }

class _FlashcardScreenState extends State<FlashcardScreen>
    with TickerProviderStateMixin {
  late List<VocabItem> _vocabList;
  int _currentIndex = 0;
  bool _isFlipped = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  late AnimationController _slideController;
  CardTransitionDirection _transitionDir = CardTransitionDirection.none;
  bool _isTransitioning = false;

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
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_flipController.isAnimating || _isTransitioning) return;
    HapticFeedback.lightImpact();
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    _isFlipped = !_isFlipped;
  }

  void _nextCard() {
    if (_currentIndex >= _vocabList.length - 1 ||
        _isTransitioning ||
        _flipController.isAnimating) {
      return;
    }
    HapticFeedback.selectionClick();
    setState(() {
      _isTransitioning = true;
      _transitionDir = CardTransitionDirection.next;
    });

    _slideController.forward(from: 0.0).then((_) {
      if (!mounted) return;
      setState(() {
        _currentIndex++;
        _isFlipped = false;
        _flipController.value = 0;
        _transitionDir = CardTransitionDirection.none;
        _isTransitioning = false;
        _slideController.value = 0;
      });
    });
  }

  void _prevCard() {
    if (_currentIndex <= 0 ||
        _isTransitioning ||
        _flipController.isAnimating) {
      return;
    }
    HapticFeedback.selectionClick();
    setState(() {
      _currentIndex--;
      _isFlipped = false;
      _flipController.value = 0;
      _isTransitioning = true;
      _transitionDir = CardTransitionDirection.prev;
    });

    _slideController.forward(from: 0.0).then((_) {
      if (!mounted) return;
      setState(() {
        _transitionDir = CardTransitionDirection.none;
        _isTransitioning = false;
        _slideController.value = 0;
      });
    });
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
                  // The flashcard with swipe gestures
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      final velocity = details.primaryVelocity ?? 0;
                      if (velocity < -200) {
                        _nextCard();
                      } else if (velocity > 200) {
                        _prevCard();
                      }
                    },
                    child: _buildFlashcardStack(),
                  ),
                  // Prev button — outside the card, at screen left
                  Positioned(
                    left: 8,
                    child: RoundButton(
                      icon: Icons.chevron_left_rounded,
                      onPressed: _prevCard,
                      disabled: _currentIndex == 0 || _isTransitioning,
                    ),
                  ),
                  // Next button — outside the card, at screen right
                  Positioned(
                    right: 8,
                    child: RoundButton(
                      icon: Icons.chevron_right_rounded,
                      onPressed: _nextCard,
                      disabled: isLast || _isTransitioning,
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

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  Widget _buildFlashcardStack() {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.78;
    final cardHeight = cardWidth * 1.35;

    return SizedBox(
      width: cardWidth + 48,
      height: cardHeight + 24,
      child: AnimatedBuilder(
        animation: _slideController,
        builder: (context, _) {
          final t = _slideController.value;

          Offset topOffset = Offset.zero;
          double topAngle = 0.0;
          double topOpacity = 1.0;

          Offset underOffset = const Offset(0, 7);
          double underAngle = 0.04;
          double underScale = 0.95;

          Offset base3Offset = const Offset(0, 14);
          double base3Angle = -0.04;
          double base3Scale = 0.90;

          if (_transitionDir == CardTransitionDirection.next) {
            final curve = Curves.easeInOutCubic.transform(t);
            topOffset = Offset(-screenWidth * 1.15 * curve, -18 * curve);
            topAngle = -0.22 * curve;
            topOpacity = (1.0 - curve * 1.3).clamp(0.0, 1.0);

            underOffset = Offset(0, _lerp(7, 0, curve));
            underAngle = _lerp(0.04, 0.0, curve);
            underScale = _lerp(0.95, 1.0, curve);

            base3Offset = Offset(0, _lerp(14, 7, curve));
            base3Angle = _lerp(-0.04, 0.04, curve);
            base3Scale = _lerp(0.90, 0.95, curve);
          } else if (_transitionDir == CardTransitionDirection.prev) {
            final curve = Curves.easeOutCubic.transform(t);
            topOffset = Offset(
              -screenWidth * 1.15 * (1.0 - curve),
              -18 * (1.0 - curve),
            );
            topAngle = -0.22 * (1.0 - curve);
            topOpacity = curve.clamp(0.0, 1.0);

            underOffset = Offset(0, _lerp(0, 7, curve));
            underAngle = _lerp(0.0, 0.04, curve);
            underScale = _lerp(1.0, 0.95, curve);

            base3Offset = Offset(0, _lerp(7, 14, curve));
            base3Angle = _lerp(0.04, -0.04, curve);
            base3Scale = _lerp(0.95, 0.90, curve);
          }

          final hasUnderCard = _currentIndex + 1 < _vocabList.length;
          final hasBase3Card = _currentIndex + 2 < _vocabList.length;

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Layer 3: Bottom deck card
              if (hasBase3Card)
                Transform.translate(
                  offset: base3Offset,
                  child: Transform.rotate(
                    angle: base3Angle,
                    child: Transform.scale(
                      scale: base3Scale,
                      child: Container(
                        width: cardWidth,
                        height: cardHeight,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(90),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withAlpha(160),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Layer 2: Next card in the stack
              if (hasUnderCard)
                Transform.translate(
                  offset: underOffset,
                  child: Transform.rotate(
                    angle: underAngle,
                    child: Transform.scale(
                      scale: underScale,
                      child: _buildCardSide(
                        isBack: false,
                        cardWidth: cardWidth,
                        cardHeight: cardHeight,
                        itemIndex: _currentIndex + 1,
                      ),
                    ),
                  ),
                ),

              // Layer 1: Active top card
              Transform.translate(
                offset: topOffset,
                child: Transform.rotate(
                  angle: topAngle,
                  child: Opacity(
                    opacity: topOpacity,
                    child: TactileScale(
                      onTap: _flipCard,
                      disabled: _isTransitioning,
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
                                          transform: Matrix4.identity()
                                            ..rotateY(pi),
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
                                            transform: Matrix4.identity()
                                              ..rotateY(pi),
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
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCardSide({
    required bool isBack,
    required double cardWidth,
    required double cardHeight,
    int? itemIndex,
  }) {
    final idx = (itemIndex ?? _currentIndex).clamp(0, _vocabList.length - 1);
    final item = _vocabList[idx];
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
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.93, end: 1.0).animate(anim),
            child: child,
          ),
        ),
        child: Column(
          key: ValueKey<String>('card_${idx}_$isBack'),
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
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flip_camera_android_rounded,
                    size: 12,
                    color: Colors.white.withAlpha(210),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isBack ? 'Tap to flip back' : 'Tap to flip',
                    style: TextStyle(
                      color: Colors.white.withAlpha(210),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
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
      child = Image.asset(imagePath, fit: BoxFit.cover, cacheWidth: 800);
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
