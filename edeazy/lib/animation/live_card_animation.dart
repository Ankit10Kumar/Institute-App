import 'dart:async';
import 'package:flutter/material.dart';

/// You can use whatever widget as a [child], when you don't need to provide any
/// [child], just provide an empty Container().
/// [delay] is using a [Timer] for delaying the animation, it's zero by default.
/// You can set [repeat] to true for making a paulsing effect.
class LiveAnimation extends StatefulWidget {
  final Widget child;
  // final Duration delay;
  final double minRadius;
  final Color? color;
  final int ripplesCount;
  final Duration duration;
  final bool repeat;
  final bool animate;

  const LiveAnimation({
    Key? key,
    required this.child,
    this.color,
    this.repeat = false,
    this.animate = false,
    this.minRadius = 60,
    this.ripplesCount = 5,
    this.duration = const Duration(milliseconds: 2300),
  }) : super(key: key);

  @override
  _LiveAnimationState createState() => _LiveAnimationState();
}

class _LiveAnimationState extends State<LiveAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // repeating or just forwarding the animation once.

    widget.repeat ? _controller.repeat() : _controller.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate) {
      return CustomPaint(
        painter: CirclePainter(
          _controller,
          color: widget.color ?? Colors.black,
          minRadius: widget.minRadius,
          wavesCount: widget.ripplesCount + 2,
        ),
        child: widget.child,
      );
    }
    return widget.child;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Creating a Circular painter for clipping the rects and creating circle shapes
class CirclePainter extends CustomPainter {
  final Color color;
  final double minRadius;
  final int wavesCount;
  final Animation<double> _animation;
  CirclePainter(
    this._animation, {
    required this.minRadius,
    required this.wavesCount,
    required this.color,
  }) : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 0; wave <= wavesCount; wave++) {
      circle(canvas, rect, minRadius, wave, _animation.value, wavesCount);
    }
  }

  // animating the opacity according to min radius and waves count.
  void circle(Canvas canvas, Rect rect, double minRadius, int wave,
      double value, int length) {
    Color _color;
    double r;
    if (wave != 0) {
      double opacity = (1 - ((wave - 2) / length) - value).clamp(0.0, 1.0);
      _color = color.withOpacity(opacity);

      r = minRadius * (1 + ((wave * value))) * value;
      final Paint paint = Paint()..color = _color;
      canvas.drawCircle(rect.center, r, paint);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
