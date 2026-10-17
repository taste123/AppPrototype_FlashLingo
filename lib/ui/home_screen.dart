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
  @override
  Widget build(BuildContext context) {
    final int totalStars = widget.progressManager.getTotalStars();
    final int maxStars = categoriesData.length * 3;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final isTablet = size.shortestSide >= 600;

    final int crossAxisCount = screenWidth >= 900 ? 4 : (isTablet ? 3 : 2);
    final double maxContentWidth = crossAxisCount == 4 ? 920.0 : 700.0;
    final double hPadding = isTablet
        ? ((screenWidth - maxContentWidth) / 2).clamp(32.0, 300.0)
        : 24.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: isTablet ? 24 : 16),
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
                      height: isTablet ? 175 : 135,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  _buildStarMeter(totalStars, maxStars, isTablet),
                  SizedBox(height: isTablet ? 14 : 8),
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 16),
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
                      isTablet: isTablet,
                      onTap: () => _openCategory(cat),
                    ),
                  );
                }, childCount: categoriesData.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: isTablet ? 20 : 24,
                  mainAxisSpacing: isTablet ? 20 : 24,
                  childAspectRatio: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarMeter(int current, int max, bool isTablet) {
    final percent = max > 0 ? ((current / max) * 100).round() : 0;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 22 : 16,
        vertical: isTablet ? 10 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(240),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: Colors.white, width: isTablet ? 3.0 : 2.5),
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
          Icon(Icons.star_rounded,
              color: const Color(0xFFFFC93C), size: isTablet ? 28 : 22),
          const SizedBox(width: 8),
          Text(
            '$current / $max',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: isTablet ? 18 : 15,
              color: const Color(0xFF1F2937),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 10 : 8,
              vertical: isTablet ? 4 : 2.5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              '$percent%',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: isTablet ? 14 : 12,
                color: const Color(0xFF2E7D32),
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
  final bool isTablet;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.unlocked,
    required this.passed,
    required this.stars,
    required this.color,
    this.isTablet = false,
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
    final isTablet = widget.isTablet;

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
                borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
                border: Border.all(color: Colors.white, width: isTablet ? 4.5 : 4),
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
                borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
                child: Container(
                  width: double.infinity,
                  color: widget.color,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(isTablet ? 12.0 : 8.0),
                          child: _buildImage(widget.category.imagePath),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: isTablet ? 14.0 : 10.0),
                        child: Column(
                          children: [
                            Text(
                              widget.category.level,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: isTablet ? 16 : 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              widget.category.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: isTablet ? 13 : 11,
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
                  borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
                  child: Container(
                    color: const Color.fromRGBO(31, 41, 55, 0.28),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(isTablet ? 12 : 8),
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
                        child: Icon(
                          Icons.lock,
                          color: const Color(0xFF1F2937),
                          size: isTablet ? 38 : 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // Star badge
            if (widget.passed)
              Positioned(
                top: isTablet ? -10 : -8,
                right: isTablet ? -10 : -8,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 8 : 6,
                    vertical: isTablet ? 5 : 4,
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
                        size: isTablet ? 17 : 14,
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
