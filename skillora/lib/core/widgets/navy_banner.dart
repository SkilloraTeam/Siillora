import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Kartu navy bergradasi untuk pembuka halaman (Pusat bantuan, Kebijakan).
class NavyBanner extends StatelessWidget {
  const NavyBanner({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navyDeep, AppColors.navyRing],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppText.sectionTitle.copyWith(color: Colors.white, fontSize: 16),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: AppText.onDarkBody),
          ],
        ],
      ),
    );
  }
}
