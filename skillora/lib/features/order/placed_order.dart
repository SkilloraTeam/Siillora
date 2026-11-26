import 'package:flutter/foundation.dart';

import '../catalog/service_model.dart';
import '../catalog/service_repository.dart';
import 'order_model.dart';

enum OrderStatus {
  menunggu('Menunggu', 'Ditinjau', 0),
  dikerjakan('Dikerjakan', 'Sedang dikerjakan', 1),
  revisi('Revisi', 'Revisi berlangsung', 2),
  selesai('Selesai', 'Selesai', 3);

  const OrderStatus(this.label, this.detailLabel, this.stage);

  /// Label di daftar pesanan.
  final String label;

  /// Label di halaman detail.
  final String detailLabel;

  /// Posisi di garis status (0..3).
  final int stage;
}

/// Pesanan yang sudah dikirim.
class PlacedOrder {
  const PlacedOrder({
    required this.id,
    required this.service,
    required this.status,
    required this.message,
    required this.deadline,
    this.price,
    this.attachments = const [],
    this.result,
    this.providerNote,
    this.revisionNote,
    this.rating,
    this.review,
  });

  /// Tanpa tanda pagar, mis. "ORD-018".
  final String id;
  final Service service;
  final OrderStatus status;
  final String message;
  final DateTime deadline;

  /// null = penyedia belum menetapkan harga.
  final int? price;
  final List<Attachment> attachments;

  /// Berkas hasil dari penyedia jasa.
  final Attachment? result;

  /// Catatan dari penyedia jasa untuk hasil akhir.
  final String? providerNote;

  /// Permintaan revisi terakhir dari pembeli.
  final String? revisionNote;

  /// Ulasan pembeli (1..5). null = belum mengulas.
  final int? rating;
  final String? review;

  bool get reviewed => rating != null;

  String get displayId => '#$id';

  PlacedOrder copyWith({
    OrderStatus? status,
    String? revisionNote,
    int? rating,
    String? review,
  }) =>
      PlacedOrder(
        id: id,
        service: service,
        status: status ?? this.status,
        message: message,
        deadline: deadline,
        price: price,
        attachments: attachments,
        result: result,
        providerNote: providerNote,
        revisionNote: revisionNote ?? this.revisionNote,
        rating: rating ?? this.rating,
        review: review ?? this.review,
      );
}

/// Penyimpanan pesanan di memori.
/// TODO: ganti dengan query Supabase (tabel orders).
class OrderStore extends ChangeNotifier {
  OrderStore._();

  static final instance = OrderStore._();

  int _next = 18;

  final List<PlacedOrder> _orders = [
    PlacedOrder(
      id: 'ORD-015',
      service: ServiceRepository.byId('s1'),
      status: OrderStatus.dikerjakan,
      message: 'Desain aplikasi pemesanan makanan dengan 5 halaman utama.',
      deadline: DateTime(2026, 11, 28),
      price: 250000,
      result: const Attachment('Hasil_Desain.pdf', 3984588),
      providerNote: 'Berikut hasil akhir sesuai brief dan revisi yang telah '
          'disepakati. Terima kasih sudah bekerja sama!',
    ),
    PlacedOrder(
      id: 'ORD-016',
      service: ServiceRepository.byId('s5'),
      status: OrderStatus.menunggu,
      message: 'Website portofolio satu halaman untuk mahasiswa DKV.',
      deadline: DateTime(2026, 12, 5),
      price: 200000,
    ),
    PlacedOrder(
      id: 'ORD-012',
      service: ServiceRepository.byId('s7'),
      status: OrderStatus.selesai,
      message: 'Poster acara kampus ukuran A3, tema teknologi.',
      deadline: DateTime(2026, 11, 10),
      price: 75000,
      result: const Attachment('Poster_Final.pdf', 2097152),
    ),
    PlacedOrder(
      id: 'ORD-013',
      service: ServiceRepository.byId('s10'),
      status: OrderStatus.revisi,
      message: 'Editing video reels 30 detik untuk akun organisasi.',
      deadline: DateTime(2026, 11, 20),
      price: 120000,
      result: const Attachment('Reels_V1.pdf', 1572864),
    ),
  ];

  List<PlacedOrder> get orders => List.unmodifiable(_orders);

  PlacedOrder? byId(String id) {
    for (final o in _orders) {
      if (o.id == id) return o;
    }
    return null;
  }

  PlacedOrder add(OrderDraft draft) {
    final order = PlacedOrder(
      id: 'ORD-${(_next++).toString().padLeft(3, '0')}',
      service: draft.service,
      status: OrderStatus.menunggu,
      message: draft.message,
      deadline: draft.deadline,
      attachments: draft.attachments,
    );
    _orders.insert(0, order);
    notifyListeners();
    return order;
  }

  void setStatus(String id, OrderStatus status) {
    final i = _orders.indexWhere((o) => o.id == id);
    if (i < 0) return;
    _orders[i] = _orders[i].copyWith(status: status);
    notifyListeners();
  }

  void requestRevision(String id, String note) {
    final i = _orders.indexWhere((o) => o.id == id);
    if (i < 0) return;
    _orders[i] = _orders[i].copyWith(status: OrderStatus.revisi, revisionNote: note);
    notifyListeners();
  }

  void submitReview(String id, int rating, String review) {
    final i = _orders.indexWhere((o) => o.id == id);
    if (i < 0) return;
    _orders[i] = _orders[i].copyWith(rating: rating, review: review);
    notifyListeners();
  }
}
