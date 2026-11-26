import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/pressable.dart';
import '../catalog/search_results_page.dart';
import '../catalog/service_detail_page.dart';
import '../catalog/service_model.dart';
import '../catalog/service_repository.dart';
import '../catalog/widgets/service_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.userName,
    this.onOpenProfile,
    this.onOpenCategories,
  });

  final String userName;
  final VoidCallback? onOpenProfile;
  final VoidCallback? onOpenCategories;

  @override
  State<HomePage> createState() => _HomePageState();
}

// ---------------------------------------------------------------------------
// Data contoh. TODO: ganti dengan data dari Supabase.
// ---------------------------------------------------------------------------

class _Category {
  const _Category(this.label, this.icon, this.category);
  final String label;
  final IconData icon;
  final ServiceCategory category;
}

const _categories = [
  _Category('Desain', Icons.auto_awesome_rounded, ServiceCategory.desain),
  _Category('Website', Icons.language_rounded, ServiceCategory.web),
  _Category('Penulisan', Icons.description_outlined, ServiceCategory.penulisan),
  _Category('Video', Icons.play_arrow_rounded, ServiceCategory.media),
];

// ---------------------------------------------------------------------------

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _recommended = ServiceRepository.recommended;

  // Satu urutan masuk saat halaman pertama dibuka: header -> banner ->
  // kategori -> rekomendasi. Tidak diulang saat pindah tab.
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final List<Animation<double>> _stages = [
    _stage(0.00, 0.50),
    _stage(0.12, 0.62),
    _stage(0.26, 0.76),
    _stage(0.40, 1.00),
  ];

  bool _introStarted = false;

  Animation<double> _stage(double begin, double end) => CurvedAnimation(
        parent: _intro,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_introStarted) return;
    _introStarted = true;
    if (reduceMotion(context)) {
      _intro.value = 1;
    } else {
      _intro.forward();
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  void _openSearch({ServiceCategory? category, bool autofocus = false}) {
    Navigator.push(
      context,
      appRoute(SearchResultsPage(category: category, autofocus: autofocus)),
    );
  }

  void _openDetail(Service s) {
    Navigator.push(context, appRoute(ServiceDetailPage(service: s)));
  }

  Widget _reveal(int stage, Widget child) {
    final a = _stages[stage];
    return AnimatedBuilder(
      animation: a,
      builder: (context, child) => Opacity(
        opacity: a.value,
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - a.value)),
          child: child,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _reveal(
              0,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Greeting(
                    name: widget.userName,
                    onAvatarTap: widget.onOpenProfile,
                  ),
                  const SizedBox(height: 18),
                  _SearchBar(onTap: () => _openSearch(autofocus: true)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _reveal(
              1,
              _PromoBanner(onTap: _openSearch),
            ),
            const SizedBox(height: 22),
            _reveal(
              2,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Kategori populer',
                    onSeeAll: widget.onOpenCategories ?? () {},
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      for (var i = 0; i < _categories.length; i++) ...[
                        if (i > 0) const SizedBox(width: 10),
                        Expanded(
                          child: _CategoryTile(
                            category: _categories[i],
                            onTap: () =>
                                _openSearch(category: _categories[i].category),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _reveal(
              3,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Rekomendasi jasa',
                    onSeeAll: _openSearch,
                  ),
                  const SizedBox(height: 12),
                  for (var i = 0; i < _recommended.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    ServiceCard(
                      service: _recommended[i],
                      onTap: () => _openDetail(_recommended[i]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bagian-bagian halaman
// ---------------------------------------------------------------------------

class _Greeting extends StatelessWidget {
  const _Greeting({required this.name, this.onAvatarTap});

  final String name;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final initial = name.isEmpty ? '?' : String.fromCharCode(name.runes.first).toUpperCase();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selamat datang', style: AppText.subtitle),
              const SizedBox(height: 2),
              Text('Halo, $name!', style: AppText.title.copyWith(fontSize: 24)),
            ],
          ),
        ),
        Semantics(
          label: 'Buka akun',
          child: Pressable(
            onTap: onAvatarTap,
            scale: 0.92,
            child: Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.mist,
                shape: BoxShape.circle,
              ),
              child: Text(
                initial,
                style: AppText.sectionTitle.copyWith(fontSize: 19),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.985,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.fieldBorder, width: 1.1),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, size: 20, color: AppColors.sky),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Cari jasa, keahlian, mahasiswa...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.hint.copyWith(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PUNYA PROYEK?', style: AppText.brand.copyWith(fontSize: 10)),
          const SizedBox(height: 8),
          Text(
            'Temukan partner\nkreatif dari kampusmu.',
            style: AppText.headline.copyWith(fontSize: 20, letterSpacing: -0.3),
          ),
          const SizedBox(height: 14),
          Pressable(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.mist,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Jelajahi jasa',
                style: AppText.label.copyWith(
                  fontSize: 12,
                  color: AppColors.navyDeep,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onSeeAll});

  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: AppText.sectionTitle.copyWith(fontSize: 16)),
        ),
        Pressable(
          onTap: onSeeAll,
          scale: 0.95,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Lihat semua', style: AppText.link.copyWith(fontSize: 11.5)),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: AppColors.link,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final _Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.fieldBorder.withValues(alpha: 0.6),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.navyRing,
                shape: BoxShape.circle,
              ),
              child: Icon(category.icon, size: 18, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              category.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.label.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
