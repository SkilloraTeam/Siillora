import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skillora/core/theme/app_theme.dart';
import 'package:skillora/features/order/placed_order.dart';
import 'package:skillora/features/orders/result_page.dart';
import 'package:skillora/features/orders/review_page.dart';
import 'package:skillora/features/orders/revision_form_page.dart';

Widget _app(Widget home) => MaterialApp(theme: AppTheme.light, home: home);

void main() {
  final order = OrderStore.instance.byId('ORD-015')!;

  testWidgets('form revisi menolak isian kosong', (tester) async {
    await tester.pumpWidget(_app(RevisionFormPage(order: order)));
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('KIRIM PERMINTAAN REVISI'));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Jelaskan bagian yang ingin direvisi.'), findsOneWidget);
  });

  testWidgets('ulasan: bintang dipilih menampilkan label', (tester) async {
    await tester.pumpWidget(_app(ReviewPage(order: order)));
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.bySemanticsLabel('Beri 4 bintang'));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Sangat baik'), findsOneWidget);
  });

  testWidgets('halaman hasil menampilkan berkas dan catatan', (tester) async {
    await tester.pumpWidget(_app(ResultPage(order: order)));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Hasil_Desain.pdf'), findsOneWidget);
    expect(find.text('Catatan penyedia jasa'), findsOneWidget);
  });
}
