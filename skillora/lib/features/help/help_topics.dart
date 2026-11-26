/// Isi Pusat bantuan. Langkah mengikuti alur aplikasi yang ada.
/// TODO: pindahkan ke tabel help_articles kalau konten perlu diubah tanpa rilis.
class HelpStep {
  const HelpStep(this.title, this.body);

  final String title;
  final String body;
}

class HelpTopic {
  const HelpTopic(this.question, this.pageTitle, this.steps);

  /// Pertanyaan di daftar "Pertanyaan umum".
  final String question;

  /// Judul halaman panduan.
  final String pageTitle;
  final List<HelpStep> steps;
}

const helpTopics = <HelpTopic>[
  HelpTopic('Bagaimana cara memesan jasa?', 'Cara memesan jasa', [
    HelpStep('Pilih layanan', 'Jelajahi katalog atau kategori jasa, lalu buka detail jasa.'),
    HelpStep('Isi kebutuhan',
        'Tuliskan deskripsi proyek, tentukan deadline, dan tambahkan lampiran jika diperlukan.'),
    HelpStep('Kirim pesanan',
        'Periksa ringkasan pesanan dan kirim permintaan kepada penyedia jasa.'),
    HelpStep('Lakukan pembayaran',
        'Jika pesanan diterima, buka pembayaran, scan QRIS, lalu unggah bukti.'),
    HelpStep('Pantau pekerjaan',
        'Pantau status, gunakan chat untuk komunikasi, dan ajukan revisi jika diperlukan.'),
  ]),
  HelpTopic('Bagaimana melakukan pembayaran?', 'Cara melakukan pembayaran', [
    HelpStep('Buka tagihan', 'Pilih tab Bayar, lalu ketuk tagihan yang belum dibayar.'),
    HelpStep('Scan QRIS', 'Scan kode QRIS dengan mobile banking atau e-wallet.'),
    HelpStep('Unggah bukti',
        'Pilih tangkapan layar bukti transfer berformat PNG atau JPG, lalu kirim.'),
    HelpStep('Tunggu verifikasi',
        'Status berubah menjadi Berhasil setelah pembayaran diverifikasi.'),
  ]),
  HelpTopic('Bagaimana mengajukan revisi?', 'Cara mengajukan revisi', [
    HelpStep('Buka pesanan', 'Buka detail pesanan yang sedang dikerjakan.'),
    HelpStep('Ajukan revisi', 'Ketuk Ajukan revisi dan jelaskan bagian yang ingin diubah.'),
    HelpStep('Diskusikan', 'Lanjutkan diskusi dengan penyedia jasa lewat chat.'),
  ]),
  HelpTopic('Kapan bisa memberi ulasan?', 'Cara memberi ulasan', [
    HelpStep('Tunggu selesai', 'Ulasan dibuka setelah pesanan berstatus Selesai.'),
    HelpStep('Beri nilai', 'Buka detail pesanan, ketuk Beri ulasan, lalu pilih bintang.'),
    HelpStep('Tulis komentar', 'Ceritakan pengalamanmu, lalu kirim ulasan.'),
  ]),
  HelpTopic('Bagaimana mengubah profil?', 'Cara mengubah profil', [
    HelpStep('Buka akun', 'Pilih tab Akun.'),
    HelpStep('Edit profil', 'Ketuk Edit profil, lalu ubah nama, email, atau nomor telepon.'),
    HelpStep('Simpan', 'Ketuk Simpan perubahan.'),
  ]),
];
