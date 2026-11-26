import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';

/// Garis status 4 titik: Ditinjau, Dikerjakan, Revisi, Selesai.
/// Garis terisi dan titik berubah dengan transisi saat [stage] berganti.
class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key, required this.stage});

  static const labels = ['Ditinjau', 'Dikerjakan', 'Revisi', 'Selesai'];

  /// 0..3
  final int stage;

  @override
  Widget build(BuildContext context) {
    final still = reduceMotion(context);
    final duration = Duration(milliseconds: still ? 0 : 600);

    return Semantics(
      label: 'Status pesanan: ${labels[stage]}',
      child: LayoutBuilder(
        builder: (context, box) {
          final slot = box.maxWidth / labels.length;
          final trackWidth = slot * (labels.length - 1);

          return Stack(
            children: [
              // Jalur dan isinya, sejajar dengan pusat titik (tinggi 14).
              Positioned(
                left: slot / 2,
                top: 6,
                child: SizedBox(
                  width: trackWidth,
                  height: 2,
                  child: Stack(
                    children: [
                      Container(color: AppColors.sky.withValues(alpha: 0.45)),
                      TweenAnimationBuilder<double>(
                        tween: Tween(end: stage / (labels.length - 1)),
                        duration: duration,
                        curve: Curves.easeOutCubic,
                        builder: (context, t, _) => FractionallySizedBox(
                          widthFactor: t.clamp(0.0, 1.0).toDouble(),
                          child: Container(color: AppColors.navyDeep),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < labels.length; i++)
                    SizedBox(
                      width: slot,
                      child: Column(
                        children: [
                          _Dot(filled: i <= stage, current: i == stage),
                          const SizedBox(height: 8),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 240),
                            style: AppText.subtitle.copyWith(
                              fontSize: 9.5,
                              fontWeight:
                                  i == stage ? FontWeight.w800 : FontWeight.w500,
                              color: i <= stage
                                  ? AppColors.textPrimary
                                  : AppColors.textMuted,
                            ),
                            child: Text(
                              labels[i],
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.filled, required this.current});

  final bool filled;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? AppColors.navyDeep : AppColors.card,
        border: Border.all(
          color: filled ? AppColors.navyDeep : AppColors.navyDeep.withValues(alpha: 0.75),
          width: 2,
        ),
      ),
    );
  }
}
