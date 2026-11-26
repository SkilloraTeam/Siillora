import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skillora/core/theme/app_theme.dart';
import 'package:skillora/features/account/account_store.dart';
import 'package:skillora/features/account/edit_profile_page.dart';
import 'package:skillora/features/account/switch_account_page.dart';
import 'package:skillora/features/chat/chat_detail_page.dart';
import 'package:skillora/features/chat/chat_store.dart';
import 'package:skillora/features/order/order_model.dart';
import 'package:skillora/features/payments/payment_model.dart';
import 'package:skillora/features/payments/payments_page.dart';
import 'package:skillora/features/payments/upload_proof_page.dart';

Widget _app(Widget home) => MaterialApp(theme: AppTheme.light, home: home);

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('daftar pembayaran menampilkan total dan tagihan', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_app(const PaymentsPage()));
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Rp450.000'), findsOneWidget);
    expect(find.text('Desain UI/UX Aplikasi'), findsOneWidget);
    expect(find.text('Website Portofolio'), findsOneWidget);
    expect(find.text('Belum bayar'), findsOneWidget);
    expect(find.text('Berhasil'), findsOneWidget);
  });

  testWidgets('unggah bukti: tombol aktif setelah berkas dipilih, hilang saat dihapus',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_app(UploadProofPage(
      orderId: 'ORD-015',
      picker: () async => const Attachment('bukti_qris.jpg', 1258291),
    )));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Bukti pembayaran terpilih'), findsNothing);

    await tester.tap(find.text('Pilih gambar PNG atau JPG'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Bukti pembayaran terpilih'), findsOneWidget);
    expect(find.text('bukti_qris.jpg'), findsOneWidget);

    await tester.tap(find.text('Hapus'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Bukti pembayaran terpilih'), findsNothing);
  });

  testWidgets('chat: pesan terkirim muncul di percakapan', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final convo = ChatStore.instance.items.first;
    await tester.pumpWidget(_app(ChatDetailPage(conversation: convo)));
    await tester.pump(const Duration(seconds: 1));

    await tester.enterText(find.byType(TextField), 'Baik, saya kirim revisinya.');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Kirim pesan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Baik, saya kirim revisinya.'), findsOneWidget);
  });

  testWidgets('edit profil menolak nama kosong', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_app(const EditProfilePage()));
    await tester.pump(const Duration(seconds: 1));

    await tester.enterText(find.byType(TextField).first, '');
    await tester.tap(find.text('SIMPAN PERUBAHAN'));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Nama lengkap wajib diisi.'), findsOneWidget);
  });

  testWidgets('ganti akun memindahkan tanda akun aktif', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() {
      AccountStore.instance.switchTo('a1');
      tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(_app(const SwitchAccountPage()));
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Sara Mahasiswa'));
    await tester.pump(const Duration(milliseconds: 400));

    expect(AccountStore.instance.active.name, 'Sara Mahasiswa');
  });

  test('mengirim bukti mengubah status pembayaran menjadi menunggu', () {
    final store = PaymentStore.instance;
    expect(store.byOrder('ORD-015')!.status, PaymentStatus.belumBayar);
    store.submitProof('ORD-015', const Attachment('bukti.jpg', 1000));
    expect(store.byOrder('ORD-015')!.status, PaymentStatus.menunggu);
  });
}
