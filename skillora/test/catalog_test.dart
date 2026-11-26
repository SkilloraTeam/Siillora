import 'package:flutter_test/flutter_test.dart';
import 'package:skillora/core/utils/format.dart';
import 'package:skillora/features/catalog/service_model.dart';
import 'package:skillora/features/catalog/service_repository.dart';

void main() {
  test('formatRupiah memakai titik ribuan', () {
    expect(formatRupiah(150000), 'Rp150.000');
    expect(formatRupiah(75000), 'Rp75.000');
  });

  test('filter kategori hanya mengembalikan kategori itu', () {
    final r = ServiceRepository.search(
      '',
      const FilterOptions(category: ServiceCategory.web),
    );
    expect(r, isNotEmpty);
    expect(r.every((s) => s.category == ServiceCategory.web), isTrue);
  });

  test('urut harga terendah naik', () {
    final r = ServiceRepository.search(
      '',
      const FilterOptions(sort: SortOption.termurah),
    );
    for (var i = 1; i < r.length; i++) {
      expect(r[i].price >= r[i - 1].price, isTrue);
    }
  });

  test('kata kunci poster menemukan Desain Poster Acara', () {
    final r = ServiceRepository.search('poster', const FilterOptions());
    expect(r.first.title, 'Desain Poster Acara');
  });
}
