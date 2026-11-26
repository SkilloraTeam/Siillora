import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/pressable.dart';
import '../service_model.dart';

/// Kartu jasa. Dipakai di Beranda (tanpa deskripsi singkat)
/// dan di hasil pencarian ([showTagline] true, gambar lebih besar).
class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
    this.showTagline = false,
  });

  final Service service;
  final VoidCallback onTap;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final thumb = showTagline ? 80.0 : 68.0;

    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.fieldBorder.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: thumb,
              height: thumb,
              decoration: BoxDecoration(
                color: AppColors.mist,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                service.icon,
                size: showTagline ? 28 : 26,
                color: AppColors.navyDeep,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: thumb,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.label.copyWith(fontSize: 14),
                    ),
                    if (showTagline) ...[
                      const SizedBox(height: 2),
                      Text(
                        service.tagline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.subtitle.copyWith(fontSize: 11.5),
                      ),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      'oleh ${service.seller}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.subtitle.copyWith(fontSize: 11.5),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        formatRupiah(service.price),
                        style: AppText.label.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
