import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/motion/motion.dart';
import '../order/placed_order.dart';
import 'review_sent_page.dart';

/// Layar 25: beri ulasan. Mengembalikan true lewat Navigator.pop saat terkirim.
class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key, required this.order});

  final PlacedOrder order;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  static const _gold = Color(0xFFE5A02B);
  static const _labels = ['Kurang', 'Cukup', 'Baik', 'Sangat baik', 'Luar biasa'];

  final _comment = TextEditingController();
  int _rating = 0;
  bool _sending = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _sending = true);
    // TODO: simpan ulasan ke Supabase.
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    OrderStore.instance.submitReview(
      widget.order.id,
      _rating,
      _comment.text.trim(),
    );
    Navigator.pushReplacement<bool, bool>(
      context,
      appRoute<bool>(const ReviewSentPage()),
      result: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.order.service;

    return FlowScaffold(
      title: 'Beri ulasan',
      subtitle: 'Bagikan pengalamanmu',
      bottom: PrimaryButton(
        label: 'KIRIM ULASAN',
        loading: _sending,
        onPressed: _rating == 0 ? null : _send,
      ),
      children: [
        Reveal(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.title, style: AppText.label.copyWith(fontSize: 13)),
                const SizedBox(height: 2),
                Text(s.seller, style: AppText.subtitle.copyWith(fontSize: 11)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 26),
        Reveal(
          index: 1,
          child: Center(
            child: Text('Bagaimana hasil pekerjaan ini?', style: AppText.label.copyWith(fontSize: 13.5)),
          ),
        ),
        const SizedBox(height: 10),
        Reveal(
          index: 2,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 1; i <= 5; i++)
                    _Star(
                      filled: i <= _rating,
                      color: _gold,
                      label: 'Beri $i bintang',
                      onTap: () => setState(() => _rating = i),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 18,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Text(
                    _rating == 0 ? '' : _labels[_rating - 1],
                    key: ValueKey(_rating),
                    style: AppText.subtitle.copyWith(fontSize: 11.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Reveal(
          index: 3,
          child: AppTextField(
            label: 'Komentar kinerja',
            hint: 'Tuliskan pengalaman dan masukanmu...',
            controller: _comment,
            minLines: 4,
            maxLines: 7,
          ),
        ),
      ],
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({
    required this.filled,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final bool filled;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: filled,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: AnimatedScale(
              scale: filled ? 1 : 0.85,
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutBack,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: Icon(
                  filled ? Icons.star_rounded : Icons.star_outline_rounded,
                  key: ValueKey(filled),
                  size: 32,
                  color: filled ? color : AppColors.fieldBorder,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
