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

/// Layar 37: pesanan yang sudah selesai.
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: OrderStore.instance,
      builder: (context, _) {
        final items = [
          for (final o in OrderStore.instance.orders) o,
        ];
        return FlowScaffold(
          title: 'Riwayat pesanan',
          subtitle: 'Semua pesanan sebelumnya',
          children: [
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Text('Belum ada pesanan.', style: AppText.subtitle),
                ),
              ),
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Reveal(
                  index: i,
                  child: Pressable(
                    onTap: () => Navigator.push(
                      context,
                      appRoute(OrderDetailPage(orderId: items[i].id)),
                    ),
                    scale: 0.98,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.fieldBorder.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[i].service.title,
                            style: AppText.label.copyWith(fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              OrderStatusChip(status: items[i].status),
                              const Spacer(),
                              Text(
                                items[i].price == null
                                    ? 'Menunggu harga'
                                    : formatRupiah(items[i].price!),
                                style: AppText.label.copyWith(fontSize: 11.5),
                              ),
                            ],
                          ),
                        ],
                      ),
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
