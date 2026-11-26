import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/auth_header.dart';
import '../../core/widgets/pressable.dart';
import '../../core/navigation/shell_bus.dart';
import '../favorites/favorites_store.dart';
import '../order/order_form_page.dart';
import 'portfolio_preview_page.dart';
import 'service_model.dart';

class ServiceDetailPage extends StatelessWidget {
  const ServiceDetailPage({super.key, required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: AuthHeader(
                title: 'Detail jasa',
                subtitle: 'Informasi layanan dan penyedia',
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Hero(service: service),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            service.seller,
                            style: AppText.title.copyWith(fontSize: 19),
                          ),
                        ),
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Color(0xFFE5A02B),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          service.rating.toStringAsFixed(1),
                          style: AppText.label.copyWith(
                            color: const Color(0xFFC98512),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(service.sellerInfo, style: AppText.subtitle),
                    const SizedBox(height: 22),
                    Text('Portofolio', style: AppText.sectionTitle),
                    const SizedBox(height: 10),
                    _PortfolioFile(
                      name: service.portfolioFile,
                      onTap: () => Navigator.push(
                        context,
                        appRoute(PortfolioPreviewPage(service: service)),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text('Detail jasa', style: AppText.sectionTitle),
                    const SizedBox(height: 8),
                    Text(
                      service.description,
                      style: AppText.body.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Pressable(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .popUntil((r) => r.isFirst);
                        ShellBus.requestChat(service.seller);
                      },
                      scale: 0.98,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mist,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Chat dengan ${service.seller}',
                                style: AppText.label.copyWith(
                                  fontSize: 12.5,
                                  color: AppColors.navyDeep,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: AppColors.navyDeep,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Harga mulai', style: AppText.subtitle),
                            const SizedBox(height: 2),
                            Text(
                              formatRupiah(service.price),
                              style: AppText.title.copyWith(fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                      _FavoriteButton(serviceId: service.id),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'PESAN JASA',
                    onPressed: () => Navigator.of(context, rootNavigator: true).push(
                      appRoute(OrderFormPage(service: service)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu navy di atas. Lingkaran ikon muncul dengan satu gerakan membal.
class _Hero extends StatelessWidget {
  const _Hero({required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    final still = reduceMotion(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navyDeep, Color(0xFF1F3C6A)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.mist,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    service.tagLabel,
                    style: AppText.label.copyWith(
                      fontSize: 9.5,
                      letterSpacing: 0.4,
                      color: AppColors.navyDeep,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  service.title,
                  style: AppText.headline.copyWith(fontSize: 21, letterSpacing: -0.3),
                ),
                const SizedBox(height: 8),
                Text(
                  service.heroLine,
                  style: AppText.onDarkBody.copyWith(fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: still ? 1 : 0, end: 1),
            duration: Duration(milliseconds: still ? 0 : 700),
            curve: Curves.easeOutBack,
            builder: (context, t, child) => Transform.scale(scale: t, child: child),
            child: Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: AppColors.sky,
                shape: BoxShape.circle,
              ),
              child: Icon(service.icon, size: 34, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioFile extends StatelessWidget {
  const _PortfolioFile({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            const Icon(Icons.picture_as_pdf_outlined, size: 18, color: AppColors.sky),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.link.copyWith(fontSize: 12.5),
              ),
            ),
            const Icon(Icons.north_east_rounded, size: 16, color: AppColors.link),
          ],
        ),
      ),
    );
  }
}

/// Hati di samping harga. Mengisi dengan sedikit membal saat ditandai.
class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.serviceId});

  final String serviceId;

  @override
  Widget build(BuildContext context) {
    final store = FavoritesStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final on = store.contains(serviceId);
        return Semantics(
          button: true,
          toggled: on,
          label: on ? 'Hapus dari favorit' : 'Simpan ke favorit',
          child: Pressable(
            onTap: () => store.toggle(serviceId),
            scale: 0.9,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutBack,
                  transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                  child: Icon(
                    on ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    key: ValueKey(on),
                    size: 26,
                    color: on ? AppColors.navyDeep : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
