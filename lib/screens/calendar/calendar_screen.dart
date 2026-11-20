import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/chips.dart';
import 'calendar_day_view.dart';
import 'calendar_month_view.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _mode = 0; // 0 Day, 1 Month
  DateTime _date = dateOnly(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text('Calendar', style: AppText.display(32))),
                  OutlinedButton(
                    onPressed: () => setState(() {
                      _date = dateOnly(DateTime.now());
                      _mode = 0;
                    }),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      side: const BorderSide(color: AppColors.gold),
                    ),
                    child: const Text('Today'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SegmentedTabs(
                labels: const ['Day', 'Month'],
                index: _mode,
                onChanged: (i) => setState(() => _mode = i),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _mode == 0
                    ? CalendarDayView(
                        date: _date,
                        onDateChanged: (d) => setState(() => _date = d),
                      )
                    : CalendarMonthView(
                        selected: _date,
                        onOpenDay: (d) => setState(() {
                          _date = d;
                          _mode = 0;
                        }),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
