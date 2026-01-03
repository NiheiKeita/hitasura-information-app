import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PressableSurface extends StatefulWidget {
  const PressableSurface({
    super.key,
    required this.child,
    required this.decorationBuilder,
    required this.borderRadius,
    required this.onTap,
    this.enabled = true,
    this.pressedOffset = const Offset(0, 0.04),
    this.pressDuration = const Duration(milliseconds: 60),
    this.releaseDelay = const Duration(milliseconds: 60),
    this.enableHaptics = true,
  });

  final Widget child;
  final BoxDecoration Function(bool pressed) decorationBuilder;
  final BorderRadius borderRadius;
  final VoidCallback onTap;
  final bool enabled;
  final Offset pressedOffset;
  final Duration pressDuration;
  final Duration releaseDelay;
  final bool enableHaptics;

  @override
  State<PressableSurface> createState() => _PressableSurfaceState();
}

class _PressableSurfaceState extends State<PressableSurface> {
  bool _pressed = false;
  Timer? _releaseTimer;

  void _setPressed(bool pressed) {
    if (_pressed == pressed) {
      return;
    }
    setState(() => _pressed = pressed);
  }

  void _scheduleRelease() {
    _releaseTimer?.cancel();
    _releaseTimer = Timer(widget.releaseDelay, () {
      if (!mounted) {
        return;
      }
      _setPressed(false);
    });
  }

  @override
  void dispose() {
    _releaseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _pressed ? widget.pressedOffset : Offset.zero,
      duration: widget.pressDuration,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: widget.pressDuration,
        curve: Curves.easeOut,
        decoration: widget.decorationBuilder(_pressed),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.enabled ? widget.onTap : null,
            onTapDown: widget.enabled
                ? (_) {
                    if (widget.enableHaptics) {
                      HapticFeedback.lightImpact();
                    }
                    _releaseTimer?.cancel();
                    _setPressed(true);
                  }
                : null,
            onTapCancel: widget.enabled
                ? () {
                    _releaseTimer?.cancel();
                    _setPressed(false);
                  }
                : null,
            onTapUp: widget.enabled ? (_) => _scheduleRelease() : null,
            borderRadius: widget.borderRadius,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
