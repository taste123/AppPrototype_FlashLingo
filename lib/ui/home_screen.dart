import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learn/data/content.dart';
import 'package:learn/data/models.dart';
import 'package:learn/data/progress_manager.dart';
import 'package:learn/ui/flashcard_screen.dart';
import 'package:learn/ui/widgets/app_background.dart';
import 'package:learn/ui/widgets/buttons.dart';

class HomeScreen extends StatefulWidget {
  final ProgressManager progressManager;

  const HomeScreen({super.key, required this.progressManager});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  Color _parseColor(String hexCode) {
    return Color(int.parse(hexCode.replaceFirst('#', '0xFF')));
  }

  void _openCategory(Category category) async {
    if (!widget.progressManager.isLevelUnlocked(category.id)) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FlashcardScreen(
          category: category,
          progressManager: widget.progressManager,
        ),
      ),
    );

    // Refresh progress when returning
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final int totalStars = widget.progressManager.getTotalStars();
    final int maxStars = categoriesData.length * 3;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: child,
                      );
                    },
                    child: Image.asset(
                      'assets/newLogo.png',
                      height: 135,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStarMeter(totalStars, maxStars),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final cat = categoriesData[index];
                  final unlocked = widget.progressManager.isLevelUnlocked(
                    cat.id,
                  );
                  final passed = widget.progressManager.hasPassedLevel(cat.id);
                  final stars = widget.progressManager.getLevelStars(cat.id);

                  return TweenAnimationBuilder<double>(
                    key: ValueKey('cat_${cat.id}'),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(
                      milliseconds: 320 + (index * 45).clamp(0, 450),
                    ),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: _CategoryCard(
                      category: cat,
                      unlocked: unlocked,
                      passed: passed,
                      stars: stars,
                      color: _parseColor(cat.colorHex),
                      onTap: () => _openCategory(cat),
                    ),
                  );
                }, childCount: categoriesData.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarMeter(int current, int max) {
    final percent = max > 0 ? ((current / max) * 100).round() : 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(240),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(31, 41, 55, 0.15),
            offset: Offset(0, 6),
            blurRadius: 16,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFC93C), size: 22),
          const SizedBox(width: 6),
          Text(
            '$current / $max',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: Color(0xFF1F2937),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              '$percent%',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final Category category;
  final bool unlocked;
  final bool passed;
  final int stars;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.unlocked,
    required this.passed,
    required this.stars,
    required this.color,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  final GlobalKey<ShakeWidgetState> _shakeKey = GlobalKey<ShakeWidgetState>();

  void _handleTap() {
    if (widget.unlocked) {
      widget.onTap();
    } else {
      _shakeKey.currentState?.shake();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShakeWidget(
      key: _shakeKey,
      shakeOffset: 7.0,
      child: TactileScale(
        onTap: _handleTap,
        disabled: false,
        pressedScale: 0.94,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Outer card with white border
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(31, 41, 55, 0.28),
                    offset: Offset(0, 10),
                    blurRadius: 18,
                    spreadRadius: -8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  color: widget.color,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildImage(widget.category.imagePath),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          children: [
                            Text(
                              widget.category.level,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              widget.category.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Lock overlay
            if (!widget.unlocked)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: const Color.fromRGBO(31, 41, 55, 0.28),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(31, 41, 55, 0.25),
                              offset: Offset(0, 6),
                              blurRadius: 14,
                              spreadRadius: -6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Color(0xFF1F2937),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // Star badge
            if (widget.passed)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(31, 41, 55, 0.25),
                        offset: Offset(0, 6),
                        blurRadius: 14,
                        spreadRadius: -6,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      return Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: index < widget.stars
                            ? const Color(0xFFFFC93C)
                            : const Color(0xFFDFE4EA),
                      );
                    }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.endsWith('.svg')) {
      return SvgPicture.asset(path, fit: BoxFit.contain);
    }
    return Image.asset(path, fit: BoxFit.contain);
  }
}
