/// 150000 -> "Rp150.000"
String formatRupiah(int value) {
  final digits = value.abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write('.');
    buf.write(digits[i]);
  }
  return 'Rp${value < 0 ? '-' : ''}$buf';
}

const _bulan = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

/// 1 -> "Januari"
String namaBulan(int month) => _bulan[month - 1];

/// DateTime(2026, 11, 28) -> "28 November 2026"
String formatTanggal(DateTime d) => '${d.day} ${namaBulan(d.month)} ${d.year}';

/// 2516582 -> "2.4 MB", 340000 -> "332 KB"
String formatUkuranFile(int bytes) {
  if (bytes < 1024 * 1024) return '${(bytes / 1024).round()} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

/// DateTime(2026, 11, 28) -> "28 Nov 2026"
String formatTanggalPendek(DateTime d) =>
    '${d.day} ${namaBulan(d.month).substring(0, 3)} ${d.year}';
