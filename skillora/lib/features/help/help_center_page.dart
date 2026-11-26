import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/navy_banner.dart';
import '../../core/widgets/pressable.dart';
import 'help_guide_page.dart';
import 'help_topics.dart';

/// Layar 39: Pusat bantuan dengan pencarian dan pertanyaan umum.
class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final _query = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.text.trim().toLowerCase();
    final items = [
      for (final t in helpTopics)
        if (q.isEmpty || t.question.toLowerCase().contains(q)) t,
    ];

    return FlowScaffold(
      title: 'Pusat bantuan',
      subtitle: 'Kami siap membantu kamu',
      children: [
        const Reveal(
          child: NavyBanner(
            title: 'Ada yang bisa kami bantu?',
            subtitle: 'Temukan jawaban seputar penggunaan Ruang Karya.',
          ),
        ),
        const SizedBox(height: 14),
        Reveal(
          index: 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _focus.hasFocus ? AppColors.fieldFocus : AppColors.fieldBorder,
                width: _focus.hasFocus ? 1.6 : 1.1,
              ),
            ),
            child: TextField(
              controller: _query,
              focusNode: _focus,
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.search,
              style: AppText.input,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Cari topik bantuan...',
                hintStyle: AppText.hint,
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textHint),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Reveal(index: 2, child: Text('Pertanyaan umum', style: AppText.sectionTitle)),
        const SizedBox(height: 10),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Text(
                'Tidak ada topik untuk "${_query.text.trim()}".',
                style: AppText.subtitle,
              ),
            ),
          ),
        for (var i = 0; i < items.length; i++)
          Padding(
            key: ValueKey(items[i].question),
            padding: const EdgeInsets.only(bottom: 8),
            child: Reveal(
              index: i + 3,
              child: Pressable(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.push(context, appRoute(HelpGuidePage(topic: items[i])));
                },
                scale: 0.98,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          items[i].question,
                          style: AppText.label.copyWith(fontSize: 12),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: 10),
        Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Masih butuh bantuan? ', style: AppText.subtitle),
                TextSpan(text: 'Hubungi tim kami.', style: AppText.link),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
