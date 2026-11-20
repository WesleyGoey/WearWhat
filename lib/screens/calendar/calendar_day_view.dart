import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/clothing_art.dart';
import '../../widgets/frames.dart';
import 'choose_outfit_sheet.dart';


/// Tampilan Day: strip 1 minggu, ringkasan, kartu outfit (swipe) atau kosong.
class CalendarDayView extends StatefulWidget {
  const CalendarDayView({
    super.key,
    required this.date,
    required this.onDateChanged,
  });


  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;


  @override
  State<CalendarDayView> createState() => _CalendarDayViewState();
}


class _CalendarDayViewState extends State<CalendarDayView> {
  int _page = 0;


  @override
  void didUpdateWidget(CalendarDayView old) {
    super.didUpdateWidget(old);
    if (old.date != widget.date) _page = 0;
  }


  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final date = widget.date;
    final sunday = date.subtract(Duration(days: date.weekday % 7));
    final outfits = state.outfitsOn(date);
    if (_page >= outfits.length) _page = 0;


    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < 7; i++) _dayCell(sunday.add(Duration(days: i))),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.goldTint,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.goldDark),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.gold,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      outfits.isEmpty
                          ? 'No outfits planned'
                          : '${outfits.length} outfit${outfits.length > 1 ? 's' : ''} planned',
                      style: AppText.body(13, weight: FontWeight.w600),
                    ),
                    Text(
                      fmtDayLong(date),
                      style: AppText.body(11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (outfits.length > 1)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${_page + 1} / ${outfits.length}',
                    style: AppText.body(
                      11,
                      weight: FontWeight.w700,
                      color: AppColors.bgBase,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(child: outfits.isEmpty ? _empty() : _cards(outfits)),
      ],
    );
  }


  Widget _dayCell(DateTime d) {
    final selected = dateOnly(d) == dateOnly(widget.date);
    final planned = AppState.instance.outfitsOn(d).isNotEmpty;
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onDateChanged(dateOnly(d)),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Text(
              weekdayShort[d.weekday - 1],
              style: AppText.body(11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Container(
              width: 38,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.gold : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${d.day}',
                style: AppText.body(
                  16,
                  weight: FontWeight.w600,
                  color: selected ? AppColors.bgBase : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            CircleAvatar(
              radius: 2.5,
              backgroundColor: planned ? AppColors.gold : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }


  Widget _empty() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DashedBox(
        radius: 24,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.goldTint,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.goldDark),
                ),
                child: const Icon(
                  Icons.checkroom,
                  color: AppColors.gold,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text('Nothing planned yet', style: AppText.display(20)),
              const SizedBox(height: 4),
              Text(
                'Pick a saved outfit for this day.',
                style: AppText.body(12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => showChooseOutfitSheet(context, widget.date),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.bgBase,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Choose outfit'),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _cards(List<Outfit> outfits) {
    final state = AppState.instance;
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: outfits.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) {
              final o = outfits[i];
              final items = state.itemsOf(o);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, c) => PaperCard(
                          radius: 16,
                          child: OutfitArt(
                            items: items,
                            height: c.maxHeight * .9,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'OUTFIT ${i + 1} OF ${outfits.length}',
                                style: AppText.eyebrow,
                              ),
                              Text(o.name, style: AppText.display(22)),
                              Text(
                                items.map((e) => e.category.label).join(' · '),
                                style: AppText.body(
                                  11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            Routes.outfitDetail,
                            arguments: {'outfitId': o.id, 'date': widget.date},
                          ),
                          child: Text(
                            'Details ›',
                            style: AppText.body(
                              12,
                              weight: FontWeight.w600,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (outfits.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '↔  Swipe to see the next outfit',
              style: AppText.body(11, color: AppColors.textTertiary),
            ),
          )
        else
          const SizedBox(height: 12),
      ],
    );
  }
}
