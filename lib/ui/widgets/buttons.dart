import 'package:flutter/material.dart';

/// Reusable tactile press-scale widget implementing Apple Design response principle
/// (Instant scale-down on pointer-down, spring return on release).
class TactileScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool disabled;
  final double pressedScale;

  const TactileScale({
    super.key,
    required this.child,
    this.onTap,
    this.disabled = false,
    this.pressedScale = 0.95,
  });

  @override
  State<TactileScale> createState() => _TactileScaleState();
}

class _TactileScaleState extends State<TactileScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressedScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.disabled) _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.disabled) {
      _controller.reverse();
      widget.onTap?.call();
    }
  }

  void _onTapCancel() {
    if (!widget.disabled) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool disabled;

  const RoundButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return TactileScale(
      onTap: disabled ? null : onPressed,
      disabled: disabled,
      pressedScale: 0.92,
      child: Opacity(
        opacity: disabled ? 0.35 : 1.0,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(31, 41, 55, 0.18),
                offset: Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: const Color(0xFF1F2937), size: 24),
          ),
        ),
      ),
    );
  }
}

class ChunkButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final bool disabled;

  const ChunkButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return TactileScale(
      onTap: disabled ? null : onPressed,
      disabled: disabled,
      pressedScale: 0.96,
      child: Container(
        decoration: BoxDecoration(
          color: disabled ? backgroundColor.withAlpha(128) : backgroundColor,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: Colors.white, width: 3.5),
          boxShadow: disabled
              ? null
              : const [
                  BoxShadow(
                    color: Color.fromRGBO(31, 41, 55, 0.18),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 14),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
