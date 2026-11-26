import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../motion/motion.dart';
import '../theme/app_colors.dart';

/// Lingkaran biru muda yang membal masuk, lalu centang digambar bertahap.
/// Dipakai di layar konfirmasi (pesanan terkirim, revisi terkirim).
class SuccessMark extends StatefulWidget {
  const SuccessMark({super.key, this.size = 148});

  final double size;

  @override
  State<SuccessMark> createState() => _SuccessMarkState();
}

class _SuccessMarkState extends State<SuccessMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final _circle = CurvedAnimation(
    parent: _c,
    curve: const Interval(0, 0.5, curve: Curves.easeOutBack),
  );
  late final _check = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.4, 1, curve: Curves.easeOutCubic),
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) _c.value = 1;

    return Semantics(
      label: 'Berhasil',
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Transform.scale(
          scale: _circle.value.clamp(0.0, 1.2).toDouble(),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(painter: _CheckPainter(_check.value)),
          ),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  _CheckPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2,
      Paint()..color = AppColors.mist,
    );

    final w = size.width;
    final path = Path()
      ..moveTo(w * 0.33, w * 0.52)
      ..lineTo(w * 0.45, w * 0.63)
      ..lineTo(w * 0.68, w * 0.39);

    final paint = Paint()
      ..color = AppColors.navyDeep
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.04
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final m in path.computeMetrics()) {
      canvas.drawPath(m.extractPath(0, m.length * math.min(1.0, progress)), paint);
    }
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.progress != progress;
}
