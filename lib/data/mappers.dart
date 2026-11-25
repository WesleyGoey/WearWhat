import 'package:flutter/material.dart';


import 'models.dart';


/// Mengubah model Dart ke baris tabel Supabase dan sebaliknya.
/// Nama kolom sama dengan supabase/schema.sql.


/// DateTime -> "2026-11-24" (kolom bertipe date).
String toDateString(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';


/// "2026-11-24" -> DateTime(2026, 11, 24).
DateTime parseDate(String s) => dateOnly(DateTime.parse(s));


T _enumByName<T extends Enum>(List<T> values, String name, T fallback) =>
    values.where((v) => v.name == name).firstOrNull ?? fallback;


Map<String, dynamic> itemToRow(ClothingItem i) => {
  'id': i.id,
  'category': i.category.name,
  'color': i.color.toARGB32(),
  'seasons': [for (final s in i.seasons) s.name],
  'worn': i.worn,
  'last_worn': i.lastWorn?.toUtc().toIso8601String(),
  'cooldown': i.cooldown,
  'photo_path': i.photoPath,
};


ClothingItem itemFromRow(Map<String, dynamic> r) => ClothingItem(
  id: r['id'] as String,
  category: _enumByName(
    ClothingCategory.values,
    r['category'] as String,
    ClothingCategory.top,
  ),
  color: Color((r['color'] as num).toInt()),
  seasons: {
    for (final s in (r['seasons'] as List? ?? const []))
      _enumByName(Season.values, s as String, Season.summer),
  },
  worn: (r['worn'] as num?)?.toInt() ?? 0,
  lastWorn: r['last_worn'] == null
      ? null
      : DateTime.parse(r['last_worn'] as String).toLocal(),
  cooldown: r['cooldown'] as bool? ?? false,
  photoPath: r['photo_path'] as String?,
);


Map<String, dynamic> outfitToRow(Outfit o) => {
  'id': o.id,
  'name': o.name,
  'items': {for (final e in o.items.entries) e.key.name: e.value},
  'last_worn_on': o.lastWornOn == null ? null : toDateString(o.lastWornOn!),
};


Outfit outfitFromRow(Map<String, dynamic> r) => Outfit(
  id: r['id'] as String,
  name: r['name'] as String,
  items: {
    for (final e in (r['items'] as Map? ?? const {}).entries)
      _enumByName(
        ClothingCategory.values,
        e.key as String,
        ClothingCategory.top,
      ): e.value as String,
  },
  lastWornOn: r['last_worn_on'] == null
      ? null
      : parseDate(r['last_worn_on'] as String),
);


Map<String, dynamic> profileToRow(String userId, UserProfile u) => {
  'id': userId,
  'name': u.name,
  'age': u.age,
  'gender': u.gender.name,
  'skin_tone': u.skinTone,
  'updated_at': DateTime.now().toUtc().toIso8601String(),
};


UserProfile profileFromRow(Map<String, dynamic> r) => UserProfile(
  name: r['name'] as String? ?? '',
  age: (r['age'] as num?)?.toInt() ?? 0,
  gender: _enumByName(Gender.values, r['gender'] as String, Gender.male),
  skinTone: (r['skin_tone'] as num?)?.toInt() ?? 2,
);
