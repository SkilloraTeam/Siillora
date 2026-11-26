import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import '../help/policy_page.dart';

/// Layar 43: informasi aplikasi.
class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  // TODO: ambil dari package_info_plus.
  static const _version = '1.0.0';

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Informasi aplikasi',
      subtitle: 'Ruang Karya',
      children: [
        Reveal(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 96,
                  height: 96,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: AppColors.mist, shape: BoxShape.circle),
                  child: Text(
                    'R',
                    style: AppText.title.copyWith(fontSize: 38, color: AppColors.navyDeep),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Ruang Karya', style: AppText.title),
                const SizedBox(height: 2),
                Text('Marketplace Jasa Mahasiswa', style: AppText.subtitle),
              ],
            ),
          ),
        ),
        const SizedBox(height: 26),
        Reveal(
          index: 1,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Versi aplikasi', style: AppText.label.copyWith(fontSize: 12)),
                    ),
                    Text(_version, style: AppText.label.copyWith(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Dibuat untuk kolaborasi dan kreativitas.',
                  style: AppText.subtitle.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Reveal(
          index: 2,
          child: _LinkRow(
            'Syarat & ketentuan',
            () => Navigator.push(context, appRoute(const TermsPage())),
          ),
        ),
        const SizedBox(height: 8),
        Reveal(
          index: 3,
          child: _LinkRow(
            'Kebijakan privasi',
            () => Navigator.push(context, appRoute(const PrivacyPage())),
          ),
        ),
      ],
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppText.label.copyWith(fontSize: 12))),
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
