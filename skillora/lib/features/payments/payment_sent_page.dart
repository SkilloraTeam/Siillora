import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/navigation/shell_bus.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/auth_header.dart';
import '../../core/widgets/success_mark.dart';
import 'payment_model.dart';

/// Layar 30: konfirmasi bukti pembayaran terkirim.
class PaymentSentPage extends StatelessWidget {
  const PaymentSentPage({super.key, required this.orderId});

  final String orderId;

  void _back(BuildContext context) =>
      Navigator.of(context).popUntil((r) => r.isFirst);

  void _seeOrders(BuildContext context) {
    _back(context);
    ShellBus.requestOrders();
  }

  @override
  Widget build(BuildContext context) {
    final p = PaymentStore.instance.byOrder(orderId);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: AuthHeader(
                  title: 'Pembayaran terkirim',
                  subtitle: 'Bukti transfer sedang diverifikasi',
                  onBack: () => _back(context),
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
                            Text('Bukti pembayaran terkirim', style: AppText.sectionTitle),
                            const SizedBox(height: 6),
                            Text(
                              'Pesananmu diproses setelah pembayaran diverifikasi.',
                              textAlign: TextAlign.center,
                              style: AppText.subtitle,
                            ),
                          ],
                        ),
                      ),
                      if (p != null) ...[
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
                              children: [
                                _Row('Order ID', p.displayOrderId),
                                const SizedBox(height: 8),
                                _Row('Total', formatRupiah(p.amount)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: PrimaryButton(
                  label: 'LIHAT PESANAN',
                  onPressed: () => _seeOrders(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppText.subtitle.copyWith(fontSize: 11))),
        Text(value, style: AppText.label.copyWith(fontSize: 12)),
      ],
    );
  }
}
