import 'package:flutter/foundation.dart';

import '../order/order_model.dart';

enum PaymentStatus {
  belumBayar('Belum bayar'),
  menunggu('Menunggu'),
  berhasil('Berhasil');

  const PaymentStatus(this.label);
  final String label;
}

class Payment {
  const Payment({
    required this.orderId,
    required this.invoice,
    required this.title,
    required this.amount,
    required this.status,
    required this.date,
    this.proof,
  });

  /// Tanpa tanda pagar, mis. "ORD-015".
  final String orderId;
  final String invoice;
  final String title;
  final int amount;
  final PaymentStatus status;
  final DateTime date;
  final Attachment? proof;

  String get displayOrderId => '#$orderId';

  Payment copyWith({PaymentStatus? status, Attachment? proof}) => Payment(
        orderId: orderId,
        invoice: invoice,
        title: title,
        amount: amount,
        status: status ?? this.status,
        date: date,
        proof: proof ?? this.proof,
      );
}

/// Tagihan pembeli. Nomor pesanan sama dengan [OrderStore].
/// TODO: ganti dengan tabel payments di Supabase dan unggah bukti ke Storage.
class PaymentStore extends ChangeNotifier {
  PaymentStore._();

  static final instance = PaymentStore._();

  final List<Payment> _items = [
    Payment(
      orderId: 'ORD-015',
      invoice: 'INV-2026-015',
      title: 'Desain UI/UX Aplikasi',
      amount: 250000,
      status: PaymentStatus.belumBayar,
      date: DateTime(2026, 11, 20),
    ),
    Payment(
      orderId: 'ORD-016',
      invoice: 'INV-2026-016',
      title: 'Website Portofolio',
      amount: 200000,
      status: PaymentStatus.berhasil,
      date: DateTime(2026, 11, 13),
    ),
  ];

  List<Payment> get items => List.unmodifiable(_items);

  int get total => _items.fold(0, (sum, p) => sum + p.amount);

  Payment? byOrder(String orderId) {
    for (final p in _items) {
      if (p.orderId == orderId) return p;
    }
    return null;
  }

  void submitProof(String orderId, Attachment proof) {
    final i = _items.indexWhere((p) => p.orderId == orderId);
    if (i < 0) return;
    _items[i] = _items[i].copyWith(status: PaymentStatus.menunggu, proof: proof);
    notifyListeners();
  }
}

/// Pemilih bukti bayar. Masih berkas contoh supaya alur bisa dicoba.
/// TODO: ganti dengan file_picker (PNG, JPG).
Future<Attachment?> pickSampleProof() async {
  await Future<void>.delayed(const Duration(milliseconds: 250));
  return const Attachment('bukti_qris.jpg', 1258291);
}
