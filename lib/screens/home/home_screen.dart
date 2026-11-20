import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/clothing_art.dart';
import '../../widgets/profile_pickers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 18) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(1.1, -1.1),
              radius: .9,
              colors: [Color(0x66C9A45C), AppColors.bgBase],
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: AppText.body(
                              14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(state.user.name, style: AppText.display(28)),
                        ],
                      ),
                    ),
                    CircleIconButton(
                      icon: Icons.notifications_none,
                      tooltip: 'Notifications',
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text('No new notifications.'),
                            ),
                          ),
                    ),
                    const SizedBox(width: 10),
                    // Revisi usability: avatar jadi tombol ke Profile.
                    GestureDetector(
                      onTap: () => state.setTab(3),
                      child: SelfieAvatar(tone: state.user.skinTone, size: 44),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const _WeatherCard(),
                const SizedBox(height: 24),
                _SectionTitle(
                  title: "Today's Outfit",
                  action: 'See calendar',
                  onTap: () => state.setTab(2),
                ),
                const SizedBox(height: 12),
                const _TodayOutfitCard(),
                const SizedBox(height: 24),
                _SectionTitle(
                  title: 'Recent Outfits',
                  onTap: () => state.setTab(1),
                ),
                const SizedBox(height: 12),
                const _RecentOutfits(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.action, required this.onTap});

  final String title;
  final String? action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Text(title, style: AppText.body(17, weight: FontWeight.w600)),
          if (action == null)
            const Icon(Icons.chevron_right, color: AppColors.gold)
          else ...[
            const Spacer(),
            Text(
              action!,
              style: AppText.body(
                12,
                weight: FontWeight.w500,
                color: AppColors.gold,
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gold, size: 18),
          ],
        ],
      ),
    );
  }
}

/// shortcut: cuaca masih data tetap; sambungkan ke API cuaca di Sprint 3.
class _WeatherCard extends StatelessWidget {
  const _WeatherCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withValues(alpha: .85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.goldDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("TODAY'S WEATHER", style: AppText.eyebrow),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.gold),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wb_sunny_outlined,
                      size: 12,
                      color: AppColors.goldLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Summer',
                      style: AppText.body(
                        11,
                        weight: FontWeight.w600,
                        color: AppColors.goldLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.wb_sunny_outlined,
                color: AppColors.gold,
                size: 34,
              ),
              const SizedBox(width: 12),
              Text('29°', style: AppText.display(32)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sunny',
                    style: AppText.body(14, weight: FontWeight.w600),
                  ),
                  Text(
                    'Surabaya',
                    style: AppText.body(12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: AppColors.borderSubtle, height: 20),
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 14, color: AppColors.gold),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Light & breathable, linen or cotton today',
                  style: AppText.body(12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TodayOutfitCard extends StatefulWidget {
  const _TodayOutfitCard();

  @override
  State<_TodayOutfitCard> createState() => _TodayOutfitCardState();
}

class _TodayOutfitCardState extends State<_TodayOutfitCard> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final today = dateOnly(DateTime.now());
    final outfits = state.outfitsOn(today);

    if (outfits.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          children: [
            Text(
              'No outfit planned for today',
              style: AppText.body(14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            OutlineGoldButton(
              label: 'Choose outfit',
              icon: Icons.add,
              height: 44,
              onPressed: () => state.setTab(2),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 168,
      child: PageView.builder(
        itemCount: outfits.length,
        onPageChanged: (i) => setState(() => _page = i),
        itemBuilder: (context, i) {
          final o = outfits[i];
          final items = state.itemsOf(o);
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              Routes.outfitDetail,
              arguments: {'outfitId': o.id, 'date': today},
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: PaperCard(
                      child: OutfitArt(items: items, height: 130),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${fmtDay(today).toUpperCase()} · ${i + 1} OF ${outfits.length}',
                                style: AppText.eyebrow,
                              ),
                            ),
                            for (var d = 0; d < outfits.length; d++)
                              Container(
                                width: d == _page ? 12 : 5,
                                height: 5,
                                margin: const EdgeInsets.only(left: 3),
                                decoration: BoxDecoration(
                                  color: d == _page
                                      ? AppColors.gold
                                      : AppColors.textTertiary,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(o.name, style: AppText.display(22)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            for (final it in items.take(3))
                              Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(right: 8),
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
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'See more ›',
                          style: AppText.body(
                            12,
                            weight: FontWeight.w500,
                            color: AppColors.gold,
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
      ),
    );
  }
}

class _RecentOutfits extends StatelessWidget {
  const _RecentOutfits();

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final today = dateOnly(DateTime.now());
    final recent = <(DateTime, Outfit)>[
      for (var d = 0; d < 14; d++)
        for (final o in state.outfitsOn(today.subtract(Duration(days: d))))
          (today.subtract(Duration(days: d)), o),
    ].take(8).toList();

    String label(DateTime d) {
      final diff = today.difference(d).inDays;
      if (diff == 0) return 'Today';
      if (diff == 1) return 'Yesterday';
      return '${d.day} ${monthShort[d.month - 1]}';
    }

    if (recent.isEmpty) {
      return Text(
        'Outfits you wear will show up here.',
        style: AppText.body(13, color: AppColors.textSecondary),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: recent.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final (date, outfit) = recent[i];
          return Column(
            children: [
              SizedBox(
                width: 92,
                height: 120,
                child: PaperCard(
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.outfitDetail,
                    arguments: {'outfitId': outfit.id, 'date': date},
                  ),
                  child: OutfitArt(items: state.itemsOf(outfit), height: 110),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label(date),
                style: AppText.body(11, color: AppColors.textSecondary),
              ),
            ],
          );
        },
      ),
    );
  }
}
