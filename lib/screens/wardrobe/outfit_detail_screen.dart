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

/// Detail outfit. arguments: {'outfitId': String, 'date': DateTime?}.
/// Kalau dibuka dari kalender (ada date), tombol "Remove from day" muncul.
class OutfitDetailScreen extends StatelessWidget {
  const OutfitDetailScreen({super.key});

  Future<void> _delete(BuildContext context, Outfit o) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Delete ${o.name}?'),
        content: const Text('It will also be removed from your calendar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    Navigator.pop(context);
    AppState.instance.deleteOutfit(o.id);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final id = args['outfitId'] as String;
    final date = args['date'] as DateTime?;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final o = state.outfitOrNull(id);
        if (o == null) return const Scaffold();
        final items = state.itemsOf(o);
        final dayOutfits = date == null ? <Outfit>[] : state.outfitsOn(date);
        final index = dayOutfits.indexOf(o);

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const BackHeader(title: 'Outfit Detail'),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [
                      SizedBox(
                        height: 250,
                        child: PaperCard(
                          radius: 24,
                          child: OutfitArt(items: items, height: 230),
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (date != null && index >= 0)
                        Text(
                          '${fmtDay(date).toUpperCase()} · OUTFIT ${index + 1} OF ${dayOutfits.length}',
                          style: AppText.eyebrow,
                        ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(o.name, style: AppText.display(28)),
                          ),
                          // Revisi usability (Temuan 2): petunjuk item bisa di-tap.
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              'Tap an item for details',
                              style: AppText.body(
                                11,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      for (final it in items)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.bgElevated,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.itemDetail,
                              arguments: it.id,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.paper,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClothingArt(
                                    category: it.category,
                                    color: it.color,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        it.category.label,
                                        style: AppText.body(
                                          14,
                                          weight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Worn ${it.worn}×',
                                        style: AppText.body(
                                          11,
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InfoChip(
                                  label: it.cooldown ? 'Cooldown' : 'Available',
                                  icon: it.cooldown
                                      ? Icons.hourglass_bottom
                                      : null,
                                  highlight: it.cooldown,
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.chevron_right,
                                  color: AppColors.gold,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (state.isWornToday(o))
                        const SecondaryButton(
                          label: 'Worn today',
                          icon: Icons.check,
                          color: AppColors.textTertiary,
                          onPressed: null,
                        )
                      else
                        PrimaryButton(
                          label: 'Mark as Worn',
                          icon: Icons.check,
                          onPressed: () {
                            state.markWorn(o);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: const Text('Outfit marked as worn'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      color: AppColors.gold,
                                    ),
                                  ),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    textColor: AppColors.gold,
                                    onPressed: () => state.undoWorn(o),
                                  ),
                                ),
                              );
                          },
                        ),
                      const SizedBox(height: 16),
                      // Revisi usability (Temuan 2): garis pemisah aksi utama dan aksi lain.
                      const Divider(height: 1, color: AppColors.borderSubtle),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          OutlineGoldButton(
                            label: 'Edit',
                            icon: Icons.edit_outlined,
                            height: 46,
                            expand: false,
                            onPressed: () => Navigator.pushNamed(
                              context,
                              Routes.addOutfit,
                              arguments: {'outfitId': o.id},
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (date != null && index >= 0)
                            Expanded(
                              child: SecondaryButton(
                                label: 'Remove from day',
                                height: 46,
                                onPressed: () {
                                  state.unplan(date, o.id);
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          else
                            const Spacer(),
                          TextButton(
                            onPressed: () => _delete(context, o),
                            child: Text(
                              'Delete',
                              style: AppText.body(
                                14,
                                weight: FontWeight.w600,
                                color: AppColors.danger,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
