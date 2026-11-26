import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skillora/core/theme/app_theme.dart';
import 'package:skillora/core/utils/format.dart';
import 'package:skillora/features/catalog/service_repository.dart';
import 'package:skillora/features/order/date_picker_page.dart';
import 'package:skillora/features/order/order_form_page.dart';

Widget _app(Widget home) => MaterialApp(theme: AppTheme.light, home: home);

void main() {
  test('formatTanggal memakai nama bulan Indonesia', () {
    expect(formatTanggal(DateTime(2026, 11, 28)), '28 November 2026');
    expect(formatTanggal(DateTime(2027, 1, 5)), '5 Januari 2027');
  });

  test('formatUkuranFile', () {
    expect(formatUkuranFile(2516582), '2.4 MB');
    expect(formatUkuranFile(327680), '320 KB');
  });

  testWidgets('form menampilkan error bila belum diisi', (tester) async {
    await tester.pumpWidget(_app(OrderFormPage(service: ServiceRepository.byId('s1'))));
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('LANJUTKAN'));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Deskripsi kebutuhan wajib diisi.'), findsOneWidget);
    expect(find.text('Pilih estimasi tanggal selesai.'), findsOneWidget);
  });

  testWidgets('kalender: tanggal lampau tidak bisa dipilih', (tester) async {
    await tester.pumpWidget(
      _app(DatePickerPage(today: DateTime(2026, 11, 26))),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Belum dipilih'), findsOneWidget);

    await tester.tap(find.text('10'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Belum dipilih'), findsOneWidget);

    await tester.tap(find.text('28'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('28 November 2026'), findsOneWidget);
  });
}
