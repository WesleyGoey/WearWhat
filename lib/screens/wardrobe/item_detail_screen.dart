import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/chips.dart';
import '../../widgets/clothing_art.dart';
import '../../widgets/headers.dart';


/// Detail satu pakaian. arguments: id item (String).
class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final it = state.item(id);
        final usedIn = state.outfitsUsing(it);
        final last = it.lastWorn;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const BackHeader(title: 'Item Detail'),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [
                      SizedBox(
                        height: 250,
                        child: PaperCard(
                          radius: 24,
                          child: ClothingArt(
                            category: it.category,
                            color: it.color,
                            size: 200,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(it.category.label, style: AppText.display(30)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final s in it.seasons)
                            InfoChip(
                              label: s.label,
                              icon: s.icon,
                              highlight: true,
                            ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _Stat(label: 'WORN', value: '${it.worn}×'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _Stat(
                              label: 'LAST WORN',
                              value: last == null
                                  ? 'Never'
                                  : '${last.day} ${monthShort[last.month - 1]}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Status',
                        style: AppText.body(15, weight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      SegmentedTabs(
                        labels: const ['Available', 'Cooldown'],
                        icons: const [null, Icons.hourglass_bottom],
                        index: it.cooldown ? 1 : 0,
                        onChanged: (i) => state.setCooldown(it, i == 1),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Switches to Cooldown automatically after this item is worn. You can change it any time.',
                        style: AppText.body(12, color: AppColors.textTertiary),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Used in outfits',
                        style: AppText.body(15, weight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      if (usedIn.isEmpty)
                        Text(
                          'Not in any outfit yet.',
                          style: AppText.body(
                            12,
                            color: AppColors.textSecondary,
                          ),
                        )
                      else
                        SizedBox(
                          height: 76,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: usedIn.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, i) => SizedBox(
                              width: 60,
                              child: PaperCard(
                                radius: 12,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  Routes.outfitDetail,
                                  arguments: {'outfitId': usedIn[i].id},
                                ),
                                child: OutfitArt(
                                  items: state.itemsOf(usedIn[i]),
                                  height: 70,
                                ),
                              ),
                            ),
                          ),
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


class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});


  final String label;
  final String value;


  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.bgElevated,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.borderSubtle),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.eyebrow),
        const SizedBox(height: 6),
        Text(value, style: AppText.display(24)),
      ],
    ),
  );
}
