import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/navigation/shell_bus.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/auth_header.dart';
import '../../core/widgets/success_mark.dart';
import '../order/placed_order.dart';

/// Layar 23: konfirmasi revisi terkirim. Tombol kembali menuju detail pesanan.
class RevisionSentPage extends StatelessWidget {
  const RevisionSentPage({super.key, required this.order});

  final PlacedOrder order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: AuthHeader(
                title: 'Revisi terkirim',
                subtitle: 'Penyedia jasa akan merespons revisimu',
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
                          Text('Permintaan revisi terkirim', style: AppText.sectionTitle),
                          const SizedBox(height: 6),
                          Text(
                            'Kamu dapat melanjutkan diskusi melalui chat.',
                            textAlign: TextAlign.center,
                            style: AppText.subtitle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: PrimaryButton(
                label: 'CHAT DENGAN PENYEDIA JASA',
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .popUntil((r) => r.isFirst);
                  ShellBus.requestChat(order.service.seller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
