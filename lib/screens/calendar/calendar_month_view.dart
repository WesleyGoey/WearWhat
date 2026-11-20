import 'package:flutter/material.dart';


import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/clothing_art.dart';
import 'choose_outfit_sheet.dart';


/// Tampilan Month: grid tanggal dengan thumbnail outfit (revisi usability).
/// Tap thumbnail = buka hari itu di tampilan Day. Tap + = pilih outfit.
class CalendarMonthView extends StatefulWidget {
  const CalendarMonthView({
    super.key,
    required this.selected,
    required this.onOpenDay,
  });


  final DateTime selected;
  final ValueChanged<DateTime> onOpenDay;


  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}


class _CalendarMonthViewState extends State<CalendarMonthView> {
  late DateTime _month = DateTime(widget.selected.year, widget.selected.month);


  void _shift(int months) =>
      setState(() => _month = DateTime(_month.year, _month.month + months));


  @override
  Widget build(BuildContext context) {
    final first = _month;
    final daysInMonth = DateTime(first.year, first.month + 1, 0).day;
    final leading = first.weekday % 7; // Minggu = kolom pertama
    final cells = leading + daysInMonth;
    final rows = (cells / 7).ceil();
    final today = dateOnly(DateTime.now());


    return Column(
      children: [
        Row(
          children: [
            CircleIconButton(
              icon: Icons.chevron_left,
              size: 34,
              tooltip: 'Previous month',
              onPressed: () => _shift(-1),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '${monthLong[first.month - 1]} ${first.year}',
                  style: AppText.display(20),
                ),
              ),
            ),
            CircleIconButton(
              icon: Icons.chevron_right,
              size: 34,
              tooltip: 'Next month',
              onPressed: () => _shift(1),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (final d in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'])
              Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: AppText.body(10, color: AppColors.textTertiary),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              for (var r = 0; r < rows; r++)
                Row(
                  children: [
                    for (var c = 0; c < 7; c++)
                      Expanded(
                        child: _cell(
                          r * 7 + c - leading + 1,
                          daysInMonth,
                          today,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _cell(int day, int daysInMonth, DateTime today) {
    if (day < 1 || day > daysInMonth) return const SizedBox(height: 74);
    final state = AppState.instance;
    final date = DateTime(_month.year, _month.month, day);
    final outfits = state.outfitsOn(date);
    final isToday = date == today;


    return SizedBox(
      height: 74,
      child: Column(
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isToday ? AppColors.gold : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$day',
              style: AppText.body(
                11,
                weight: FontWeight.w600,
                color: isToday ? AppColors.bgBase : AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: outfits.isEmpty
                  ? Material(
                      color: AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => showChooseOutfitSheet(context, date),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 16,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    )
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: PaperCard(
                            radius: 8,
                            onTap: () => widget.onOpenDay(date),
                            child: OutfitArt(
                              items: state.itemsOf(outfits.first),
                              height: 44,
                            ),
                          ),
                        ),
                        if (outfits.length > 1)
                          Positioned(
                            right: -4,
                            top: -4,
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: AppColors.gold,
                              child: Text(
                                '${outfits.length}',
                                style: AppText.body(
                                  8,
                                  weight: FontWeight.w700,
                                  color: AppColors.bgBase,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
