import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/format.dart';
import '../order_model.dart';

/// Lencana ekstensi file (PDF / PNG / JPG). PDF navy, gambar biru.
class ExtBadge extends StatelessWidget {
  const ExtBadge({super.key, required this.ext, this.size = 38});

  final String ext;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isPdf = ext == 'PDF';
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isPdf ? AppColors.navyDeep : AppColors.sky,
        shape: BoxShape.circle,
      ),
      child: Text(
        ext.length > 4 ? ext.substring(0, 4) : ext,
        style: AppText.label.copyWith(
          fontSize: size * 0.24,
          letterSpacing: 0.2,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Baris berkas ringkas: lencana, nama, ukuran, dan aksi opsional di kanan.
class FileRow extends StatelessWidget {
  const FileRow({super.key, required this.file, this.trailing});

  final Attachment file;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          ExtBadge(ext: file.ext, size: 34),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.label.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 1),
                Text(
                  formatUkuranFile(file.sizeBytes),
                  style: AppText.subtitle.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Muncul dengan skala + fade saat pertama dipasang. Dipakai untuk berkas
/// yang baru ditambahkan.
class PopIn extends StatelessWidget {
  const PopIn({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.scale(
          scale: 0.96 + 0.04 * t,
          alignment: Alignment.topCenter,
          child: child,
        ),
      ),
      child: child,
    );
  }
}
