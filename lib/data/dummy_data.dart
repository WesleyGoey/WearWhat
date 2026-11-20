import 'package:flutter/material.dart';


import 'models.dart';


// Data contoh supaya UI bisa dicoba sebelum backend siap.


List<ClothingItem> dummyItems() => [
  ClothingItem(
    id: 't1',
    category: ClothingCategory.top,
    color: const Color(0xFFF7F5F0),
    seasons: {Season.summer, Season.rainy},
    worn: 12,
  ),
  ClothingItem(
    id: 't2',
    category: ClothingCategory.top,
    color: const Color(0xFF243656),
    seasons: {Season.autumn},
    worn: 0,
  ),
  ClothingItem(
    id: 't3',
    category: ClothingCategory.top,
    color: const Color(0xFF6B7445),
    seasons: {Season.summer},
    worn: 9,
  ),
  ClothingItem(
    id: 't4',
    category: ClothingCategory.top,
    color: const Color(0xFFE8DFD0),
    seasons: {Season.winter},
    worn: 3,
  ),
  ClothingItem(
    id: 't5',
    category: ClothingCategory.top,
    color: const Color(0xFF5A4126),
    worn: 5,
    cooldown: true,
  ),
  ClothingItem(
    id: 't6',
    category: ClothingCategory.top,
    color: const Color(0xFF1E1E1E),
    worn: 7,
  ),
  ClothingItem(
    id: 'b1',
    category: ClothingCategory.bottom,
    color: const Color(0xFF26262A),
    seasons: {Season.spring, Season.autumn},
    worn: 8,
    cooldown: true,
  ),
  ClothingItem(
    id: 'b2',
    category: ClothingCategory.bottom,
    color: const Color(0xFFB8925A),
    seasons: {Season.summer},
    worn: 4,
  ),
  ClothingItem(
    id: 'b3',
    category: ClothingCategory.bottom,
    color: const Color(0xFF4A6A96),
    worn: 6,
  ),
  ClothingItem(
    id: 'b4',
    category: ClothingCategory.bottom,
    color: const Color(0xFF45454A),
    worn: 2,
  ),
  ClothingItem(
    id: 's1',
    category: ClothingCategory.shoes,
    color: const Color(0xFF1E1E1E),
    worn: 15,
  ),
  ClothingItem(
    id: 's2',
    category: ClothingCategory.shoes,
    color: const Color(0xFFF7F5F0),
    worn: 4,
  ),
  ClothingItem(
    id: 's3',
    category: ClothingCategory.shoes,
    color: const Color(0xFF6B4226),
    worn: 3,
  ),
  ClothingItem(
    id: 'h1',
    category: ClothingCategory.hat,
    color: const Color(0xFFCDB592),
    worn: 2,
    cooldown: true,
  ),
  ClothingItem(
    id: 'h2',
    category: ClothingCategory.hat,
    color: const Color(0xFF1E1E1E),
    worn: 1,
  ),
  ClothingItem(
    id: 'o1',
    category: ClothingCategory.outer,
    color: const Color(0xFFB8925A),
    seasons: {Season.autumn, Season.winter},
    worn: 3,
  ),
];


List<Outfit> dummyOutfits() => [
  Outfit(
    id: 'f1',
    name: 'Outfit 1',
    items: {
      ClothingCategory.hat: 'h1',
      ClothingCategory.top: 't1',
      ClothingCategory.bottom: 'b1',
      ClothingCategory.shoes: 's1',
    },
  ),
  Outfit(
    id: 'f2',
    name: 'Outfit 2',
    items: {
      ClothingCategory.hat: 'h1',
      ClothingCategory.top: 't2',
      ClothingCategory.bottom: 'b2',
      ClothingCategory.shoes: 's2',
    },
  ),
  Outfit(
    id: 'f3',
    name: 'Outfit 3',
    items: {
      ClothingCategory.top: 't3',
      ClothingCategory.bottom: 'b3',
      ClothingCategory.shoes: 's3',
    },
  ),
  Outfit(
    id: 'f4',
    name: 'Outfit 4',
    items: {
      ClothingCategory.hat: 'h2',
      ClothingCategory.top: 't4',
      ClothingCategory.bottom: 'b4',
      ClothingCategory.shoes: 's1',
    },
  ),
  Outfit(
    id: 'f5',
    name: 'Outfit 5',
    items: {
      ClothingCategory.top: 't5',
      ClothingCategory.bottom: 'b2',
      ClothingCategory.shoes: 's3',
    },
  ),
  Outfit(
    id: 'f6',
    name: 'Outfit 6',
    items: {
      ClothingCategory.top: 't1',
      ClothingCategory.outer: 'o1',
      ClothingCategory.bottom: 'b1',
      ClothingCategory.shoes: 's2',
    },
  ),
];


/// Jadwal outfit relatif ke hari ini supaya kalender selalu terisi.
Map<DateTime, List<String>> dummyPlans() {
  final today = dateOnly(DateTime.now());
  DateTime day(int offset) => today.add(Duration(days: offset));
  return {
    day(0): ['f1', 'f2'],
    day(-1): ['f3'],
    day(-2): ['f4'],
    day(-3): ['f2', 'f5'],
    day(2): ['f4'],
  };
}


UserProfile dummyUser() =>
    UserProfile(name: 'Alex', age: 21, gender: Gender.male, skinTone: 2);
