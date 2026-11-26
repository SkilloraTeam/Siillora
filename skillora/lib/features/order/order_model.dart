import '../catalog/service_model.dart';

class Attachment {
  const Attachment(this.name, this.sizeBytes);

  final String name;
  final int sizeBytes;

  /// "Brief_Aplikasi.pdf" -> "PDF"
  String get ext => name.contains('.') ? name.split('.').last.toUpperCase() : 'FILE';

  @override
  bool operator ==(Object other) =>
      other is Attachment && other.name == name && other.sizeBytes == sizeBytes;

  @override
  int get hashCode => Object.hash(name, sizeBytes);
}

/// Isi pesanan yang sedang disusun pembeli.
class OrderDraft {
  const OrderDraft({
    required this.service,
    required this.message,
    required this.deadline,
    this.attachments = const [],
  });

  final Service service;
  final String message;
  final DateTime deadline;
  final List<Attachment> attachments;

  OrderDraft copyWith({
    String? message,
    DateTime? deadline,
    List<Attachment>? attachments,
  }) =>
      OrderDraft(
        service: service,
        message: message ?? this.message,
        deadline: deadline ?? this.deadline,
        attachments: attachments ?? this.attachments,
      );
}

/// Pemilih berkas. Sekarang masih berkas contoh supaya alur bisa dicoba.
/// TODO: ganti dengan package file_picker (PNG, JPG, PDF) lalu isi
/// [Attachment] dari berkas asli, dan unggah ke Supabase Storage.
typedef AttachmentPicker = Future<Attachment?> Function(List<Attachment> existing);

const _samples = [
  Attachment('Brief_Aplikasi.pdf', 2516582),
  Attachment('Referensi_Warna.png', 884736),
  Attachment('Moodboard.jpg', 1363148),
  Attachment('Alur_Pengguna.pdf', 1048576),
  Attachment('Logo_Lama.png', 327680),
];

const maxAttachments = 5;

Future<Attachment?> pickSampleAttachment(List<Attachment> existing) async {
  await Future<void>.delayed(const Duration(milliseconds: 250));
  for (final s in _samples) {
    if (!existing.any((e) => e.name == s.name)) return s;
  }
  return null;
}
