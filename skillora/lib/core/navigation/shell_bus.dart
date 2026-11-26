import 'package:flutter/foundation.dart';

/// Jembatan kecil supaya halaman di luar [MainShell] (mis. layar
/// "Pesanan terkirim") bisa meminta shell berpindah tab.
abstract final class ShellBus {
  static final openOrders = ValueNotifier<int>(0);
  static final openHome = ValueNotifier<int>(0);
  static final openChat = ValueNotifier<int>(0);

  /// Nama penyedia jasa yang ingin diajak chat. null = hanya buka daftar chat.
  static String? chatSeller;

  static void requestOrders() => openOrders.value++;

  static void requestHome() => openHome.value++;

  static void requestChat([String? seller]) {
    chatSeller = seller;
    openChat.value++;
  }
}
