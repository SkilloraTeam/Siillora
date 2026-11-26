import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import '../order/placed_order.dart';
import '../order/widgets/file_row.dart';
import '../../core/motion/motion.dart';
import 'order_status_chip.dart';
import 'result_page.dart';
import 'review_page.dart';
import 'revision_form_page.dart';
import 'status_timeline.dart';

/// Layar 18-20 (dan keadaan selesai): detail pesanan. Isi menyesuaikan
/// status: ditinjau, dikerjakan, revisi, atau selesai.
class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.orderId});

  final String orderId;

  void _soon(BuildContext context, String what) {
    // TODO: sambungkan ke halaman $what.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Halaman $what belum dibuat.')));
  }

  Future<void> _review(BuildContext context, PlacedOrder order) async {
    // Konfirmasi ditampilkan oleh ReviewSentPage.
    await Navigator.push<bool>(
      context,
      appRoute<bool>(ReviewPage(order: order)),
    );
  }

  Future<void> _finish(BuildContext context, PlacedOrder order) async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selesaikan pesanan?', style: AppText.sectionTitle),
            const SizedBox(height: 6),
            Text(
              'Pastikan hasil sudah sesuai. Setelah diselesaikan, kamu tidak '
              'bisa mengajukan revisi lagi.',
              style: AppText.body,
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'YA, SELESAIKAN',
              onPressed: () => Navigator.pop(ctx, true),
            ),
            const SizedBox(height: 8),
            Center(
              child: AppTextLink(label: 'Batal', onTap: () => Navigator.pop(ctx, false)),
            ),
          ],
        ),
      ),
    );
    if (ok == true) OrderStore.instance.setStatus(order.id, OrderStatus.selesai);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: OrderStore.instance,
      builder: (context, _) {
        final order = OrderStore.instance.byId(orderId);
        if (order == null) {
          return const FlowScaffold(
            title: 'Detail pesanan',
            subtitle: 'Pesanan tidak ditemukan',
            children: [],
          );
        }
        return _build(context, order);
      },
    );
  }

  Widget _build(BuildContext context, PlacedOrder order) {
    final s = order.service;
    final status = order.status;

    return FlowScaffold(
      title: 'Detail pesanan',
      subtitle: 'Order ID ${order.displayId}',
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              layoutBuilder: (current, previous) => Stack(
                alignment: Alignment.topCenter,
                children: [...previous, ?current],
              ),
              child: Column(
                key: ValueKey(status),
                mainAxisSize: MainAxisSize.min,
                children: switch (status) {
                  OrderStatus.menunggu => [
                      const PrimaryButton(label: 'SELESAIKAN PESANAN', onPressed: null),
                      const SizedBox(height: 10),
                      const SecondaryButton(
                        label: 'AJUKAN REVISI',
                        tonal: true,
                        onPressed: null,
                      ),
                    ],
                  OrderStatus.dikerjakan => [
                      PrimaryButton(
                        label: 'SELESAIKAN PESANAN',
                        onPressed: () => _finish(context, order),
                      ),
                      const SizedBox(height: 10),
                      SecondaryButton(
                        label: 'AJUKAN REVISI',
                        tonal: true,
                        onPressed: () => Navigator.push(
                          context,
                          appRoute(RevisionFormPage(order: order)),
                        ),
                      ),
                    ],
                  OrderStatus.revisi => [
                      SecondaryButton(
                        label: 'LIHAT STATUS REVISI',
                        tonal: true,
                        onPressed: () => _soon(context, 'status revisi'),
                      ),
                    ],
                  OrderStatus.selesai => [
                      if (order.reviewed)
                        const SecondaryButton(
                          label: 'ULASAN TERKIRIM',
                          tonal: true,
                          onPressed: null,
                        )
                      else
                        PrimaryButton(
                          label: 'BERI ULASAN',
                          onPressed: () => _review(context, order),
                        ),
                    ],
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (!order.reviewed)
            Text(
              'Beri ulasan setelah pesanan/revisi selesai.',
              style: AppText.subtitle.copyWith(fontSize: 10.5),
            ),
        ],
      ),
      children: [
        Reveal(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.title, style: AppText.label.copyWith(fontSize: 13.5)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${s.seller} • ${formatTanggalPendek(order.deadline)}',
                        style: AppText.subtitle.copyWith(fontSize: 11),
                      ),
                    ),
                    Text(
                      order.price == null
                          ? 'Menunggu harga'
                          : formatRupiah(order.price!),
                      style: AppText.label.copyWith(fontSize: 11.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        Reveal(index: 1, child: Text('Status pesanan', style: AppText.sectionTitle)),
        const SizedBox(height: 10),
        Reveal(
          index: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusTimeline(stage: status.stage),
                const SizedBox(height: 14),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: OrderStatusChip(
                    key: ValueKey(status),
                    status: status,
                    label: status == OrderStatus.selesai
                        ? 'Pesanan selesai'
                        : status.detailLabel,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        Reveal(index: 3, child: Text('Hasil pesanan', style: AppText.sectionTitle)),
        const SizedBox(height: 10),
        Reveal(
          index: 4,
          child: order.result == null
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Belum ada hasil dari penyedia jasa.', style: AppText.body),
                )
              : Pressable(
                  onTap: () => Navigator.push(
                    context,
                    appRoute(ResultPage(order: order)),
                  ),
                  scale: 0.98,
                  child: FileRow(
                    file: order.result!,
                    trailing: const Icon(
                      Icons.arrow_downward_rounded,
                      size: 18,
                      color: AppColors.navyDeep,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 12),
        Reveal(
          index: 5,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.mist,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Komunikasi', style: AppText.label.copyWith(fontSize: 11.5)),
                    const SizedBox(height: 3),
                    Text(
                      'Diskusikan progres langsung dengan penyedia jasa.',
                      style: AppText.subtitle.copyWith(
                        fontSize: 11.5,
                        color: AppColors.navyDeep,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Pressable(
                onTap: () => _soon(context, 'chat'),
                scale: 0.98,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Chat dengan ${s.seller}',
                          style: AppText.label.copyWith(fontSize: 12),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: AppColors.navyDeep,
                      ),
                    ],
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
