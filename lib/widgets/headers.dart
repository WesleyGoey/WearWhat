import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'buttons.dart';

/// Logo teks "WearWhat" ("What" miring warna emas).
class WearWhatLogo extends StatelessWidget {
  const WearWhatLogo({super.key, this.size = 22});

  final double size;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      children: [
        TextSpan(text: 'Wear', style: AppText.display(size)),
        TextSpan(
          text: 'What',
          style: AppText.display(
            size,
            style: FontStyle.italic,
            color: AppColors.gold,
          ),
        ),
      ],
    ),
  );
}

/// Baris atas: tombol Back (kembali ke layar sebelumnya) + judul di tengah.
class BackHeader extends StatelessWidget {
  const BackHeader({super.key, this.title, this.titleWidget, this.trailing});

  final String? title;
  final Widget? titleWidget;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Row(
        children: [
          CircleIconButton(
            icon: Icons.arrow_back,
            tooltip: 'Back',
            onPressed: () => Navigator.maybePop(context),
          ),
          Expanded(
            child: Center(
              child:
                  titleWidget ??
                  Text(
                    title ?? '',
                    style: AppText.body(16, weight: FontWeight.w600),
                  ),
            ),
          ),
          SizedBox(width: 40, child: trailing),
        ],
      ),
    );
  }
}

/// Header onboarding: Back + progress bar 3 langkah + "1/3".
class StepHeader extends StatelessWidget {
  const StepHeader({super.key, required this.step, this.total = 3});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Row(
        children: [
          CircleIconButton(
            icon: Icons.arrow_back,
            tooltip: 'Back',
            onPressed: () => Navigator.maybePop(context),
          ),
          const SizedBox(width: 12),
          for (var i = 1; i <= total; i++)
            Expanded(
              child: Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: i <= step ? AppColors.gold : AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          const SizedBox(width: 8),
          Text(
            '$step/$total',
            style: AppText.body(12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Judul layar: eyebrow kecil emas, judul serif, subjudul abu.
class ScreenTitle extends StatelessWidget {
  const ScreenTitle({
    super.key,
    this.eyebrow,
    required this.title,
    this.subtitle,
  });

  final String? eyebrow;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Text(eyebrow!.toUpperCase(), style: AppText.eyebrow),
          const SizedBox(height: 10),
        ],
        Text(title, style: AppText.display(30)),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: AppText.body(14, color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }
}
