import 'package:flutter/material.dart';

import 'motion.dart';

/// Muncul dengan fade + naik tipis. Isi [index] berurutan (0, 1, 2, ...)
/// supaya bagian-bagian halaman masuk satu per satu, bukan sekaligus.
class Reveal extends StatefulWidget {
  const Reveal({super.key, required this.child, this.index = 0, this.dy = 14});

  final Widget child;
  final int index;
  final double dy;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  static const _duration = 420;
  static const _step = 70;

  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    final delay = widget.index * _step;
    _c = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: delay + _duration),
    );
    _a = CurvedAnimation(
      parent: _c,
      curve: Interval(
        delay / (delay + _duration),
        1,
        curve: Curves.easeOutCubic,
      ),
    );
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) return widget.child;
    return AnimatedBuilder(
      animation: _a,
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: _a.value,
        child: Transform.translate(
          offset: Offset(0, (1 - _a.value) * widget.dy),
          child: child,
        ),
      ),
    );
  }
}
