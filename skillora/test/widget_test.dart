import 'package:flutter_test/flutter_test.dart';
import 'package:skillora/main.dart';

void main() {
  testWidgets('halaman login tampil', (tester) async {
    await tester.pumpWidget(const SkilloraApp());
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Selamat datang!'), findsOneWidget);
    expect(find.text('MASUK'), findsOneWidget);
  });
}
