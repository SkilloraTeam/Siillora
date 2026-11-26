import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Gambar kode QR bergaya QRIS: tiga penanda sudut + pola data.
/// Ini hanya ilustrasi dan tidak bisa dipindai.
/// TODO: ganti dengan string QRIS dari server dan render memakai qr_flutter.
class QrisCode extends StatelessWidget {
  const QrisCode({super.key, required this.seed, this.size = 170});

  final String seed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Kode QRIS pembayaran',
      image: true,
      child: CustomPaint(
        size: Size.square(size),
        painter: _QrPainter(seed.codeUnits.fold(7, (a, b) => (a * 31 + b) & 0x7fffffff)),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  _QrPainter(this.seed);

  final int seed;

  static const _n = 25;

  bool _inFinder(int x, int y) =>
      (x < 8 && y < 8) || (x >= _n - 8 && y < 8) || (x < 8 && y >= _n - 8);

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / _n;
    final ink = Paint()..color = AppColors.textPrimary;

    void rect(double x, double y, double w, double h) => canvas.drawRect(
          Rect.fromLTWH(x * cell, y * cell, w * cell, h * cell),
          ink,
        );

    // Penanda sudut: kotak 7x7, rongga 5x5, inti 3x3.
    void finder(int ox, int oy) {
      rect(ox.toDouble(), oy.toDouble(), 7, 7);
      canvas.drawRect(
        Rect.fromLTWH((ox + 1) * cell, (oy + 1) * cell, 5 * cell, 5 * cell),
        Paint()..color = AppColors.card,
      );
      rect(ox + 2.0, oy + 2.0, 3, 3);
    }

    finder(0, 0);
    finder(_n - 7, 0);
    finder(0, _n - 7);

    // Pola data semu, stabil untuk seed yang sama.
    var s = seed;
    for (var y = 0; y < _n; y++) {
      for (var x = 0; x < _n; x++) {
        if (_inFinder(x, y)) continue;
        s = (s * 1103515245 + 12345) & 0x7fffffff;
        if ((s >> 16) % 100 < 46) rect(x.toDouble(), y.toDouble(), 1, 1);
      }
    }
  }

  @override
  bool shouldRepaint(_QrPainter old) => old.seed != seed;
}
