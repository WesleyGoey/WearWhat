import 'package:flutter/foundation.dart';
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


  // shortcut: deteksi AI belum ada di MVP, jadi user memilih kategori dan
  // warna sendiri. Ganti dengan model AI sortir foto (S3-03).
  ClothingCategory _category = ClothingCategory.top;
  Color _color = _palette.first;
  final Set<Season> _seasons = {Season.summer};
  bool _saving = false;


  Future<void> _save(Uint8List? photo) async {
    final state = AppState.instance;
    final category = _category;
    setState(() => _saving = true);
    try {
      await state.addItem(
        ClothingItem(
          id: state.newId(),
          category: category,
          color: _color,
          seasons: {..._seasons},
        ),
        photo: photo,
      );
    } catch (e) {
      debugPrint('Save item failed: $e');
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save. Check your connection.')),
      );
      return;
    }
    if (!mounted) return;
    state.setTab(1);
    Navigator.popUntil(context, ModalRoute.withName(Routes.main));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${category.label} saved to wardrobe.')),
    );
  }


  @override
  Widget build(BuildContext context) {
    final photo = ModalRoute.of(context)!.settings.arguments as Uint8List?;
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
                        child: photo == null
                            ? ClothingArt(
                                category: _category,
                                color: _color,
                                size: 140,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.memory(
                                  photo,
                                  width: 180,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
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
                            Icons.edit_outlined,
                            color: AppColors.bgBase,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('AI COMING SOON', style: AppText.eyebrow),
                            Text(
                              'Tag it yourself',
                              style: AppText.body(16, weight: FontWeight.w600),
                            ),
                            Text(
                              'Pick the category, colour, and season below.',
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
                  Text(
                    'Colour',
                    style: AppText.body(13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final c in _palette)
                        GestureDetector(
                          onTap: () => setState(() => _color = c),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: c == _color
                                    ? AppColors.gold
                                    : AppColors.borderSubtle,
                                width: c == _color ? 3 : 1,
                              ),
                            ),
                          ),
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
              child: PrimaryButton(
                label: _saving ? 'Saving...' : 'Save to Wardrobe',
                onPressed: _saving ? null : () => _save(photo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
