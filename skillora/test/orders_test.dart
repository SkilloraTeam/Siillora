import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skillora/core/theme/app_theme.dart';
import 'package:skillora/features/catalog/service_repository.dart';
import 'package:skillora/features/order/order_model.dart';
import 'package:skillora/features/order/placed_order.dart';
import 'package:skillora/features/orders/order_detail_page.dart';
import 'package:skillora/features/orders/orders_page.dart';

Widget _app(Widget home) => MaterialApp(theme: AppTheme.light, home: home);

void main() {
  test('pesanan baru berstatus menunggu dan mendapat nomor berurutan', () {
    final draft = OrderDraft(
      service: ServiceRepository.byId('s1'),
      message: 'Desain aplikasi pemesanan makanan',
      deadline: DateTime(2026, 12, 1),
    );
    final a = OrderStore.instance.add(draft);
    final b = OrderStore.instance.add(draft);

    expect(a.status, OrderStatus.menunggu);
    expect(a.id.startsWith('ORD-'), isTrue);
    expect(a.id == b.id, isFalse);
    expect(OrderStore.instance.orders.first.id, b.id);
  });

  testWidgets('daftar pesanan: filter Selesai hanya menampilkan yang selesai',
      (tester) async {
    await tester.pumpWidget(_app(const OrdersPage()));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Desain Poster Acara'), findsOneWidget);
    expect(find.text('Website Portofolio'), findsOneWidget);

    await tester.tap(find.text('Selesai').first);
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Desain Poster Acara'), findsOneWidget);
    expect(find.text('Website Portofolio'), findsNothing);
  });

  testWidgets('detail pesanan dikerjakan menampilkan tombol selesaikan',
      (tester) async {
    await tester.pumpWidget(_app(const OrderDetailPage(orderId: 'ORD-015')));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Order ID #ORD-015'), findsOneWidget);
    expect(find.text('Sedang dikerjakan'), findsOneWidget);
    expect(find.text('SELESAIKAN PESANAN'), findsOneWidget);
    expect(find.text('AJUKAN REVISI'), findsOneWidget);
  });
}
