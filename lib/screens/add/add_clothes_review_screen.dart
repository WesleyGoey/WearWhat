import 'dart:math';


import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/clothing_art.dart';
import '../../widgets/headers.dart';


class AddClothesReviewScreen extends StatefulWidget {
  const AddClothesReviewScreen({super.key});


  @override
  State<AddClothesReviewScreen> createState() => _AddClothesReviewScreenState();
}


class _AddClothesReviewScreenState extends State<AddClothesReviewScreen> {
  static const _palette = [
    Color(0xFFF7F5F0),
    Color(0xFF243656),
    Color(0xFF6B7445),
    Color(0xFF1E1E1E),
    Color(0xFFB8925A),
    Color(0xFF4A6A96),
  ];


  // shortcut: hasil "AI" masih acak; ganti dengan model AI sortir foto (S3-03).
  final _rng = Random();
  late final ClothingCategory _detected =
      ClothingCategory.values[_rng.nextInt(ClothingCategory.values.length)];
  late final Color _color = _palette[_rng.nextInt(_palette.length)];
  late ClothingCategory _category = _detected;
  final Set<Season> _seasons = {Season.summer};


  void _save() {
    final state = AppState.instance;
    state.addItem(
      ClothingItem(
        id: state.newId(),
        category: _category,
        color: _color,
        seasons: {..._seasons},
      ),
    );
    state.setTab(1);
    Navigator.popUntil(context, ModalRoute.withName(Routes.main));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_category.label} saved to wardrobe.')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Review Item'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                children: [
                  Center(
                    child: SizedBox.square(
                      dimension: 180,
                      child: PaperCard(
                        radius: 24,
                        child: ClothingArt(
                          category: _category,
                          color: _color,
                          size: 140,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.bgElevated,
                        foregroundColor: AppColors.textPrimary,
                      ),
                      icon: const Icon(Icons.photo_camera_outlined, size: 16),
                      label: const Text('Retake'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.goldTint,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.goldDark),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.gold,
                          child: Icon(
                            Icons.auto_awesome,
                            color: AppColors.bgBase,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('AI DETECTED', style: AppText.eyebrow),
                            Text(
                              _detected.label,
                              style: AppText.body(16, weight: FontWeight.w600),
                            ),
                            Text(
                              'Not right? Change the category below.',
                              style: AppText.body(
                                11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Category',
                    style: AppText.body(13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final c in ClothingCategory.values)
                        PillChip(
                          label: c.label,
                          selected: c == _category,
                          onTap: () => setState(() => _category = c),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Season',
                          style: AppText.body(
                            13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextSpan(
                          text: '  · select all that fit',
                          style: AppText.body(
                            11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in Season.values)
                        PillChip(
                          label: s.label,
                          icon: s.icon,
                          outlined: true,
                          selected: _seasons.contains(s),
                          onTap: () => setState(
                            () => _seasons.contains(s)
                                ? _seasons.remove(s)
                                : _seasons.add(s),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: PrimaryButton(label: 'Save to Wardrobe', onPressed: _save),
            ),
          ],
        ),
      ),
    );
  }
}
