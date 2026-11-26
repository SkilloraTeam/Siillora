import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/flow_scaffold.dart';
import 'payment_model.dart';

/// Layar 38: catatan semua transaksi.
class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PaymentStore.instance,
      builder: (context, _) {
        final items = PaymentStore.instance.items;
        return FlowScaffold(
          title: 'Riwayat pembayaran',
          subtitle: 'Catatan transaksimu',
          children: [
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(child: Text('Belum ada transaksi.', style: AppText.subtitle)),
              ),
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Reveal(
                  index: i,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: AppColors.mist,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.receipt_long_rounded,
                            size: 16,
                            color: AppColors.navyDeep,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(items[i].title, style: AppText.label.copyWith(fontSize: 12.5)),
                              const SizedBox(height: 1),
                              Text(
                                formatTanggalPendek(items[i].date),
                                style: AppText.subtitle.copyWith(fontSize: 10.5),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatRupiah(items[i].amount),
                              style: AppText.label.copyWith(fontSize: 12),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              items[i].status.label,
                              style: AppText.label.copyWith(
                                fontSize: 10.5,
                                color: switch (items[i].status) {
                                  PaymentStatus.berhasil => AppColors.success,
                                  PaymentStatus.menunggu => const Color(0xFF8A5A0B),
                                  PaymentStatus.belumBayar => AppColors.textMuted,
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
