import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/navigation/shell_bus.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/auth_header.dart';
import '../../core/widgets/success_mark.dart';
import 'placed_order.dart';

/// Layar 16: konfirmasi setelah pesanan terkirim.
class OrderSentPage extends StatelessWidget {
  const OrderSentPage({super.key, required this.order});

  final PlacedOrder order;

  void _home(BuildContext context) =>
      Navigator.of(context).popUntil((r) => r.isFirst);

  void _seeOrders(BuildContext context) {
    _home(context);
    ShellBus.requestOrders();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: AuthHeader(
                  title: 'Pesanan terkirim',
                  subtitle: 'Permintaanmu sudah dikirim',
                  onBack: () => _home(context),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SuccessMark(),
                      const SizedBox(height: 28),
                      Reveal(
                        index: 6,
                        child: Column(
                          children: [
                            Text('Pesanan berhasil dikirim!', style: AppText.sectionTitle),
                            const SizedBox(height: 6),
                            Text(
                              'Penyedia jasa akan meninjau permintaanmu.',
                              textAlign: TextAlign.center,
                              style: AppText.subtitle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      Reveal(
                        index: 8,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Order ID',
                                      style: AppText.subtitle.copyWith(fontSize: 11),
                                    ),
                                  ),
                                  Text(
                                    order.displayId,
                                    style: AppText.label.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                order.service.title,
                                style: AppText.label.copyWith(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Column(
                  children: [
                    PrimaryButton(
                      label: 'LIHAT PESANAN',
                      onPressed: () => _seeOrders(context),
                    ),
                    const SizedBox(height: 4),
                    AppTextLink(label: 'Kembali ke beranda', onTap: () => _home(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
