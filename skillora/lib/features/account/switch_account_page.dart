import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import 'account_store.dart';

/// Layar 35: pilih akun yang sedang dipakai.
class SwitchAccountPage extends StatelessWidget {
  const SwitchAccountPage({super.key});

  void _switch(BuildContext context, Account a) {
    if (a.id == AccountStore.instance.active.id) return;
    AccountStore.instance.switchTo(a.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Sekarang memakai ${a.name}.')));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AccountStore.instance,
      builder: (context, _) {
        final store = AccountStore.instance;
        return FlowScaffold(
          title: 'Ganti akun',
          subtitle: 'Pilih yang ingin digunakan',
          bottom: SecondaryButton(
            label: 'TAMBAHKAN AKUN',
            onPressed: () {
              // TODO: buka alur masuk untuk akun kedua.
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Tambah akun belum tersedia.')),
                );
            },
          ),
          children: [
            for (var i = 0; i < store.accounts.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Reveal(
                  index: i,
                  child: _AccountTile(
                    account: store.accounts[i],
                    selected: store.accounts[i].id == store.active.id,
                    onTap: () => _switch(context, store.accounts[i]),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    required this.account,
    required this.selected,
    required this.onTap,
  });

  final Account account;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${account.name}, ${selected ? 'sedang dipakai' : 'ketuk untuk beralih'}',
      child: Pressable(
        onTap: onTap,
        scale: 0.98,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? AppColors.mist : AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? Colors.transparent : AppColors.fieldBorder.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.card : AppColors.mist,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  account.initial,
                  style: AppText.label.copyWith(fontSize: 15, color: AppColors.navyDeep),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.name, style: AppText.label.copyWith(fontSize: 13)),
                    const SizedBox(height: 1),
                    Text(
                      account.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.subtitle.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeOutBack,
                transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                child: selected
                    ? const Icon(Icons.check_rounded,
                        key: ValueKey('on'), size: 20, color: AppColors.navyDeep)
                    : const Icon(Icons.chevron_right_rounded,
                        key: ValueKey('off'), size: 20, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
