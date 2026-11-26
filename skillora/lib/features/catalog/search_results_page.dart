import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/auth_header.dart';
import '../../core/widgets/pressable.dart';
import 'filter_page.dart';
import 'service_detail_page.dart';
import 'service_model.dart';
import 'service_repository.dart';
import 'widgets/service_card.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({
    super.key,
    this.initialQuery = '',
    this.category,
    this.autofocus = false,
  });

  final String initialQuery;
  final ServiceCategory? category;
  final bool autofocus;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late final TextEditingController _query =
      TextEditingController(text: widget.initialQuery);
  late FilterOptions _options = FilterOptions(category: widget.category);

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _openFilter() async {
    FocusScope.of(context).unfocus();
    // rootNavigator: true supaya halaman filter menutupi bottom navigation.
    final result = await Navigator.of(context, rootNavigator: true)
        .push<FilterOptions>(appRoute(FilterPage(initial: _options)));
    if (result != null && mounted) setState(() => _options = result);
  }

  void _openDetail(Service s) {
    Navigator.of(context, rootNavigator: true)
        .push(appRoute(ServiceDetailPage(service: s)));
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.text.trim();
    final results = ServiceRepository.search(query, _options);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeader(
                title: 'Pencarian jasa',
                subtitle: 'Temukan layanan yang kamu butuhkan',
              ),
              const SizedBox(height: 16),
              _SearchBox(
                controller: _query,
                autofocus: widget.autofocus,
                filterCount: _options.activeCount,
                onChanged: (_) => setState(() {}),
                onFilter: _openFilter,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Hasil pencarian',
                      style: AppText.sectionTitle.copyWith(fontSize: 16),
                    ),
                  ),
                  Text('${results.length} jasa', style: AppText.subtitle),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: results.isEmpty
                      ? _NoResults(
                          key: const ValueKey('empty'),
                          canReset: !_options.isDefault,
                          onReset: () =>
                              setState(() => _options = const FilterOptions()),
                        )
                      : ListView.separated(
                          key: ValueKey('$query|${_options.hashCode}'),
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: results.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (context, i) => ServiceCard(
                            service: results[i],
                            showTagline: true,
                            onTap: () => _openDetail(results[i]),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({
    required this.controller,
    required this.autofocus,
    required this.filterCount,
    required this.onChanged,
    required this.onFilter,
  });

  final TextEditingController controller;
  final bool autofocus;
  final int filterCount;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(14, 0, 8, 0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 19, color: AppColors.sky),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: AppText.input.copyWith(fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Cari jasa, keahlian, mahasiswa...',
                hintStyle: AppText.hint.copyWith(fontSize: 13),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                onChanged('');
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          Pressable(
            onTap: onFilter,
            scale: 0.94,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.fromLTRB(14, 8, filterCount > 0 ? 8 : 14, 8),
              decoration: BoxDecoration(
                color: AppColors.mist,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter',
                    style: AppText.label.copyWith(
                      fontSize: 12,
                      color: AppColors.navyDeep,
                    ),
                  ),
                  if (filterCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.navyDeep,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$filterCount',
                        style: AppText.label.copyWith(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({super.key, required this.canReset, required this.onReset});

  final bool canReset;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Belum ada jasa yang cocok', style: AppText.sectionTitle),
          const SizedBox(height: 4),
          Text(
            canReset
                ? 'Coba longgarkan filter atau ganti kata kunci.'
                : 'Coba kata kunci lain.',
            textAlign: TextAlign.center,
            style: AppText.subtitle,
          ),
          if (canReset) ...[
            const SizedBox(height: 8),
            AppTextLink(label: 'Atur ulang filter', onTap: onReset),
          ],
        ],
      ),
    );
  }
}
