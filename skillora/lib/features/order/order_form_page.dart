import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_picker_field.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import '../catalog/service_model.dart';
import 'attachments_page.dart';
import 'date_picker_page.dart';
import 'order_model.dart';
import 'order_summary_page.dart';
import 'widgets/file_row.dart';

/// Layar 11: form pesan jasa.
class OrderFormPage extends StatefulWidget {
  const OrderFormPage({super.key, required this.service});

  final Service service;

  @override
  State<OrderFormPage> createState() => _OrderFormPageState();
}

class _OrderFormPageState extends State<OrderFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _message = TextEditingController();

  DateTime? _deadline;
  List<Attachment> _files = const [];
  bool _tried = false;

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

  Future<void> _pickFiles() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final r = await Navigator.push<List<Attachment>>(
      context,
      appRoute<List<Attachment>>(AttachmentsPage(initial: _files)),
    );
    if (r != null && mounted) setState(() => _files = r);
  }

  void _next() {
    setState(() => _tried = true);
    final valid = _formKey.currentState!.validate();
    if (!valid || _deadline == null) return;

    Navigator.push(
      context,
      appRoute(
        OrderSummaryPage(
          draft: OrderDraft(
            service: widget.service,
            message: _message.text.trim(),
            deadline: _deadline!,
            attachments: _files,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Pesan jasa',
      subtitle: 'Lengkapi kebutuhan proyek kamu',
      bottom: PrimaryButton(label: 'LANJUTKAN', onPressed: _next),
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Reveal(child: _ServiceCard(service: widget.service)),
              const SizedBox(height: 20),
              Reveal(
                index: 1,
                child: AppTextField(
                  label: 'Pesan jasa / deskripsi kebutuhan',
                  hint: 'Jelaskan kebutuhan proyek secara rinci...',
                  controller: _message,
                  minLines: 4,
                  maxLines: 7,
                  helper: 'Contoh: Saya membutuhkan desain aplikasi pemesanan '
                      'makanan dengan 5 halaman utama.',
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
                index: 2,
                child: AppPickerField(
                  label: 'Estimasi deadline',
                  placeholder: 'Pilih tanggal',
                  value: _deadline == null ? null : formatTanggal(_deadline!),
                  errorText: _tried && _deadline == null
                      ? 'Pilih estimasi tanggal selesai.'
                      : null,
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(height: 20),
              Reveal(
                index: 3,
                child: _AttachmentSection(files: _files, onTap: _pickFiles),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Layanan dipilih', style: AppText.label),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppColors.sky,
                  shape: BoxShape.circle,
                ),
                child: Icon(service.icon, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.label.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 1),
                    Text(service.seller, style: AppText.subtitle.copyWith(fontSize: 11)),
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

class _AttachmentSection extends StatelessWidget {
  const _AttachmentSection({required this.files, required this.onTap});

  final List<Attachment> files;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final has = files.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lampiran (opsional)', style: AppText.label),
        const SizedBox(height: 6),
        Pressable(
          onTap: onTap,
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
                SizedBox(
                  width: 24,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      has ? Icons.attach_file_rounded : Icons.add_rounded,
                      key: ValueKey(has),
                      size: 22,
                      color: AppColors.sky,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        has
                            ? '${files.length} lampiran dipilih'
                            : 'Unggah brief, referensi, atau material',
                        style: AppText.label.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        has ? 'Ketuk untuk mengubah' : 'PDF, PNG, JPG',
                        style: AppText.subtitle.copyWith(fontSize: 11),
                      ),
                    ],
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
              for (final f in files)
                Padding(
                  key: ValueKey(f.name),
                  padding: const EdgeInsets.only(top: 8),
                  child: PopIn(child: FileRow(file: f)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
