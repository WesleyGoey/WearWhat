import 'package:flutter/material.dart';


import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/clothing_art.dart';


/// Sheet konfirmasi simpan outfit.
/// Hasil: null kalau ditutup; ({date: null}) kalau simpan tanpa kalender;
/// ({date: tanggal}) kalau simpan sekaligus dijadwalkan.
Future<({DateTime? date})?> showSaveOutfitSheet(
  BuildContext context, {
  required List<ClothingItem> items,
  DateTime? initialDate,
}) {
  return showModalBottomSheet<({DateTime? date})>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _SaveOutfitSheet(items: items, initialDate: initialDate),
  );
}


class _SaveOutfitSheet extends StatefulWidget {
  const _SaveOutfitSheet({required this.items, this.initialDate});


  final List<ClothingItem> items;
  final DateTime? initialDate;


  @override
  State<_SaveOutfitSheet> createState() => _SaveOutfitSheetState();
}


class _SaveOutfitSheetState extends State<_SaveOutfitSheet> {
  late bool _addToCalendar = widget.initialDate != null;
  late DateTime _date = widget.initialDate ?? dateOnly(DateTime.now());


  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }


  @override
  Widget build(BuildContext context) {
    final labels = widget.items.map((i) => i.category.label).join(' · ');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Save Outfit', style: AppText.display(24)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    height: 64,
                    child: PaperCard(
                      radius: 10,
                      child: OutfitArt(items: widget.items, height: 60),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.items.length} items',
                          style: AppText.body(15, weight: FontWeight.w600),
                        ),
                        Text(
                          labels,
                          style: AppText.body(
                            12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add to calendar',
                        style: AppText.body(14, weight: FontWeight.w600),
                      ),
                      Text(
                        'Optional, you can schedule it later',
                        style: AppText.body(11, color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _addToCalendar,
                  activeTrackColor: AppColors.gold,
                  thumbColor: const WidgetStatePropertyAll(AppColors.paper),
                  onChanged: (v) => setState(() => _addToCalendar = v),
                ),
              ],
            ),
            if (_addToCalendar) ...[
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${fmtDay(_date)} ${_date.year}',
                        style: AppText.body(14),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.gold,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Save',
              onPressed: () =>
                  Navigator.pop(context, (date: _addToCalendar ? _date : null)),
            ),
          ],
        ),
      ),
    );
  }
}
