import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/auth_header.dart';
import '../auth/login_page.dart';

/// Layar 42: konfirmasi keluar dari akun.
class LogoutConfirmPage extends StatelessWidget {
  const LogoutConfirmPage({super.key});

  void _logout(BuildContext context) {
    // TODO: akhiri sesi Supabase sebelum kembali ke halaman masuk.
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      appRoute<void>(const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: AuthHeader(title: 'Konfirmasi keluar', subtitle: 'Kamu yakin logout?'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Reveal(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          color: AppColors.mist,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          size: 34,
                          color: AppColors.navyDeep,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Reveal(
                      index: 1,
                      child: Column(
                        children: [
                          Text(
                            'Keluar dari akun Ruang Karya?',
                            textAlign: TextAlign.center,
                            style: AppText.sectionTitle,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Kamu perlu masuk kembali untuk mengakses akun.',
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
              child: Column(
                children: [
                  PrimaryButton(label: 'YA, KELUAR', onPressed: () => _logout(context)),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    label: 'BATAL',
                    tonal: true,
                    onPressed: () => Navigator.pop(context),
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
