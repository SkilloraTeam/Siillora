import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/navigation/shell_bus.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/auth_header.dart';
import '../../core/widgets/success_mark.dart';

/// Layar 26: konfirmasi ulasan terkirim.
class ReviewSentPage extends StatelessWidget {
  const ReviewSentPage({super.key});

  void _home(BuildContext context) {
    Navigator.of(context).popUntil((r) => r.isFirst);
    ShellBus.requestHome();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: AuthHeader(
                  title: 'Ulasan terkirim',
                  subtitle: 'Terima kasih atas penilaianmu',
                  onBack: () => Navigator.of(context).pop(),
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
                            Text('Ulasan berhasil dikirim', style: AppText.sectionTitle),
                            const SizedBox(height: 6),
                            Text(
                              'Masukanmu membantu komunitas Ruang Karya.',
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
                  label: 'KEMBALI KE BERANDA',
                  onPressed: () => _home(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
