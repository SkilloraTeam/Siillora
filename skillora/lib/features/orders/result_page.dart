import 'package:flutter/material.dart';

import '../../core/motion/reveal.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/flow_scaffold.dart';
import '../../core/widgets/pressable.dart';
import '../order/placed_order.dart';

/// Layar 24: hasil pesanan dan catatan dari penyedia jasa.
class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.order});

  final PlacedOrder order;

  @override
  Widget build(BuildContext context) {
    final file = order.result;

    return FlowScaffold(
      title: 'Hasil pesanan',
      subtitle: 'File akhir dari penyedia jasa',
      bottom: PrimaryButton(
        label: 'KEMBALI KE DETAIL PESANAN',
        onPressed: () => Navigator.maybePop(context),
      ),
      children: [
        if (file != null)
          Reveal(
            child: Pressable(
              onTap: () {
                // TODO: unduh berkas dari Supabase Storage.
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Unduh berkas belum tersambung.')),
                  );
              },
              scale: 0.98,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.mist,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        file.ext,
                        style: AppText.label.copyWith(fontSize: 10.5, color: AppColors.navyDeep),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.label.copyWith(fontSize: 12.5),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${file.ext} • ${formatUkuranFile(file.sizeBytes)}',
                            style: AppText.subtitle.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      size: 18,
                      color: AppColors.navyDeep,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Reveal(
            child: Text('Belum ada hasil dari penyedia jasa.', style: AppText.body),
          ),
        const SizedBox(height: 22),
        Reveal(index: 1, child: Text('Catatan penyedia jasa', style: AppText.label)),
        const SizedBox(height: 8),
        Reveal(
          index: 2,
          child: Text(
            order.providerNote ?? 'Penyedia jasa belum menambahkan catatan.',
            style: AppText.body.copyWith(color: AppColors.textPrimary, height: 1.6),
          ),
        ),
      ],
    );
  }
}
