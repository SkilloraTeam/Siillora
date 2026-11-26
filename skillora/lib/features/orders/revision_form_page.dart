import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import '../order/attachments_page.dart';
import '../order/order_model.dart';
import '../order/placed_order.dart';
import '../order/widgets/file_row.dart';
import 'revision_sent_page.dart';

/// Layar 22: form ajukan revisi.
class RevisionFormPage extends StatefulWidget {
  const RevisionFormPage({super.key, required this.order});

  final PlacedOrder order;

  @override
  State<RevisionFormPage> createState() => _RevisionFormPageState();
}

class _RevisionFormPageState extends State<RevisionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _note = TextEditingController();
  List<Attachment> _files = const [];
  bool _sending = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final r = await Navigator.push<List<Attachment>>(
      context,
      appRoute<List<Attachment>>(AttachmentsPage(initial: _files)),
    );
    if (r != null && mounted) setState(() => _files = r);
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    // TODO: kirim revisi + lampiran ke Supabase.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    OrderStore.instance.requestRevision(widget.order.id, _note.text.trim());
    await Navigator.pushReplacement(
      context,
      appRoute(RevisionSentPage(order: widget.order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final has = _files.isNotEmpty;

    return FlowScaffold(
      title: 'Ajukan revisi',
      subtitle: 'Jelaskan bagian yang perlu diperbaiki',
      bottom: PrimaryButton(
        label: 'KIRIM PERMINTAAN REVISI',
        loading: _sending,
        onPressed: _send,
      ),
      children: [
        Reveal(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pesanan ${o.displayId}', style: AppText.label.copyWith(fontSize: 12.5)),
                const SizedBox(height: 2),
                Text(
                  o.service.title,
                  style: AppText.subtitle.copyWith(fontSize: 11, color: AppColors.navyDeep),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        Reveal(
          index: 1,
          child: Form(
            key: _formKey,
            child: AppTextField(
              label: 'Detail revisi',
              hint: 'Jelaskan perubahan yang kamu inginkan...',
              controller: _note,
              minLines: 5,
              maxLines: 8,
              helper: 'Contoh: ubah warna utama, perbaiki tombol di halaman checkout.',
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'Jelaskan bagian yang ingin direvisi.';
                if (t.length < 10) return 'Tulis sedikit lebih rinci, minimal 10 karakter.';
                return null;
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        Reveal(
          index: 2,
          child: Column(
            children: [
              Pressable(
                onTap: _pickFiles,
                scale: 0.98,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.7)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        has ? Icons.attach_file_rounded : Icons.add_rounded,
                        size: 18,
                        color: AppColors.sky,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          has
                              ? '${_files.length} lampiran referensi dipilih'
                              : 'Lampiran referensi revisi (opsional)',
                          style: AppText.label.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    for (final f in _files)
                      Padding(
                        key: ValueKey(f.name),
                        padding: const EdgeInsets.only(top: 8),
                        child: PopIn(child: FileRow(file: f)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
