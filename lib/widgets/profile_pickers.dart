import 'package:flutter/material.dart';


import '../data/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';


/// Pilihan skin tone. [compact] true = 1 baris kecil (Edit Profile),
/// false = grid 3 kolom besar (Setup - Skin Tone).
class SkinTonePicker extends StatelessWidget {
  const SkinTonePicker({
    super.key,
    required this.selected,
    required this.onChanged,
    this.compact = false,
  });


  final int selected;
  final ValueChanged<int> onChanged;
  final bool compact;


  @override
  Widget build(BuildContext context) {
    final size = compact ? 40.0 : 64.0;
    Widget tone(int i) {
      final active = i == selected;
      return GestureDetector(
        onTap: () => onChanged(i),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: size,
                  height: size,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: active ? AppColors.gold : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: skinTones[i].color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                if (active && !compact)
                  const Positioned(
                    top: -2,
                    right: -2,
                    child: CircleAvatar(
                      radius: 11,
                      backgroundColor: AppColors.gold,
                      child: Icon(
                        Icons.check,
                        size: 14,
                        color: AppColors.bgBase,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              skinTones[i].name,
              style: AppText.body(
                compact ? 11 : 13,
                weight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? AppColors.goldLight : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }


    if (compact) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [for (var i = 0; i < skinTones.length; i++) tone(i)],
      );
    }
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      runSpacing: 20,
      children: [
        for (var i = 0; i < skinTones.length; i++)
          SizedBox(width: 100, child: Center(child: tone(i))),
      ],
    );
  }
}


/// Pilihan gender 3 kotak (Male, Female, Prefer not to say).
class GenderSelector extends StatelessWidget {
  const GenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });


  final Gender value;
  final ValueChanged<Gender> onChanged;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final g in Gender.values)
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(g),
              child: Container(
                height: 54,
                margin: EdgeInsets.only(right: g == Gender.values.last ? 0 : 8),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: g == value ? AppColors.goldTint : AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: g == value ? AppColors.gold : AppColors.borderSubtle,
                  ),
                ),
                child: Text(
                  g.label,
                  textAlign: TextAlign.center,
                  style: AppText.body(
                    13,
                    weight: FontWeight.w500,
                    color: g == value
                        ? AppColors.goldLight
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}


/// Avatar bulat warna skin tone (pengganti foto selfie).
class SelfieAvatar extends StatelessWidget {
  const SelfieAvatar({super.key, required this.tone, this.size = 72});


  final int tone;
  final double size;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold, width: 1.5),
      ),
      child: CircleAvatar(
        backgroundColor: const Color(0xFF3A3128),
        child: Icon(
          Icons.person,
          size: size * .62,
          color: skinTones[tone].color,
        ),
      ),
    );
  }
}
