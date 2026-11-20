import 'dart:math';


import 'package:flutter/material.dart';


import '../../data/app_state.dart';
import '../../data/models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/clothing_art.dart';
import '../../widgets/frames.dart';
import '../../widgets/headers.dart';
import 'save_outfit_sheet.dart';


/// Buat outfit baru, atau edit outfit lama.
/// arguments (opsional): {'outfitId': String, 'date': DateTime}.
class AddOutfitScreen extends StatefulWidget {
  const AddOutfitScreen({super.key});


  @override
  State<AddOutfitScreen> createState() => _AddOutfitScreenState();
}


class _AddOutfitScreenState extends State<AddOutfitScreen> {
  final _state = AppState.instance;
  final _prompt = TextEditingController();
  final _rng = Random();
  final Map<ClothingCategory, String> _selected = {};
  ClothingCategory _tab = ClothingCategory.top;
  String? _aiMessage;
  Outfit? _editing;
  DateTime? _date;
  bool _loaded = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _date = args['date'] as DateTime?;
      final id = args['outfitId'] as String?;
      _editing = id == null ? null : _state.outfitOrNull(id);
      if (_editing != null) _selected.addAll(_editing!.items);
    }
  }


  @override
  void dispose() {
    _prompt.dispose();
    super.dispose();
  }


  List<ClothingItem> get _selectedItems => [
    for (final c in ClothingCategory.values)
      if (_selected[c] != null) _state.item(_selected[c]!),
  ];


  // shortcut: "AI" masih memilih acak item yang tidak cooldown; ganti dengan AI rekomendasi (S3-04).
  void _generate() {
    FocusScope.of(context).unfocus();
    setState(() {
      _selected.clear();
      for (final c in [
        ClothingCategory.top,
        ClothingCategory.bottom,
        ClothingCategory.shoes,
        if (_rng.nextBool()) ClothingCategory.hat,
      ]) {
        final options = _state.items
            .where((i) => i.category == c && !i.cooldown)
            .toList();
        if (options.isNotEmpty) {
          _selected[c] = options[_rng.nextInt(options.length)].id;
        }
      }
      final mood = _prompt.text.trim();
      _aiMessage = mood.isEmpty
          ? "Here's a breezy look for a sunny 29° day."
          : "Here's a look for '$mood'.";
    });
  }


  void _toggle(ClothingItem item) {
    setState(() {
      if (_selected[item.category] == item.id) {
        _selected.remove(item.category);
      } else {
        _selected[item.category] = item.id;
      }
    });
  }


  Future<void> _save() async {
    if (_selected.length < 2) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pick at least 2 items.')));
      return;
    }
    final result = await showSaveOutfitSheet(
      context,
      items: _selectedItems,
      initialDate: _date,
    );
    if (result == null || !mounted) return;


    final outfit =
        _editing ??
        Outfit(
          id: _state.newId(),
          name: 'Outfit ${_state.outfits.length + 1}',
          items: {},
        );
    outfit.items = Map.of(_selected);
    _state.saveOutfit(outfit);
    if (result.date != null &&
        !_state.outfitsOn(result.date!).contains(outfit)) {
      _state.plan(result.date!, outfit.id);
    }
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${outfit.name} saved.')));
  }


  @override
  Widget build(BuildContext context) {
    final items = _state.items.where((i) => i.category == _tab).toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BackHeader(title: _editing == null ? 'Add Outfit' : 'Edit Outfit'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                children: [
                  _PromptField(controller: _prompt, onSend: _generate),
                  if (_aiMessage != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 13,
                          backgroundColor: AppColors.goldTint,
                          child: Icon(
                            Icons.auto_awesome,
                            size: 13,
                            color: AppColors.gold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.bgElevated,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(_aiMessage!, style: AppText.body(12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 190,
                    child: PaperCard(
                      radius: 22,
                      child: Stack(
                        children: [
                          Center(
                            child: _selected.isEmpty
                                ? Text(
                                    'Pick items below or ask the AI',
                                    style: AppText.body(
                                      13,
                                      color: AppColors.textTertiary,
                                    ),
                                  )
                                : OutfitArt(items: _selectedItems, height: 175),
                          ),
                          if (_selected[ClothingCategory.outer] == null)
                            Positioned(
                              right: 16,
                              top: 40,
                              child: GestureDetector(
                                onTap: () => setState(
                                  () => _tab = ClothingCategory.outer,
                                ),
                                child: DashedBox(
                                  radius: 12,
                                  color: AppColors.textTertiary,
                                  child: SizedBox(
                                    width: 70,
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          color: AppColors.textTertiary,
                                        ),
                                        Text(
                                          'Outer',
                                          style: AppText.body(
                                            11,
                                            color: AppColors.textTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      OutlineGoldButton(
                        label: 'Regenerate',
                        icon: Icons.refresh,
                        height: 42,
                        expand: false,
                        onPressed: _generate,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'or edit manually below',
                        style: AppText.body(12, color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final c in ClothingCategory.values)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: PillChip(
                              label: c.label,
                              selected: c == _tab,
                              onTap: () => setState(() => _tab = c),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      for (final it in items)
                        PaperCard(
                          selected: _selected[it.category] == it.id,
                          dimmed: it.cooldown,
                          badge: it.cooldown ? const CooldownBadge() : null,
                          onTap: () => _toggle(it),
                          child: ClothingArt(
                            category: it.category,
                            color: it.color,
                            size: 72,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PrimaryButton(label: 'Save Outfit', onPressed: _save),
            ),
          ],
        ),
      ),
    );
  }
}


class _PromptField extends StatelessWidget {
  const _PromptField({required this.controller, required this.onSend});


  final TextEditingController controller;
  final VoidCallback onSend;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 4, 4, 4),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.goldDark),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.gold, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSend(),
              cursorColor: AppColors.gold,
              style: AppText.body(14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Describe a mood, colour or season...',
                hintStyle: AppText.body(14, color: AppColors.textTertiary),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Generate',
            onPressed: onSend,
            style: IconButton.styleFrom(backgroundColor: AppColors.gold),
            icon: const Icon(Icons.send, color: AppColors.bgBase, size: 18),
          ),
        ],
      ),
    );
  }
}
