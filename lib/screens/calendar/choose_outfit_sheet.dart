import 'package:flutter/material.dart';


import '../../app/routes.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/clothing_art.dart';


/// Sheet baru hasil usability testing: pilih outfit tersimpan untuk satu hari.
Future<void> showChooseOutfitSheet(BuildContext context, DateTime date) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => FractionallySizedBox(
      heightFactor: .8,
      child: _ChooseOutfitSheet(
        date: date,
        onCreateNew: () {
          Navigator.pop(sheetContext);
          Navigator.pushNamed(
            context,
            Routes.addOutfit,
            arguments: {'date': date},
          );
        },
      ),
    ),
  );
}


class _ChooseOutfitSheet extends StatefulWidget {
  const _ChooseOutfitSheet({required this.date, required this.onCreateNew});


  final DateTime date;
  final VoidCallback onCreateNew;


  @override
  State<_ChooseOutfitSheet> createState() => _ChooseOutfitSheetState();
}


class _ChooseOutfitSheetState extends State<_ChooseOutfitSheet> {
  String? _picked;


  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final day = fmtDay(widget.date);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
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
            Text('Choose an outfit', style: AppText.display(24)),
            const SizedBox(height: 4),
            Text(
              'Tap one for $day, then confirm below',
              style: AppText.body(12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: .8,
                children: [
                  for (final o in state.outfits)
                    PaperCard(
                      selected: o.id == _picked,
                      onTap: () => setState(() => _picked = o.id),
                      child: OutfitArt(items: state.itemsOf(o), height: 120),
                    ),
                ],
              ),
            ),
            Center(
              child: TextButton.icon(
                onPressed: widget.onCreateNew,
                icon: const Icon(Icons.add, color: AppColors.gold, size: 18),
                label: Text(
                  'Or create a new outfit',
                  style: AppText.body(
                    13,
                    weight: FontWeight.w500,
                    color: AppColors.gold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            PrimaryButton(
              label: 'Add to $day',
              onPressed: _picked == null
                  ? null
                  : () {
                      state.plan(widget.date, _picked!);
                      Navigator.pop(context);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
