import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import '../order/order_model.dart';
import '../order/widgets/file_row.dart';
import 'payment_model.dart';
import 'payment_sent_page.dart';

/// Layar 29: unggah bukti pembayaran.
class UploadProofPage extends StatefulWidget {
  const UploadProofPage({
    super.key,
    required this.orderId,
    this.picker = pickSampleProof,
  });

  final String orderId;
  final Future<Attachment?> Function() picker;

  @override
  State<UploadProofPage> createState() => _UploadProofPageState();
}

class _UploadProofPageState extends State<UploadProofPage> {
  Attachment? _file;
  bool _picking = false;
  bool _sending = false;

  Future<void> _pick() async {
    if (_picking || _sending) return;
    setState(() => _picking = true);
    final f = await widget.picker();
    if (!mounted) return;
    setState(() {
      _picking = false;
      if (f != null) _file = f;
    });
  }

  Future<void> _send() async {
    final file = _file;
    if (file == null) return;
    setState(() => _sending = true);
    // TODO: unggah ke Supabase Storage, lalu simpan alamat berkasnya.
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    PaymentStore.instance.submitProof(widget.orderId, file);
    Navigator.pushReplacement(
      context,
      appRoute(PaymentSentPage(orderId: widget.orderId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final file = _file;

    return FlowScaffold(
      title: 'Unggah bukti',
      subtitle: 'Pilih bukti transfer QRIS',
      bottom: PrimaryButton(
        label: 'KIRIM BUKTI PEMBAYARAN',
        loading: _sending,
        onPressed: file == null ? null : _send,
      ),
      children: [
        Reveal(
          child: Pressable(
            onTap: _pick,
            scale: 0.98,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 26),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.7)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.mist,
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: _picking
                          ? const Padding(
                              key: ValueKey('busy'),
                              padding: EdgeInsets.all(14),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.navyDeep,
                              ),
                            )
                          : const Icon(
                              Icons.add_rounded,
                              key: ValueKey('add'),
                              size: 24,
                              color: AppColors.navyDeep,
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    file == null ? 'Pilih gambar PNG atau JPG' : 'Ganti gambar',
                    style: AppText.label.copyWith(fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: file == null
              ? const SizedBox(width: double.infinity)
              : PopIn(
                  key: ValueKey(file.name),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bukti pembayaran terpilih', style: AppText.sectionTitle),
                        const SizedBox(height: 10),
                        FileRow(
                          file: file,
                          trailing: Pressable(
                            onTap: () => setState(() => _file = null),
                            scale: 0.95,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                              child: Center(
                                child: Text(
                                  'Hapus',
                                  style: AppText.label.copyWith(
                                    fontSize: 11.5,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
