import 'package:flutter/material.dart';


import '../theme/app_colors.dart';
import '../theme/app_theme.dart';


/// Chip pilihan berbentuk pil.
/// [outlined] true: saat terpilih tampil garis emas (dipakai untuk Season),
/// false: saat terpilih tampil emas penuh (dipakai untuk filter kategori).
class PillChip extends StatelessWidget {
  const PillChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.outlined = false,
  });


  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final bool outlined;


  @override
  Widget build(BuildContext context) {
    final filled = selected && !outlined;
    final fg = filled
        ? AppColors.bgBase
        : selected
        ? AppColors.goldLight
        : AppColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: filled
              ? AppColors.gold
              : selected
              ? AppColors.goldTint
              : AppColors.bgElevated,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.borderSubtle,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppText.body(13, weight: FontWeight.w500, color: fg),
            ),
          ],
        ),
      ),
    );
  }
}


/// Label kecil non-interaktif (AI picks, Good light, Available, Cooldown).
class InfoChip extends StatelessWidget {
  const InfoChip({
    super.key,
    required this.label,
    this.icon,
    this.highlight = false,
  });


  final String label;
  final IconData? icon;
  final bool highlight;


  @override
  Widget build(BuildContext context) {
    final fg = highlight ? AppColors.goldLight : AppColors.textPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: highlight ? AppColors.goldTint : AppColors.bgElevated,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: highlight ? AppColors.gold : AppColors.borderSubtle,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppText.body(11, weight: FontWeight.w500, color: fg),
          ),
        ],
      ),
    );
  }
}


/// Badge "Cooldown" di atas kartu pakaian.
class CooldownBadge extends StatelessWidget {
  const CooldownBadge({super.key});


  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.bgBase,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.hourglass_bottom, size: 11, color: AppColors.gold),
        const SizedBox(width: 3),
        Text(
          'Cooldown',
          style: AppText.body(
            10,
            weight: FontWeight.w500,
            color: AppColors.goldLight,
          ),
        ),
      ],
    ),
  );
}


/// Toggle dua pilihan besar (Day/Month, Clothes/Outfits, Available/Cooldown).
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
    this.icons,
  });


  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  final List<IconData?>? icons;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == index ? AppColors.gold : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icons?[i] != null) ...[
                        Icon(
                          icons![i],
                          size: 16,
                          color: i == index
                              ? AppColors.bgBase
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        labels[i],
                        style: AppText.body(
                          14,
                          weight: FontWeight.w600,
                          color: i == index
                              ? AppColors.bgBase
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
