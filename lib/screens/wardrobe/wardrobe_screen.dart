import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/clothing_art.dart';
import '../../widgets/item_image.dart';


class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});


  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}


class _WardrobeScreenState extends State<WardrobeScreen> {
  int _tab = 0; // 0 Clothes, 1 Outfits
  ClothingCategory? _filter; // null = All


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text('Wardrobe', style: AppText.display(32))),
                  CircleIconButton(
                    icon: Icons.search,
                    tooltip: 'Search',
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Search is coming soon.')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SegmentedTabs(
                labels: const ['Clothes', 'Outfits'],
                index: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: 14),
              Expanded(child: _tab == 0 ? _clothes() : _outfits()),
            ],
          ),
        ),
      ),
    );
  }


  Widget _clothes() {
    final state = AppState.instance;
    final list = state.items
        .where((i) => _filter == null || i.category == _filter)
        .toList();
    final cooldown = list.where((i) => i.cooldown).length;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final c in <ClothingCategory?>[
                null,
                ...ClothingCategory.values,
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: PillChip(
                    label: c?.label ?? 'All',
                    selected: c == _filter,
                    onTap: () => setState(() => _filter = c),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${list.length} items',
                style: AppText.body(12, color: AppColors.textSecondary),
              ),
              TextSpan(
                text: '  ·  $cooldown in cooldown',
                style: AppText.body(12, color: AppColors.gold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 14,
              crossAxisSpacing: 10,
              childAspectRatio: .74,
            ),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final it = list[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: PaperCard(
                      dimmed: it.cooldown,
                      badge: it.cooldown ? const CooldownBadge() : null,
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.itemDetail,
                        arguments: it.id,
                      ),
                      child: ItemImage(item: it, size: 70),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    it.category.label,
                    style: AppText.body(13, weight: FontWeight.w600),
                  ),
                  Text(
                    'Worn ${it.worn}×',
                    style: AppText.body(11, color: AppColors.textTertiary),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }


  Widget _outfits() {
    final state = AppState.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${state.outfits.length} outfits',
          style: AppText.body(12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 12,
              childAspectRatio: .66,
            ),
            itemCount: state.outfits.length,
            itemBuilder: (context, i) {
              final o = state.outfits[i];
              final next = state.nextPlanOf(o);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PaperCard(
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.outfitDetail,
                        arguments: {'outfitId': o.id},
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: OutfitArt(
                              items: state.itemsOf(o),
                              height: 170,
                            ),
                          ),
                          if (next != null)
                            Positioned(
                              left: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.bgBase,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 11,
                                      color: AppColors.gold,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${next.day} ${monthShort[next.month - 1]}',
                                      style: AppText.body(
                                        10,
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    o.name,
                    style: AppText.body(14, weight: FontWeight.w600),
                  ),
                  Text(
                    '${o.items.length} items',
                    style: AppText.body(11, color: AppColors.textTertiary),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
