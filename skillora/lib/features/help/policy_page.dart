import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/navy_banner.dart';

class _PolicySection {
  const _PolicySection(this.title, this.body);

  final String title;
  final String body;
}

class _PolicyView extends StatelessWidget {
  const _PolicyView({
    required this.title,
    required this.subtitle,
    required this.banner,
    required this.updated,
    required this.sections,
  });

  final String title;
  final String subtitle;
  final String banner;
  final String updated;
  final List<_PolicySection> sections;

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: title,
      subtitle: subtitle,
      children: [
        Reveal(child: NavyBanner(title: banner, subtitle: updated)),
        const SizedBox(height: 20),
        for (var i = 0; i < sections.length; i++)
          Reveal(
            index: i + 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${i + 1}. ${sections[i].title}',
                    style: AppText.label.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(sections[i].body, style: AppText.body.copyWith(fontSize: 12.5)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Layar 41: kebijakan privasi.
/// TODO: ganti dengan teks resmi dari tim hukum/produk.
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PolicyView(
      title: 'Kebijakan & privasi',
      subtitle: 'Informasi perlindungan pengguna',
      banner: 'Privasi kamu adalah prioritas kami.',
      updated: 'Terakhir diperbarui • November 2026',
      sections: [
        _PolicySection('Informasi yang dikumpulkan',
            'Informasi akun, profil, detail pesanan, percakapan, dan bukti pembayaran yang kamu berikan saat menggunakan layanan.'),
        _PolicySection('Penggunaan informasi',
            'Informasi digunakan untuk menjalankan layanan, memproses pesanan dan pembayaran, serta membantu komunitas.'),
        _PolicySection('Keamanan data',
            'Kami berupaya menjaga informasi pengguna dengan langkah perlindungan yang wajar dan membatasi akses sesuai kebutuhan.'),
        _PolicySection('Kontrol pengguna',
            'Kamu dapat memperbarui informasi profil dan menghubungi pusat bantuan terkait data akun.'),
        _PolicySection('Persetujuan',
            'Dengan menggunakan aplikasi, kamu menyatakan telah membaca dan memahami kebijakan privasi ini.'),
      ],
    );
  }
}

/// Syarat & ketentuan. Belum ada desain Figma; mengikuti tata letak kebijakan.
/// TODO: ganti dengan teks resmi.
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PolicyView(
      title: 'Syarat & ketentuan',
      subtitle: 'Aturan penggunaan aplikasi',
      banner: 'Gunakan Ruang Karya dengan saling percaya.',
      updated: 'Terakhir diperbarui • November 2026',
      sections: [
        _PolicySection('Penggunaan layanan',
            'Ruang Karya menghubungkan pembeli dengan mahasiswa penyedia jasa. Gunakan layanan secara jujur dan sopan.'),
        _PolicySection('Pesanan dan pembayaran',
            'Pesanan diproses setelah penyedia jasa menerima dan pembayaran diverifikasi.'),
        _PolicySection('Hasil dan revisi',
            'Pembeli dapat mengajukan revisi selama pesanan belum diselesaikan.'),
        _PolicySection('Perubahan ketentuan',
            'Ketentuan dapat diperbarui dan akan diinformasikan di dalam aplikasi.'),
      ],
    );
  }
}
