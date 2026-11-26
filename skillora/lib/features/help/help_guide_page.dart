import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/flow_scaffold.dart';
import 'help_topics.dart';

/// Layar 40: langkah-langkah satu topik bantuan.
/// Langkah memang berurutan, jadi diberi nomor.
class HelpGuidePage extends StatelessWidget {
  const HelpGuidePage({super.key, required this.topic});

  final HelpTopic topic;

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: topic.pageTitle,
      subtitle: 'Panduan penggunaan aplikasi',
      children: [
        for (var i = 0; i < topic.steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Reveal(
              index: i,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${i + 1}. ${topic.steps[i].title}',
                      style: AppText.label.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      topic.steps[i].body,
                      style: AppText.subtitle.copyWith(fontSize: 11.5),
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
