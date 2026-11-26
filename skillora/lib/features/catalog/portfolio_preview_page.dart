import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/auth_header.dart';
import 'service_model.dart';

/// Pratinjau portofolio. Kolase di atas masih ilustrasi bawaan karena
/// belum ada file asli.
/// TODO: ganti [_Collage] dengan halaman PDF / gambar dari Supabase Storage.
class PortfolioPreviewPage extends StatefulWidget {
  const PortfolioPreviewPage({super.key, required this.service});

  final Service service;

  @override
  State<PortfolioPreviewPage> createState() => _PortfolioPreviewPageState();
}

class _PortfolioPreviewPageState extends State<PortfolioPreviewPage>
    with SingleTickerProviderStateMixin {
  // Tiga panel kolase muncul bergantian, sekali saja.
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
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

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    final items = s.portfolioItems;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: AuthHeader(
                title: 'Portofolio ${s.sellerFirstName}',
                subtitle: 'Contoh hasil pekerjaan',
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Collage(label: s.portfolioLabel, intro: _intro),
                    const SizedBox(height: 16),
                    Text(
                      s.portfolioFile,
                      style: AppText.sectionTitle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    // TODO: ambil jumlah halaman & ukuran dari metadata file.
                    Text('PDF • 6 halaman • 3,2 MB', style: AppText.subtitle),
                    const SizedBox(height: 18),
                    Text('Deskripsi karya', style: AppText.sectionTitle),
                    const SizedBox(height: 10),
                    for (var i = 0; i < items.length; i++) ...[
                      if (i > 0) const SizedBox(height: 12),
                      Text(
                        items.length > 1
                            ? '${i + 1}. ${items[i].title}'
                            : items[i].title,
                        style: AppText.label.copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].description,
                        style: AppText.body.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: PrimaryButton(
                label: 'KEMBALI KE DETAIL JASA',
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Collage extends StatelessWidget {
  const _Collage({required this.label, required this.intro});

  final String label;
  final Animation<double> intro;

  Widget _pop(double begin, double end, Widget child) {
    final a = CurvedAnimation(
      parent: intro,
      curve: Interval(begin, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: a,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.94, end: 1).animate(a),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppText.label.copyWith(
                fontSize: 9.5,
                letterSpacing: 0.6,
                color: AppColors.link,
              ),
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1.38,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                          child: _pop(
                            0.0,
                            0.55,
                            const _Panel(
                              color: Color(0xFFCBD9C6),
                              accent: Color(0xFF4F7A57),
                              phones: 3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: _pop(
                            0.2,
                            0.75,
                            const _Panel(
                              color: Color(0xFFF1E4DC),
                              accent: Color(0xFF9B2B2B),
                              phones: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _pop(
                      0.4,
                      1.0,
                      const _Panel(
                        color: Color(0xFF4A3830),
                        accent: Color(0xFFE08A2E),
                        phones: 2,
                        dark: true,
                        vertical: true,
                      ),
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

/// Panel berisi beberapa tampilan ponsel sederhana.
class _Panel extends StatelessWidget {
  const _Panel({
    required this.color,
    required this.accent,
    required this.phones,
    this.dark = false,
    this.vertical = false,
  });

  final Color color;
  final Color accent;
  final int phones;
  final bool dark;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final children = [
      for (var i = 0; i < phones; i++)
        Expanded(child: _Phone(accent: accent, dark: dark)),
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: vertical
          ? Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) const SizedBox(height: 6),
                  children[i],
                ],
              ],
            )
          : Row(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  children[i],
                ],
              ],
            ),
    );
  }
}

class _Phone extends StatelessWidget {
  const _Phone({required this.accent, required this.dark});

  final Color accent;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final screen = dark ? const Color(0xFF2E221C) : Colors.white;
    final bar = dark ? Colors.white.withValues(alpha: 0.7) : AppColors.navyDeep;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: screen,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: dark ? const Color(0xFF6B5448) : AppColors.navyDeep,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 3,
            decoration: BoxDecoration(
              color: bar,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: bar.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: 22,
            height: 3,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
