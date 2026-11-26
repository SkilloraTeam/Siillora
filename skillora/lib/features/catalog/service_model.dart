import 'package:flutter/material.dart';

enum ServiceCategory {
  desain('Desain grafis', 'Desain', 'Logo, poster, UI/UX, ilustrasi',
      Icons.auto_awesome_rounded),
  web('Pengembangan web', 'Website', 'Website, landing page, aplikasi',
      Icons.code_rounded),
  penulisan('Penulisan', 'Penulisan', 'Artikel, laporan, proofreading',
      Icons.description_outlined),
  media('Foto & video', 'Foto & video', 'Editing, dokumentasi, motion',
      Icons.play_arrow_rounded),
  akademik('Akademik & data', 'Akademik', 'Analisis data, presentasi, riset',
      Icons.insights_rounded),
  lainnya('Layanan lainnya', 'Lainnya', 'Keahlian unik mahasiswa',
      Icons.category_outlined);

  const ServiceCategory(
    this.label,
    this.shortLabel,
    this.description,
    this.icon,
  );

  final String label;
  final String shortLabel;
  final String description;
  final IconData icon;
}

enum SortOption {
  relevan('Paling relevan'),
  rating('Rating tertinggi'),
  termurah('Harga terendah'),
  terbaru('Terbaru');

  const SortOption(this.label);
  final String label;
}

class PortfolioItem {
  const PortfolioItem(this.title, this.description);
  final String title;
  final String description;
}

class Service {
  const Service({
    required this.id,
    required this.title,
    required this.tagline,
    required this.description,
    required this.seller,
    required this.sellerInfo,
    required this.rating,
    required this.price,
    required this.category,
    required this.order,
    this.tag,
    this.pitch,
    this.iconOverride,
    this.portfolio = const [],
    this.portfolioLabel = 'CONTOH KARYA',
  });

  final String id;
  final String title;
  final String tagline;
  final String description;
  final String seller;
  final String sellerInfo;
  final double rating;
  final int price;
  final ServiceCategory category;

  /// Makin besar = makin baru. Dipakai untuk urutan "Terbaru".
  final int order;

  /// Label kecil di kartu detail, mis. "DESAIN UI/UX".
  final String? tag;

  /// Kalimat singkat di kartu detail. Kalau null, memakai [tagline].
  final String? pitch;
  final IconData? iconOverride;
  final List<PortfolioItem> portfolio;
  final String portfolioLabel;

  IconData get icon => iconOverride ?? category.icon;
  String get heroLine => pitch ?? tagline;
  String get sellerFirstName => seller.split(' ').first;
  String get portfolioFile => 'Portfolio_$sellerFirstName.pdf';
  String get tagLabel => (tag ?? category.shortLabel).toUpperCase();

  List<PortfolioItem> get portfolioItems =>
      portfolio.isNotEmpty ? portfolio : [PortfolioItem(title, description)];
}

class FilterOptions {
  const FilterOptions({
    this.category,
    this.minPrice = 0,
    this.maxPrice = maxPriceLimit,
    this.sort = SortOption.relevan,
  });

  static const maxPriceLimit = 1000000;

  final ServiceCategory? category;
  final int minPrice;
  final int maxPrice;
  final SortOption sort;

  bool get isDefault =>
      category == null &&
      minPrice == 0 &&
      maxPrice == maxPriceLimit &&
      sort == SortOption.relevan;

  /// Jumlah filter yang aktif (untuk lencana di tombol Filter).
  int get activeCount =>
      (category != null ? 1 : 0) +
      ((minPrice != 0 || maxPrice != maxPriceLimit) ? 1 : 0) +
      (sort != SortOption.relevan ? 1 : 0);

  @override
  bool operator ==(Object other) =>
      other is FilterOptions &&
      other.category == category &&
      other.minPrice == minPrice &&
      other.maxPrice == maxPrice &&
      other.sort == sort;

  @override
  int get hashCode => Object.hash(category, minPrice, maxPrice, sort);
}
