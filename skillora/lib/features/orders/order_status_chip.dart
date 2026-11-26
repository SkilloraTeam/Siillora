import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../order/placed_order.dart';

/// Pil status kecil. Warna dibedakan tipis: selesai hijau, revisi kuning,
/// sisanya biru muda.
class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status, this.label});

  final OrderStatus status;

  /// Default: [OrderStatus.label].
  final String? label;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      OrderStatus.selesai => (const Color(0xFFD9ECDF), AppColors.success),
      OrderStatus.revisi => (const Color(0xFFF6E4BE), const Color(0xFF8A5A0B)),
      _ => (AppColors.mist, AppColors.navyDeep),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label ?? status.label,
        style: AppText.label.copyWith(fontSize: 10, color: fg),
      ),
    );
  }
}
