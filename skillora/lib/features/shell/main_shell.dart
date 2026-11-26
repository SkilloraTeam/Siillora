import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/motion/motion.dart';
import '../catalog/category_page.dart';
import '../home/home_page.dart';

/// Kerangka setelah login: 5 tab + bottom navigation.
/// Halaman tiap tab tetap dibuat di file sendiri; yang belum jadi
/// memakai [_ComingSoon] sebagai pengganti.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _items = [
    NavItem('Beranda', Icons.home_outlined, Icons.home_rounded),
    NavItem('Kategori', Icons.grid_view_outlined, Icons.grid_view_rounded),
    NavItem('Bayar', Icons.payments_outlined, Icons.payments_rounded),
    NavItem('Chat', Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded),
    NavItem('Akun', Icons.person_outline_rounded, Icons.person_rounded),
  ];

  final _categoryNav = GlobalKey<NavigatorState>();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            // TODO: ganti nama dengan data profil dari Supabase.
            HomePage(
              userName: 'Sara',
              onOpenProfile: () => _go(4),
              onOpenCategories: () => _go(1),
            ),
            // Tab Kategori punya Navigator sendiri supaya hasil pencarian
            // tetap menampilkan bottom navigation, seperti di desain.
            NavigatorPopHandler(
              enabled: _index == 1,
              onPop: () {
                final nav = _categoryNav.currentState;
                if (nav != null && nav.canPop()) {
                  nav.pop();
                } else {
                  _go(0);
                }
              },
              child: Navigator(
                key: _categoryNav,
                onGenerateRoute: (_) =>
                    appRoute<void>(CategoryPage(onBack: () => _go(0))),
              ),
            ),
            const _ComingSoon(title: 'Bayar'),
            const _ComingSoon(title: 'Chat'),
            const _ComingSoon(title: 'Akun'),
          ],
        ),
        bottomNavigationBar: AppBottomNav(
          items: _items,
          currentIndex: _index,
          onChanged: _go,
        ),
      ),
    );
  }

  void _go(int i) {
    if (i != _index) setState(() => _index = i);
  }
}

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppText.title),
            const SizedBox(height: 6),
            Text(
              'Halaman ini belum dibuat.',
              style: AppText.subtitle.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
