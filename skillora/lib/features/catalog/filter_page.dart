import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/auth_header.dart';
import 'service_model.dart';

/// Mengembalikan [FilterOptions] lewat Navigator.pop saat "Terapkan filter".
class FilterPage extends StatefulWidget {
  const FilterPage({super.key, required this.initial});

  final FilterOptions initial;

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late ServiceCategory? _category = widget.initial.category;
  late RangeValues _range = RangeValues(
    widget.initial.minPrice.toDouble(),
    widget.initial.maxPrice.toDouble(),
  );
  late SortOption _sort = widget.initial.sort;

  static const _max = 1000000.0;

  void _reset() => setState(() {
        _category = null;
        _range = const RangeValues(0, _max);
        _sort = SortOption.relevan;
      });

  void _apply() {
    Navigator.pop(
      context,
      FilterOptions(
        category: _category,
        minPrice: _range.start.round(),
        maxPrice: _range.end.round(),
        sort: _sort,
      ),
    );
  }

  String _priceLabel(double v) {
    final text = formatRupiah(v.round()).replaceFirst('Rp', 'Rp ');
    return v >= _max ? '$text+' : text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: AuthHeader(
                      title: 'Filter pencarian',
                      subtitle: 'Atur hasil sesuai kebutuhan',
                    ),
                  ),
                  AppTextLink(label: 'Atur ulang', onTap: _reset),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kategori', style: AppText.sectionTitle),
                    const SizedBox(height: 4),
                    _RadioRow(
                      label: 'Semua kategori',
                      selected: _category == null,
                      onTap: () => setState(() => _category = null),
                    ),
                    for (final c in ServiceCategory.values)
                      _RadioRow(
                        label: c.shortLabel,
                        selected: _category == c,
                        onTap: () => setState(() => _category = c),
                      ),
                    const SizedBox(height: 20),
                    Text('Rentang harga', style: AppText.sectionTitle),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        activeTrackColor: AppColors.sky,
                        inactiveTrackColor: AppColors.mist,
                        thumbColor: AppColors.sky,
                        overlayColor: AppColors.sky.withValues(alpha: 0.14),
                        showValueIndicator: ShowValueIndicator.never,
                        rangeThumbShape: const RoundRangeSliderThumbShape(
                          enabledThumbRadius: 8,
                          elevation: 0,
                          pressedElevation: 0,
                        ),
                      ),
                      child: RangeSlider(
                        values: _range,
                        min: 0,
                        max: _max,
                        divisions: 20,
                        onChanged: (v) => setState(() => _range = v),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_priceLabel(_range.start), style: AppText.subtitle),
                          Text(_priceLabel(_range.end), style: AppText.subtitle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Urutkan', style: AppText.sectionTitle),
                    const SizedBox(height: 4),
                    for (final s in SortOption.values)
                      _RadioRow(
                        label: s.label,
                        selected: _sort == s,
                        onTap: () => setState(() => _sort = s),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: PrimaryButton(label: 'TERAPKAN FILTER', onPressed: _apply),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioRow extends StatelessWidget {
  const _RadioRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.card,
                  border: Border.all(
                    color: selected ? AppColors.sky : AppColors.fieldBorder,
                    width: selected ? 1.6 : 1.2,
                  ),
                ),
                child: Center(
                  child: AnimatedScale(
                    scale: selected ? 1 : 0,
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOutBack,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.sky,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppText.input.copyWith(
                  fontSize: 13.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
