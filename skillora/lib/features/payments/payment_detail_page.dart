import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import '../order/widgets/file_row.dart';
import 'payment_chip.dart';
import 'payment_model.dart';
import 'qris_code.dart';
import 'upload_proof_page.dart';

/// Layar 28: detail pembayaran dengan kode QRIS.
class PaymentDetailPage extends StatelessWidget {
  const PaymentDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PaymentStore.instance,
      builder: (context, _) {
        final p = PaymentStore.instance.byOrder(orderId);
        if (p == null) {
          return const FlowScaffold(
            title: 'Detail pembayaran',
            subtitle: 'Tagihan tidak ditemukan',
            children: [],
          );
        }
        return _build(context, p);
      },
    );
  }

  Widget _build(BuildContext context, Payment p) {
    final paid = p.status == PaymentStatus.berhasil;
    final hasProof = p.proof != null;

    return FlowScaffold(
      title: 'Detail pembayaran',
      subtitle: 'Pesanan ${p.displayOrderId}',
      bottom: PrimaryButton(label: 'SELESAI', onPressed: () => Navigator.pop(context)),
      children: [
        Reveal(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total tagihan', style: AppText.subtitle),
                      const SizedBox(height: 2),
                      Text(
                        formatRupiah(p.amount),
                        style: AppText.title.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 4),
                      Text(p.title, style: AppText.subtitle.copyWith(fontSize: 11.5)),
                    ],
                  ),
                ),
                PaymentChip(status: p.status),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: paid
              ? Reveal(
                  index: 1,
                  child: Text(
                    'Pembayaran ini sudah diterima. Tidak ada yang perlu kamu lakukan lagi.',
                    style: AppText.body,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Reveal(
                      index: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Scan kode QRIS', style: AppText.sectionTitle),
                          const SizedBox(height: 2),
                          Text(
                            'Gunakan mobile banking atau e-wallet.',
                            style: AppText.subtitle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Reveal(
                      index: 2,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.fieldBorder.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              QrisCode(seed: p.invoice),
                              const SizedBox(height: 10),
                              Text(
                                'QRIS • Ruang Karya',
                                style: AppText.subtitle.copyWith(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Reveal(
                      index: 3,
                      child: Text('Kirim bukti pembayaran', style: AppText.sectionTitle),
                    ),
                    const SizedBox(height: 10),
                    Reveal(
                      index: 4,
                      child: hasProof
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FileRow(file: p.proof!),
                                const SizedBox(height: 8),
                                Text(
                                  'Bukti sudah terkirim. Kami sedang memeriksanya.',
                                  style: AppText.subtitle,
                                ),
                              ],
                            )
                          : _UploadTile(
                              onTap: () => Navigator.push(
                                context,
                                appRoute(UploadProofPage(orderId: p.orderId)),
                              ),
                            ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.7)),
        ),
        child: Row(
          children: [
            const Icon(Icons.add_rounded, size: 24, color: AppColors.sky),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Unggah bukti pembayaran', style: AppText.label.copyWith(fontSize: 12)),
                  const SizedBox(height: 1),
                  Text('Format PNG atau JPG', style: AppText.subtitle.copyWith(fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
