import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import 'order_model.dart';
import 'widgets/file_row.dart';

/// Kelola lampiran. Ketuk baris untuk memilih / membatalkan pilihan.
/// Mengembalikan daftar berkas yang masih terpilih saat "SELESAI".
class AttachmentsPage extends StatefulWidget {
  const AttachmentsPage({
    super.key,
    required this.initial,
    this.picker = pickSampleAttachment,
  });

  final List<Attachment> initial;
  final AttachmentPicker picker;

  @override
  State<AttachmentsPage> createState() => _AttachmentsPageState();
}

class _AttachmentsPageState extends State<AttachmentsPage> {
  late final List<Attachment> _files = [...widget.initial];
  late final Set<Attachment> _selected = {...widget.initial};
  bool _picking = false;

  bool get _full => _files.length >= maxAttachments;

  Future<void> _add() async {
    if (_picking || _full) return;
    setState(() => _picking = true);
    final file = await widget.picker(_files);
    if (!mounted) return;
    setState(() {
      _picking = false;
      if (file != null) {
        _files.add(file);
        _selected.add(file);
      }
    });
    if (file == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Tidak ada berkas yang dipilih.')));
    }
  }

  void _toggle(Attachment f) {
    setState(() {
      if (!_selected.remove(f)) _selected.add(f);
    });
  }

  @override
  Widget build(BuildContext context) {
    final n = _selected.length;

    return FlowScaffold(
      title: 'Lampiran pesanan',
      subtitle: n == 0 ? 'Belum ada file dipilih' : '$n file dipilih',
      bottom: PrimaryButton(
        label: 'SELESAI',
        onPressed: () => Navigator.pop(
          context,
          [for (final f in _files) if (_selected.contains(f)) f],
        ),
      ),
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              for (final f in _files)
                Padding(
                  key: ValueKey(f.name),
                  padding: const EdgeInsets.only(bottom: 10),
                  child: PopIn(
                    child: _FileTile(
                      file: f,
                      selected: _selected.contains(f),
                      onTap: () => _toggle(f),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_files.isEmpty)
          Reveal(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Text(
                'Lampirkan brief, referensi, atau material supaya penyedia jasa '
                'paham kebutuhanmu sejak awal.',
                style: AppText.body,
              ),
            ),
          ),
        Reveal(
          index: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 8),
            child: Text('Tambahkan file lain', style: AppText.label),
          ),
        ),
        Reveal(
          index: 2,
          child: Pressable(
            onTap: (_full || _picking) ? null : _add,
            scale: 0.98,
            child: AnimatedOpacity(
              opacity: _full ? 0.5 : 1,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.7)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: _picking
                            ? const Padding(
                                key: ValueKey('busy'),
                                padding: EdgeInsets.all(2),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.sky,
                                ),
                              )
                            : const Icon(
                                Icons.add_rounded,
                                key: ValueKey('add'),
                                size: 24,
                                color: AppColors.sky,
                              ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        _full
                            ? 'Maksimal $maxAttachments file'
                            : 'Pilih PNG, JPG, atau PDF',
                        style: AppText.label.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FileTile extends StatelessWidget {
  const _FileTile({required this.file, required this.selected, required this.onTap});

  final Attachment file;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${file.name}, ${selected ? 'dipilih' : 'tidak dipilih'}',
      child: Pressable(
        onTap: onTap,
        scale: 0.985,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.mist : AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? Colors.transparent : AppColors.fieldBorder.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            children: [
              ExtBadge(ext: file.ext, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.label.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${formatUkuranFile(file.sizeBytes)} • ${file.ext}',
                      style: AppText.subtitle.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeOutBack,
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        key: ValueKey('on'),
                        size: 20,
                        color: AppColors.navyDeep,
                      )
                    : Container(
                        key: const ValueKey('off'),
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.fieldBorder, width: 1.4),
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
