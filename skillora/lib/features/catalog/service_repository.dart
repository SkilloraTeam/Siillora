import 'package:flutter/material.dart';

import 'service_model.dart';

/// Sumber data jasa. Sekarang data contoh di memori.
/// TODO: ganti isi [all] dan [search] dengan query Supabase.
abstract final class ServiceRepository {
  static const all = <Service>[
    Service(
      id: 's1',
      title: 'Desain UI/UX Aplikasi',
      tagline: 'Wireframe hingga prototipe',
      description:
          'Pembuatan desain aplikasi mobile mulai dari riset, wireframe, '
          'hingga high-fidelity prototype di Figma.',
      seller: 'Nadia Putri',
      sellerInfo: 'Mahasiswa • Desain Komunikasi Visual',
      rating: 4.9,
      price: 150000,
      category: ServiceCategory.desain,
      order: 12,
      tag: 'Desain UI/UX',
      pitch: 'Modern, intuitif, dan responsif',
      portfolioLabel: 'MOBILE APP CONCEPT',
      portfolio: [
        PortfolioItem(
          'Skincare Mobile App',
          'Desain aplikasi skincare untuk membantu pengguna menemukan produk '
              'perawatan kulit sesuai kebutuhan.',
        ),
        PortfolioItem(
          'Food Ordering Mobile App',
          'Desain aplikasi pemesanan makanan dengan tampilan modern yang '
              'memudahkan pengguna memilih dan memesan menu.',
        ),
        PortfolioItem(
          'Food Recipe Mobile App',
          'Desain aplikasi resep makanan yang menampilkan berbagai pilihan '
              'hidangan dengan tampilan elegan dan informatif.',
        ),
      ],
    ),
    Service(
      id: 's2',
      title: 'Desain Mobile App',
      tagline: 'UI modern dan responsif',
      description:
          'Desain antarmuka aplikasi Android dan iOS yang rapi, konsisten, '
          'dan siap diserahkan ke developer.',
      seller: 'Dimas Akbar',
      sellerInfo: 'Mahasiswa • Teknik Informatika',
      rating: 4.8,
      price: 180000,
      category: ServiceCategory.desain,
      order: 11,
    ),
    Service(
      id: 's3',
      title: 'Prototype Figma',
      tagline: 'Interaktif dan siap uji',
      description:
          'Prototipe interaktif di Figma lengkap dengan alur layar dan '
          'transisi, siap dipakai untuk uji coba pengguna.',
      seller: 'Aya Safitri',
      sellerInfo: 'Mahasiswa • Sistem Informasi',
      rating: 4.7,
      price: 120000,
      category: ServiceCategory.desain,
      order: 10,
    ),
    Service(
      id: 's4',
      title: 'Desain Dashboard',
      tagline: 'Dashboard web dan admin',
      description:
          'Desain dashboard dan panel admin dengan tata letak data yang '
          'mudah dibaca, lengkap dengan komponen grafik dan tabel.',
      seller: 'Rizky Maulana',
      sellerInfo: 'Mahasiswa • Teknik Informatika',
      rating: 4.8,
      price: 200000,
      category: ServiceCategory.desain,
      order: 9,
    ),
    Service(
      id: 's5',
      title: 'Website Portofolio',
      tagline: 'Satu halaman, cepat, dan rapi',
      description:
          'Website portofolio pribadi yang responsif, ringan, dan mudah '
          'diperbarui, lengkap dengan halaman proyek dan kontak.',
      seller: 'Rizky Maulana',
      sellerInfo: 'Mahasiswa • Teknik Informatika',
      rating: 4.9,
      price: 250000,
      category: ServiceCategory.web,
      order: 8,
    ),
    Service(
      id: 's6',
      title: 'Landing Page Usaha',
      tagline: 'Untuk UMKM dan acara kampus',
      description:
          'Landing page untuk promosi usaha atau acara, dengan formulir '
          'pendaftaran dan tampilan yang nyaman di ponsel.',
      seller: 'Fajar Ramadhan',
      sellerInfo: 'Mahasiswa • Ilmu Komputer',
      rating: 4.6,
      price: 175000,
      category: ServiceCategory.web,
      order: 7,
    ),
    Service(
      id: 's7',
      title: 'Desain Poster Acara',
      tagline: 'Poster cetak dan digital',
      description:
          'Poster untuk seminar, lomba, dan kegiatan organisasi. Tersedia '
          'dalam ukuran cetak dan versi media sosial.',
      seller: 'Aya Safitri',
      sellerInfo: 'Mahasiswa • Sistem Informasi',
      rating: 4.6,
      price: 75000,
      category: ServiceCategory.desain,
      order: 6,
      iconOverride: Icons.image_outlined,
    ),
    Service(
      id: 's8',
      title: 'Penulisan Artikel Blog',
      tagline: '800–1.000 kata, bebas plagiasi',
      description:
          'Artikel blog dengan riset singkat, struktur jelas, dan gaya '
          'bahasa yang disesuaikan dengan target pembacamu.',
      seller: 'Salsa Amelia',
      sellerInfo: 'Mahasiswa • Ilmu Komunikasi',
      rating: 4.7,
      price: 60000,
      category: ServiceCategory.penulisan,
      order: 5,
    ),
    Service(
      id: 's9',
      title: 'Proofreading Skripsi',
      tagline: 'Cek ejaan, tata bahasa, dan format',
      description:
          'Pemeriksaan ejaan, tata bahasa, dan kesesuaian format penulisan '
          'skripsi atau laporan akhir.',
      seller: 'Rani Kusuma',
      sellerInfo: 'Mahasiswa • Sastra Indonesia',
      rating: 4.9,
      price: 90000,
      category: ServiceCategory.penulisan,
      order: 4,
    ),
    Service(
      id: 's10',
      title: 'Editing Video Reels',
      tagline: 'Potong, warna, dan teks',
      description:
          'Penyuntingan video pendek untuk Reels dan TikTok: pemotongan, '
          'koreksi warna, teks, dan musik latar.',
      seller: 'Bima Prakoso',
      sellerInfo: 'Mahasiswa • Film dan Televisi',
      rating: 4.6,
      price: 110000,
      category: ServiceCategory.media,
      order: 3,
    ),
    Service(
      id: 's11',
      title: 'Dokumentasi Kegiatan',
      tagline: 'Foto acara dan liputan singkat',
      description:
          'Dokumentasi foto kegiatan kampus dan organisasi, termasuk '
          'penyuntingan dasar dan penyerahan file dalam satu tautan.',
      seller: 'Tari Lestari',
      sellerInfo: 'Mahasiswa • Fotografi',
      rating: 4.5,
      price: 200000,
      category: ServiceCategory.media,
      order: 2,
    ),
    Service(
      id: 's12',
      title: 'Olah Data Penelitian',
      tagline: 'Rapikan dan analisis dengan SPSS',
      description:
          'Pembersihan data dan analisis statistik dengan SPSS, lengkap '
          'dengan ringkasan hasil yang mudah dipahami.',
      seller: 'Galih Pratama',
      sellerInfo: 'Mahasiswa • Statistika',
      rating: 4.8,
      price: 130000,
      category: ServiceCategory.akademik,
      order: 1,
    ),
  ];

  static Service byId(String id) => all.firstWhere((s) => s.id == id);

  /// Tiga jasa yang tampil di Beranda.
  static List<Service> get recommended => [byId('s1'), byId('s5'), byId('s7')];

  static List<Service> search(String query, FilterOptions f) {
    final tokens = query
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    int score(Service s) {
      final hay = '${s.title} ${s.tagline} ${s.seller} ${s.category.label}'
          .toLowerCase();
      return tokens.where(hay.contains).length;
    }

    final list = all.where((s) {
      if (f.category != null && s.category != f.category) return false;
      if (s.price < f.minPrice) return false;
      if (f.maxPrice < FilterOptions.maxPriceLimit && s.price > f.maxPrice) {
        return false;
      }
      if (tokens.isNotEmpty && score(s) == 0) return false;
      return true;
    }).toList();

    switch (f.sort) {
      case SortOption.relevan:
        list.sort((a, b) {
          final c = score(b).compareTo(score(a));
          return c != 0 ? c : b.rating.compareTo(a.rating);
        });
      case SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case SortOption.termurah:
        list.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.terbaru:
        list.sort((a, b) => b.order.compareTo(a.order));
    }
    return list;
  }
}
