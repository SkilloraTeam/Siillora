import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'pressable.dart';

/// Kolom yang membuka halaman pilihan saat diketuk (tanggal, dsb).
/// Gayanya sama dengan [AppTextField]; border berubah saat ada error.
class AppPickerField extends StatelessWidget {
  const AppPickerField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.onTap,
    this.value,
    this.icon = Icons.calendar_today_outlined,
    this.errorText,
    this.fillColor = AppColors.card,
  });

  final String label;
  final String placeholder;
  final String? value;
  final IconData icon;
  final String? errorText;
  final VoidCallback onTap;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.label),
        const SizedBox(height: 6),
        Pressable(
          onTap: onTap,
          scale: 0.99,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError ? AppColors.error : AppColors.fieldBorder,
                width: hasError ? 1.6 : 1.1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 17, color: hasValue ? AppColors.navyDeep : AppColors.textHint),
                const SizedBox(width: 10),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, anim) =>
                        FadeTransition(opacity: anim, child: child),
                    layoutBuilder: (current, previous) => Stack(
                      alignment: Alignment.centerLeft,
                      children: [...previous, ?current],
                    ),
                    child: Text(
                      value ?? placeholder,
                      key: ValueKey(value ?? placeholder),
                      style: hasValue ? AppText.input : AppText.hint,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: Alignment.topLeft,
          child: hasError
              ? Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(errorText!, style: AppText.error),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}
