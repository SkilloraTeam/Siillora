import 'package:flutter/material.dart';
import '../theme/app_text.dart';
import 'app_buttons.dart';

/// Kepala halaman: tombol kembali + judul + subjudul.
/// Dipakai di hampir semua halaman non-beranda.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BackPill(onTap: onBack),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.title),
              const SizedBox(height: 2),
              Text(subtitle, style: AppText.subtitle),
            ],
          ),
        ),
      ],
    );
  }
}
