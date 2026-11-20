import 'package:flutter/material.dart';


enum ClothingCategory {
  top('Top'),
  bottom('Bottom'),
  outer('Outer'),
  shoes('Shoes'),
  hat('Hat');


  const ClothingCategory(this.label);
  final String label;
}


enum Season {
  spring('Spring', Icons.local_florist_outlined),
  summer('Summer', Icons.wb_sunny_outlined),
  autumn('Autumn', Icons.eco_outlined),
  winter('Winter', Icons.ac_unit),
  rainy('Rainy', Icons.umbrella_outlined);


  const Season(this.label, this.icon);
  final String label;
  final IconData icon;
}


enum Gender {
  male('Male'),
  female('Female'),
  preferNot('Prefer not to say');


  const Gender(this.label);
  final String label;
}


class SkinTone {
  const SkinTone(this.name, this.color);
  final String name;
  final Color color;
}


const skinTones = [
  SkinTone('Fair', Color(0xFFF6DCC8)),
  SkinTone('Light', Color(0xFFEBC09A)),
  SkinTone('Medium', Color(0xFFC98B5E)),
  SkinTone('Tan', Color(0xFFA86B43)),
  SkinTone('Brown', Color(0xFF7E4A2B)),
  SkinTone('Deep', Color(0xFF4A2C1C)),
];


class ClothingItem {
  ClothingItem({
    required this.id,
    required this.category,
    required this.color,
    Set<Season>? seasons,
    this.worn = 0,
    this.lastWorn,
    this.cooldown = false,
  }) : seasons = seasons ?? {};


  final String id;
  ClothingCategory category;
  Color color;
  Set<Season> seasons;
  int worn;
  DateTime? lastWorn;
  bool cooldown;
}


class Outfit {
  Outfit({required this.id, required this.name, required this.items});


  final String id;
  String name;


  /// Kategori -> id ClothingItem.
  Map<ClothingCategory, String> items;
}


class UserProfile {
  UserProfile({
    this.name = '',
    this.age = 0,
    this.gender = Gender.male,
    this.skinTone = 2,
  });


  String name;
  int age;
  Gender gender;


  /// Index ke [skinTones].
  int skinTone;
}


// Helper tanggal sederhana (tanpa package intl).
const weekdayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const weekdayLong = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
const monthShort = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
const monthLong = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];


DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);


/// Contoh: "Fri, 23 Oct".
String fmtDay(DateTime d) =>
    '${weekdayShort[d.weekday - 1]}, ${d.day} ${monthShort[d.month - 1]}';


/// Contoh: "Friday, 23 October".
String fmtDayLong(DateTime d) =>
    '${weekdayLong[d.weekday - 1]}, ${d.day} ${monthLong[d.month - 1]}';
