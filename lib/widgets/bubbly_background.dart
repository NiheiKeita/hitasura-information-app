import 'dart:math' as math;

import 'package:flutter/material.dart';

class BubblyBackground extends StatefulWidget {
  const BubblyBackground({
    super.key,
    this.bubbleCount = 18,
    this.minRadius = 6,
    this.maxRadius = 22,
  });

  final int bubbleCount;
  final double minRadius;
  final double maxRadius;

  @override
  State<BubblyBackground> createState() => _BubblyBackgroundState();
}

class _BubblyBackgroundState extends State<BubblyBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Bubble> _bubbles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    final rand = math.Random(42);
    _bubbles = List.generate(widget.bubbleCount, (_) {
      final radius = widget.minRadius +
          rand.nextDouble() * (widget.maxRadius - widget.minRadius);
      final opacity = 0.18 + rand.nextDouble() * 0.14;
      return _Bubble(
        x: rand.nextDouble(),
        radius: radius,
        speed: 0.6 + rand.nextDouble() * 0.8,
        drift: 0.02 + rand.nextDouble() * 0.05,
        opacity: opacity,
        phase: rand.nextDouble(),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SizedBox.expand(
            child: CustomPaint(
              painter: _BubblePainter(
                bubbles: _bubbles,
                progress: _controller.value,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Bubble {
  const _Bubble({
    required this.x,
    required this.radius,
    required this.speed,
    required this.drift,
    required this.opacity,
    required this.phase,
  });

  final double x;
  final double radius;
  final double speed;
  final double drift;
  final double opacity;
  final double phase;
}

class _BubblePainter extends CustomPainter {
  _BubblePainter({
    required this.bubbles,
    required this.progress,
  });

  final List<_Bubble> bubbles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }

    for (final bubble in bubbles) {
      final t = (progress * bubble.speed + bubble.phase) % 1.0;
      final y = size.height * (1.1 - t * 1.2);
      final drift = math.sin((progress + bubble.phase) * math.pi * 2);
      final x = size.width * bubble.x + drift * bubble.drift * size.width;

      final fillPaint = Paint()
        ..color = Colors.white.withValues(alpha: bubble.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), bubble.radius, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.bubbles != bubbles;
  }
}
