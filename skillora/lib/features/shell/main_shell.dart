import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/motion/motion.dart';
import '../../core/navigation/shell_bus.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../account/account_page.dart';
import '../account/account_store.dart';
import '../catalog/category_page.dart';
import '../chat/chat_detail_page.dart';
import '../chat/chat_list_page.dart';
import '../chat/chat_store.dart';
import '../home/home_page.dart';
import '../orders/orders_page.dart';
import '../payments/payments_page.dart';

/// Kerangka setelah login: 5 tab + bottom navigation.
/// Tab Kategori dan Chat punya Navigator sendiri supaya halaman turunannya
/// (hasil pencarian, ruang chat) tetap menampilkan bottom navigation.
/// Halaman lain (detail pembayaran, edit profil, dst.) dibuka di Navigator
/// utama dan menutupi bottom navigation, sesuai desain.
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
  final _chatNav = GlobalKey<NavigatorState>();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    ShellBus.openOrders.addListener(_showOrders);
    ShellBus.openHome.addListener(_showHome);
    ShellBus.openChat.addListener(_showChat);
  }

  @override
  void dispose() {
    ShellBus.openOrders.removeListener(_showOrders);
    ShellBus.openHome.removeListener(_showHome);
    ShellBus.openChat.removeListener(_showChat);
    super.dispose();
  }

  /// Dipanggil dari layar "Pesanan terkirim": buka daftar pesanan di tab
  /// Kategori (sesuai desain, tab Kategori yang menyala).
  void _showOrders() {
    setState(() => _index = 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nav = _categoryNav.currentState;
      if (nav == null) return;
      nav.popUntil((r) => r.isFirst);
      nav.push(appRoute<void>(const OrdersPage()));
    });
  }

  void _showHome() => setState(() => _index = 0);

  /// Buka tab Chat. Kalau ada nama penyedia jasa, langsung masuk ke
  /// percakapannya (dibuat baru bila belum ada).
  void _showChat() {
    final seller = ShellBus.chatSeller;
    ShellBus.chatSeller = null;
    setState(() => _index = 3);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nav = _chatNav.currentState;
      if (nav == null) return;
      nav.popUntil((r) => r.isFirst);
      if (seller != null) {
        nav.push(appRoute<void>(
          ChatDetailPage(conversation: ChatStore.instance.forSeller(seller)),
        ));
      }
    });
  }

  Widget _nested(int tab, GlobalKey<NavigatorState> key, Widget Function() root) {
    return NavigatorPopHandler(
      enabled: _index == tab,
      onPop: () {
        final nav = key.currentState;
        if (nav != null && nav.canPop()) {
          nav.pop();
        } else {
          _go(0);
        }
      },
      child: Navigator(
        key: key,
        onGenerateRoute: (_) => appRoute<void>(root()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Saat keyboard terbuka (mengetik chat atau mencari), bottom navigation
    // disembunyikan supaya tidak ikut terdorong ke atas.
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            ListenableBuilder(
              listenable: AccountStore.instance,
              builder: (context, _) => HomePage(
                userName: AccountStore.instance.active.firstName,
                onOpenProfile: () => _go(4),
                onOpenCategories: () => _go(1),
              ),
            ),
            _nested(1, _categoryNav, () => CategoryPage(onBack: () => _go(0))),
            PaymentsPage(onBack: () => _go(0)),
            _nested(3, _chatNav, () => ChatListPage(onBack: () => _go(0))),
            AccountPage(onBack: () => _go(0)),
          ],
        ),
        bottomNavigationBar: keyboardOpen
            ? null
            : AppBottomNav(
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
