import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_picker_field.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/flow_scaffold.dart';
import 'attachments_page.dart';
import 'date_picker_page.dart';
import 'order_model.dart';
import 'widgets/file_row.dart';

/// Layar 15: ubah isi pesanan. Mengembalikan [OrderDraft] baru saat disimpan.
class EditOrderPage extends StatefulWidget {
  const EditOrderPage({super.key, required this.draft});

  final OrderDraft draft;

  @override
  State<EditOrderPage> createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderPage> {
  final _formKey = GlobalKey<FormState>();
  late final _message = TextEditingController(text: widget.draft.message);
  late DateTime _deadline = widget.draft.deadline;
  late List<Attachment> _files = [...widget.draft.attachments];

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final r = await Navigator.push<DateTime>(
      context,
      appRoute<DateTime>(DatePickerPage(initial: _deadline)),
    );
    if (r != null && mounted) setState(() => _deadline = r);
  }

  Future<void> _addFiles() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final r = await Navigator.push<List<Attachment>>(
      context,
      appRoute<List<Attachment>>(AttachmentsPage(initial: _files)),
    );
    if (r != null && mounted) setState(() => _files = r);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      widget.draft.copyWith(
        message: _message.text.trim(),
        deadline: _deadline,
        attachments: _files,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Edit pesanan',
      subtitle: 'Perbarui detail kebutuhanmu',
      bottom: PrimaryButton(label: 'SIMPAN PERUBAHAN', onPressed: _save),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Reveal(
                child: AppTextField(
                  label: 'Pesan jasa',
                  hint: 'Jelaskan kebutuhan proyek secara rinci...',
                  controller: _message,
                  minLines: 4,
                  maxLines: 7,
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (t.isEmpty) return 'Deskripsi kebutuhan wajib diisi.';
                    if (t.length < 15) return 'Jelaskan sedikit lebih rinci, minimal 15 karakter.';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Reveal(
                index: 1,
                child: AppPickerField(
                  label: 'Estimasi deadline',
                  placeholder: 'Pilih tanggal',
                  value: formatTanggal(_deadline),
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(height: 14),
              Reveal(
                index: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('Lampiran', style: AppText.label)),
                        AppTextLink(label: 'Tambah', onTap: _addFiles),
                      ],
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          if (_files.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Belum ada lampiran.', style: AppText.body),
                              ),
                            ),
                          for (final f in _files)
                            Padding(
                              key: ValueKey(f.name),
                              padding: const EdgeInsets.only(bottom: 8),
                              child: PopIn(
                                child: FileRow(
                                  file: f,
                                  trailing: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => setState(() => _files.remove(f)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        'Hapus',
                                        style: AppText.error.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
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
