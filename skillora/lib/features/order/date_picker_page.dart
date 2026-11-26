import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/flow_scaffold.dart';

/// Kalender pilih deadline. Mengembalikan DateTime lewat Navigator.pop.
/// Tanggal sebelum [today] tidak bisa dipilih.
class DatePickerPage extends StatefulWidget {
  const DatePickerPage({super.key, this.initial, this.today});

  final DateTime? initial;

  /// Hanya untuk pengujian. Default: hari ini.
  final DateTime? today;

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  static const _weekdays = ['S', 'S', 'R', 'K', 'J', 'S', 'M']; // Senin..Minggu
  static const _rowHeight = 44.0;

  late final DateTime _today = _dateOnly(widget.today ?? DateTime.now());
  late DateTime? _selected =
      widget.initial == null ? null : _dateOnly(widget.initial!);
  late DateTime _month = DateTime(
    (_selected ?? _today).year,
    (_selected ?? _today).month,
  );
  int _dir = 1;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  bool get _canGoBack =>
      _month.isAfter(DateTime(_today.year, _today.month));

  void _shift(int by) {
    setState(() {
      _dir = by;
      _month = DateTime(_month.year, _month.month + by);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Pilih deadline',
      subtitle: 'Tentukan estimasi penyelesaian',
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SelectedBar(date: _selected),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'KONFIRMASI TANGGAL',
            onPressed: _selected == null
                ? null
                : () => Navigator.pop(context, _selected),
          ),
        ],
      ),
      children: [
        Reveal(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${namaBulan(_month.month)} ${_month.year}',
                  style: AppText.sectionTitle,
                ),
              ),
              _MonthArrow(
                icon: Icons.chevron_left_rounded,
                label: 'Bulan sebelumnya',
                onTap: _canGoBack ? () => _shift(-1) : null,
              ),
              const SizedBox(width: 4),
              _MonthArrow(
                icon: Icons.chevron_right_rounded,
                label: 'Bulan berikutnya',
                onTap: () => _shift(1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Reveal(
          index: 1,
          child: Row(
            children: [
              for (final d in _weekdays)
                Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: AppText.subtitle.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Reveal(
          index: 2,
          child: SizedBox(
            height: _rowHeight * 6,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, anim) {
                final incoming = child.key == ValueKey(_month);
                final begin = Offset((incoming ? 0.12 : -0.12) * _dir, 0);
                return FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween(begin: begin, end: Offset.zero).animate(anim),
                    child: child,
                  ),
                );
              },
              layoutBuilder: (current, previous) => Stack(
                alignment: Alignment.topCenter,
                children: [...previous, ?current],
              ),
              child: _MonthGrid(
                key: ValueKey(_month),
                month: _month,
                today: _today,
                selected: _selected,
                rowHeight: _rowHeight,
                onPick: (d) => setState(() => _selected = d),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MonthArrow extends StatelessWidget {
  const _MonthArrow({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: AnimatedOpacity(
              opacity: onTap == null ? 0.3 : 1,
              duration: const Duration(milliseconds: 180),
              child: Icon(icon, size: 24, color: AppColors.navyDeep),
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    super.key,
    required this.month,
    required this.today,
    required this.selected,
    required this.rowHeight,
    required this.onPick,
  });

  final DateTime month;
  final DateTime today;
  final DateTime? selected;
  final double rowHeight;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context) {
    final lead = DateTime(month.year, month.month, 1).weekday - 1; // Senin = 0
    final days = DateTime(month.year, month.month + 1, 0).day;
    final cells = <Widget>[
      for (var i = 0; i < lead; i++) const SizedBox.shrink(),
      for (var d = 1; d <= days; d++) _cell(DateTime(month.year, month.month, d)),
    ];
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox.shrink());
    }

    return Column(
      children: [
        for (var r = 0; r < cells.length ~/ 7; r++)
          SizedBox(
            height: rowHeight,
            child: Row(
              children: [
                for (var c = 0; c < 7; c++) Expanded(child: cells[r * 7 + c]),
              ],
            ),
          ),
      ],
    );
  }

  Widget _cell(DateTime date) {
    return _DayCell(
      date: date,
      isSelected: selected == date,
      isToday: date == today,
      enabled: !date.isBefore(today),
      onTap: () => onPick(date),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.enabled,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color textColor = isSelected
        ? Colors.white
        : enabled
            ? AppColors.textPrimary
            : AppColors.textHint.withValues(alpha: 0.55);

    return Semantics(
      button: true,
      enabled: enabled,
      selected: isSelected,
      label: formatTanggal(date),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: Center(
          child: AnimatedScale(
            scale: isSelected ? 1 : 0.9,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.navyDeep : Colors.transparent,
                border: isToday && !isSelected
                    ? Border.all(color: AppColors.sky, width: 1.2)
                    : null,
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: AppText.input.copyWith(
                  fontSize: 13,
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                ),
                child: Text('${date.day}'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedBar extends StatelessWidget {
  const _SelectedBar({required this.date});

  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final text = date == null ? 'Belum dipilih' : formatTanggal(date!);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: Text('Jadwal dipilih', style: AppText.subtitle)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.4),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: Text(
              text,
              key: ValueKey(text),
              style: AppText.label.copyWith(
                color: date == null ? AppColors.textHint : AppColors.navyDeep,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
