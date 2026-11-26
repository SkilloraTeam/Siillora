import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import '../catalog/service_detail_page.dart';
import '../catalog/service_model.dart';
import 'favorites_store.dart';

/// Layar 36: jasa favorit.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FavoritesStore.instance,
      builder: (context, _) {
        final items = FavoritesStore.instance.services;
        return FlowScaffold(
          title: 'Favorit',
          subtitle: 'Jasa yang kamu simpan',
          children: [
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    'Belum ada favorit.\nKetuk ikon hati di halaman jasa untuk menyimpannya.',
                    textAlign: TextAlign.center,
                    style: AppText.subtitle,
                  ),
                ),
              ),
            for (var i = 0; i < items.length; i++)
              Padding(
                key: ValueKey(items[i].id),
                padding: const EdgeInsets.only(bottom: 10),
                child: Reveal(
                  index: i,
                  child: _FavoriteCard(
                    service: items[i],
                    onTap: () => Navigator.push(
                      context,
                      appRoute(ServiceDetailPage(service: items[i])),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.service, required this.onTap});

  final Service service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.mist,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.favorite_border_rounded, size: 22, color: AppColors.navyDeep),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 56,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.label.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 1),
                    Text('oleh ${service.seller}', style: AppText.subtitle.copyWith(fontSize: 11)),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        formatRupiah(service.price),
                        style: AppText.label.copyWith(fontSize: 12),
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
