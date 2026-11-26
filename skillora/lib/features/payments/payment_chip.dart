import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import 'payment_model.dart';

/// Pil status pembayaran: berhasil hijau, menunggu kuning, belum bayar biru muda.
class PaymentChip extends StatelessWidget {
  const PaymentChip({super.key, required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      PaymentStatus.berhasil => (const Color(0xFFD9ECDF), AppColors.success),
      PaymentStatus.menunggu => (const Color(0xFFF6E4BE), const Color(0xFF8A5A0B)),
      PaymentStatus.belumBayar => (AppColors.mist, AppColors.navyDeep),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        status.label,
        style: AppText.label.copyWith(fontSize: 10, color: fg),
      ),
    );
  }
}
