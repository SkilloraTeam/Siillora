import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'pressable.dart';

/// Tombol utama navy. Mengecil sedikit saat ditekan, label berganti
/// spinner saat [loading], dan memudar saat [onPressed] null.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.loading;

    return Semantics(
      button: true,
      enabled: enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _set(true) : null,
        onTapUp: enabled ? (_) => _set(false) : null,
        onTapCancel: () => _set(false),
        onTap: enabled ? widget.onPressed : null,
        child: AnimatedScale(
          scale: _down ? 0.98 : 1,
          duration: const Duration(milliseconds: 90),
          child: AnimatedOpacity(
            opacity: widget.onPressed == null ? 0.45 : 1,
            duration: const Duration(milliseconds: 200),
            child: Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.navyDeep,
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: widget.loading
                    ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        widget.label,
                        key: ValueKey(widget.label),
                        style: AppText.button,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Link teks biru. Isi [onTap] dengan null untuk menonaktifkan.
class AppTextLink extends StatelessWidget {
  const AppTextLink({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        minimumSize: const Size(44, 44),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        foregroundColor: AppColors.link,
        disabledForegroundColor: AppColors.textMuted,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: AppText.link.copyWith(
          color: onTap == null ? AppColors.textMuted : AppColors.link,
        ),
      ),
    );
  }
}

/// Kalimat + aksi, misalnya "Belum punya akun? Daftar".
class AppPromptLink extends StatelessWidget {
  const AppPromptLink({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          minimumSize: const Size(44, 44),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          foregroundColor: AppColors.link,
        ),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: prompt, style: AppText.subtitle),
              TextSpan(text: action, style: AppText.link),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tombol kembali bulat putih di kiri atas.
class BackPill extends StatelessWidget {
  const BackPill({super.key, this.onTap});

  /// Kalau null, memanggil Navigator.maybePop.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Kembali',
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap ?? () => Navigator.maybePop(context),
              child: const SizedBox(
                width: 34,
                height: 34,
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 22,
                  color: AppColors.navyDeep,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tombol sekunder: kartu terang, teks navy. Dipakai berdampingan dengan
/// [PrimaryButton] untuk aksi yang tidak utama, mis. "EDIT PESANAN".
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.tonal = false,
  });

  final String label;
  final VoidCallback? onPressed;

  /// true: isi biru muda tanpa garis (gaya "AJUKAN REVISI").
  final bool tonal;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: onPressed == null ? 0.45 : 1,
      duration: const Duration(milliseconds: 200),
      child: Pressable(
        onTap: onPressed,
        scale: 0.98,
        child: Container(
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tonal ? AppColors.mist : AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: tonal
                ? null
                : Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.6)),
          ),
          child: Text(label, style: AppText.button.copyWith(color: AppColors.navyDeep)),
        ),
      ),
    );
  }
}
