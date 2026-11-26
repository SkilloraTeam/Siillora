import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/flow_scaffold.dart';
import 'edit_order_page.dart';
import 'order_model.dart';
import 'order_sent_page.dart';
import 'placed_order.dart';

/// Layar 14: ringkasan sebelum pesanan dikirim.
class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key, required this.draft});

  final OrderDraft draft;

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  static const _amber = Color(0xFFC98512);

  late OrderDraft _draft = widget.draft;
  bool _sending = false;

  Future<void> _edit() async {
    final r = await Navigator.push<OrderDraft>(
      context,
      appRoute<OrderDraft>(EditOrderPage(draft: _draft)),
    );
    if (r != null && mounted) setState(() => _draft = r);
  }

  Future<void> _send() async {
    setState(() => _sending = true);
    // TODO: kirim pesanan ke Supabase (tabel orders) + unggah lampiran.
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    final order = OrderStore.instance.add(_draft);
    await Navigator.push(context, appRoute(OrderSentPage(order: order)));
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final s = _draft.service;

    return FlowScaffold(
      title: 'Ringkasan pesanan',
      subtitle: 'Periksa kembali sebelum dikirim',
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SecondaryButton(label: 'EDIT PESANAN', onPressed: _sending ? null : _edit),
          const SizedBox(height: 10),
          PrimaryButton(label: 'KIRIM PESANAN', loading: _sending, onPressed: _send),
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
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.navyDeep,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(s.icon, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.title, style: AppText.label.copyWith(fontSize: 13.5)),
                      const SizedBox(height: 1),
                      Text(s.seller, style: AppText.subtitle.copyWith(fontSize: 11)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.mist,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Menunggu',
                          style: AppText.label.copyWith(
                            fontSize: 10,
                            color: AppColors.navyDeep,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        Reveal(index: 1, child: Text('Detail pesanan', style: AppText.sectionTitle)),
        const SizedBox(height: 10),
        Reveal(
          index: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pesan jasa', style: AppText.subtitle.copyWith(fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(
                    _draft.message,
                    style: AppText.label.copyWith(fontSize: 12.5, height: 1.45),
                  ),
                  const _Rule(),
                  _KeyValue(
                    label: 'Estimasi deadline',
                    value: formatTanggal(_draft.deadline),
                  ),
                  const _Rule(),
                  Text('Lampiran', style: AppText.subtitle.copyWith(fontSize: 11)),
                  const SizedBox(height: 6),
                  if (_draft.attachments.isEmpty)
                    Text(
                      'Tidak ada lampiran',
                      style: AppText.body.copyWith(fontSize: 12),
                    )
                  else
                    for (final f in _draft.attachments)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                f.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.label.copyWith(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              formatUkuranFile(f.sizeBytes),
                              style: AppText.subtitle.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                  const _Rule(),
                  _KeyValue(
                    label: 'Harga',
                    value: 'Menunggu persetujuan',
                    valueColor: _amber,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Reveal(
          index: 3,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selanjutnya', style: AppText.label.copyWith(fontSize: 11.5)),
                const SizedBox(height: 3),
                Text(
                  'Penyedia jasa akan menerima permintaanmu.',
                  style: AppText.subtitle.copyWith(
                    fontSize: 11.5,
                    color: AppColors.navyDeep,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Divider(
          height: 1,
          thickness: 1,
          color: AppColors.fieldBorder.withValues(alpha: 0.35),
        ),
      );
}

class _KeyValue extends StatelessWidget {
  const _KeyValue({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppText.subtitle.copyWith(fontSize: 11.5)),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Text(
            value,
            key: ValueKey(value),
            style: AppText.label.copyWith(
              fontSize: 12,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
