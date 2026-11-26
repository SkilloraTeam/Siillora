import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import '../order/placed_order.dart';
import 'order_detail_page.dart';
import 'order_status_chip.dart';

enum _Filter {
  semua('Semua'),
  diproses('Diproses'),
  selesai('Selesai'),
  revisi('Revisi');

  const _Filter(this.label);
  final String label;

  bool matches(OrderStatus s) => switch (this) {
        _Filter.semua => true,
        _Filter.diproses =>
          s == OrderStatus.menunggu || s == OrderStatus.dikerjakan,
        _Filter.selesai => s == OrderStatus.selesai,
        _Filter.revisi => s == OrderStatus.revisi,
      };
}

/// Layar 17: daftar pesanan dengan penyaring status.
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _store = OrderStore.instance;
  _Filter _filter = _Filter.semua;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final items = [
          for (final o in _store.orders)
            if (_filter.matches(o.status)) o,
        ];

        return FlowScaffold(
          title: 'Kategori pesanan',
          subtitle: 'Pantau pesanan yang kamu buat',
          onBack: widget.onBack,
          children: [
            Reveal(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final f in _Filter.values) ...[
                      _FilterChip(
                        label: f.label,
                        selected: f == _filter,
                        onTap: () => setState(() => _filter = f),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              layoutBuilder: (current, previous) => Stack(
                alignment: Alignment.topCenter,
                children: [...previous, ?current],
              ),
              child: Column(
                key: ValueKey(_filter),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          'Belum ada pesanan di sini.',
                          style: AppText.subtitle,
                        ),
                      ),
                    ),
                  for (var i = 0; i < items.length; i++)
                    Padding(
                      key: ValueKey(items[i].id),
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Reveal(
                        index: i,
                        child: _OrderCard(
                          order: items[i],
                          onTap: () => Navigator.push(
                            context,
                            appRoute(OrderDetailPage(orderId: items[i].id)),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Saring: $label',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: selected ? AppColors.navyDeep : AppColors.mist,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: AppText.label.copyWith(
                  fontSize: 11.5,
                  color: selected ? Colors.white : AppColors.navyDeep,
                ),
                child: Text(label),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});

  final PlacedOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = order.service;
    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: AppColors.mist,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(s.icon, size: 24, color: AppColors.navyDeep),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'oleh ${s.seller}',
                    style: AppText.subtitle.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      OrderStatusChip(status: order.status),
                      const Spacer(),
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
          ],
        ),
      ),
    );
  }
}
