import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import 'payment_chip.dart';
import 'payment_detail_page.dart';
import 'payment_model.dart';

/// Layar 27: daftar pembayaran (tab Bayar).
class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final store = PaymentStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final items = store.items;
        return FlowScaffold(
          title: 'Pembayaran',
          subtitle: 'Daftar pembayaran kamu',
          onBack: onBack,
          children: [
            Reveal(child: _TotalCard(total: store.total)),
            const SizedBox(height: 16),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Text('Belum ada tagihan.', style: AppText.subtitle),
                ),
              ),
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Reveal(
                  index: i + 1,
                  child: _PaymentCard(
                    payment: items[i],
                    onTap: () => Navigator.push(
                      context,
                      appRoute(PaymentDetailPage(orderId: items[i].orderId)),
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

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final still = reduceMotion(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navyDeep, AppColors.navyRing],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total transaksi',
            style: AppText.onDarkBody.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          // Angka naik sekali saat halaman dibuka; tidak diulang saat data berubah.
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: still ? total : 0, end: total),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) => Text(
              formatRupiah(v),
              style: AppText.title.copyWith(
                color: Colors.white,
                fontSize: 26,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment, required this.onTap});

  final Payment payment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.mist,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 20,
                color: AppColors.navyDeep,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          payment.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.label.copyWith(fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PaymentChip(status: payment.status),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(payment.invoice, style: AppText.subtitle.copyWith(fontSize: 11)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        formatRupiah(payment.amount),
                        style: AppText.label.copyWith(fontSize: 12.5),
                      ),
                      const Spacer(),
                      Text('Lihat detail', style: AppText.link.copyWith(fontSize: 11)),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: AppColors.link,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
