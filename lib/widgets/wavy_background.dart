import 'dart:math' as math;

import 'package:flutter/material.dart';

class WavyBackground extends StatefulWidget {
  const WavyBackground({
    super.key,
    this.waveColor = const Color(0xFF38BDF8),
  });

  final Color waveColor;

  @override
  State<WavyBackground> createState() => _WavyBackgroundState();
}

class _WavyBackgroundState extends State<WavyBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
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
          return CustomPaint(
            painter: _WavePainter(
              progress: _controller.value,
              waveColor: widget.waveColor,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.progress,
    required this.waveColor,
  });

  final double progress;
  final Color waveColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }

    _drawWave(
      canvas,
      size,
      phase: progress * math.pi * 2,
      amplitude: size.height * 0.02,
      baseHeight: size.height * 0.25,
      color: waveColor.withValues(alpha: 0.12),
    );
    _drawWave(
      canvas,
      size,
      phase: progress * math.pi * 2 + 1.2,
      amplitude: size.height * 0.028,
      baseHeight: size.height * 0.55,
      color: waveColor.withValues(alpha: 0.10),
    );
    _drawWave(
      canvas,
      size,
      phase: progress * math.pi * 2 + 2.4,
      amplitude: size.height * 0.022,
      baseHeight: size.height * 0.8,
      color: waveColor.withValues(alpha: 0.08),
    );
  }

  void _drawWave(
    Canvas canvas,
    Size size, {
    required double phase,
    required double amplitude,
    required double baseHeight,
    required Color color,
  }) {
    final path = Path()..moveTo(0, baseHeight);
    final width = size.width;
    for (double x = 0; x <= width; x += 8) {
      final y = baseHeight + math.sin((x / width * 2 * math.pi) + phase) * amplitude;
      path.lineTo(x, y);
    }
    path.lineTo(width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.waveColor != waveColor;
  }
}
