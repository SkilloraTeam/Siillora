import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import '../favorites/favorites_page.dart';
import '../help/help_center_page.dart';
import '../help/policy_page.dart';
import '../orders/order_history_page.dart';
import '../payments/payment_history_page.dart';
import 'account_store.dart';
import 'app_info_page.dart';
import 'logout_confirm_page.dart';
import 'edit_profile_page.dart';
import 'switch_account_page.dart';

/// Layar 33: akun pengguna (tab Akun).
class AccountPage extends StatelessWidget {
  const AccountPage({super.key, this.onBack});

  final VoidCallback? onBack;

  void _open(BuildContext context, Widget page) =>
      Navigator.push(context, appRoute(page));

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Akun saya',
      subtitle: 'Kelola profil dan preferensi',
      onBack: onBack,
      children: [
        Reveal(
          child: ListenableBuilder(
            listenable: AccountStore.instance,
            builder: (context, _) => _ProfileCard(
              account: AccountStore.instance.active,
              onEdit: () => _open(context, const EditProfilePage()),
            ),
          ),
        ),
        const SizedBox(height: 22),
        Reveal(index: 1, child: Text('Akun saya', style: AppText.sectionTitle)),
        const SizedBox(height: 10),
        Reveal(
          index: 2,
          child: _Group(
            rows: [
              _MenuRow(Icons.swap_horiz_rounded, 'Ganti akun',
                  () => _open(context, const SwitchAccountPage())),
              _MenuRow(Icons.favorite_border_rounded, 'Favorit',
                  () => _open(context, const FavoritesPage())),
              _MenuRow(Icons.inventory_2_outlined, 'Riwayat pesanan',
                  () => _open(context, const OrderHistoryPage())),
              _MenuRow(Icons.receipt_long_outlined, 'Riwayat pembayaran',
                  () => _open(context, const PaymentHistoryPage())),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Reveal(index: 3, child: Text('Bantuan & informasi', style: AppText.sectionTitle)),
        const SizedBox(height: 10),
        Reveal(
          index: 4,
          child: _Group(
            rows: [
              _MenuRow(Icons.help_outline_rounded, 'Pusat bantuan',
                  () => _open(context, const HelpCenterPage())),
              _MenuRow(Icons.shield_outlined, 'Kebijakan & privasi',
                  () => _open(context, const PrivacyPage())),
              _MenuRow(Icons.info_outline_rounded, 'Informasi aplikasi',
                  () => _open(context, const AppInfoPage())),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Reveal(
          index: 5,
          child: Pressable(
            onTap: () => _open(context, const LogoutConfirmPage()),
            scale: 0.98,
            child: Container(
              width: double.infinity,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFBE7E5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.logout_rounded, size: 17, color: AppColors.error),
                  const SizedBox(width: 8),
                  Text(
                    'Keluar',
                    style: AppText.label.copyWith(fontSize: 13, color: AppColors.error),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.account, required this.onEdit});

  final Account account;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navyDeep, AppColors.navyRing],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.mist, shape: BoxShape.circle),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                account.initial,
                key: ValueKey(account.initial),
                style: AppText.title.copyWith(color: AppColors.navyDeep, fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (c, a) => FadeTransition(opacity: a, child: c),
                  layoutBuilder: (cur, prev) => Stack(
                    alignment: Alignment.centerLeft,
                    children: [...prev, ?cur],
                  ),
                  child: Column(
                    key: ValueKey(account.id + account.name + account.email),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.sectionTitle.copyWith(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        account.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.onDarkBody,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Pressable(
                  onTap: onEdit,
                  scale: 0.95,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.mist,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Edit profil',
                      style: AppText.label.copyWith(fontSize: 11, color: AppColors.navyDeep),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuRow {
  const _MenuRow(this.icon, this.label, this.onTap);

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _Group extends StatelessWidget {
  const _Group({required this.rows});

  final List<_MenuRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final r in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Pressable(
              onTap: r.onTap,
              scale: 0.98,
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: AppColors.mist,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(r.icon, size: 16, color: AppColors.navyDeep),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(r.label, style: AppText.label.copyWith(fontSize: 12.5)),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
