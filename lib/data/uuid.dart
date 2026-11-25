import 'dart:math';


final _rng = Random.secure();


/// UUID versi 4 acak, misalnya "3f2b8c1e-9a4d-4f6b-8e2a-1c5d7e9f0a3b".
/// Dibuat di HP supaya data bisa langsung tampil sebelum tersimpan di Supabase.
String newUuid() {
  final b = List<int>.generate(16, (_) => _rng.nextInt(256));
  b[6] = (b[6] & 0x0f) | 0x40; // versi 4
  b[8] = (b[8] & 0x3f) | 0x80; // varian RFC 4122
  final h = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}'
      '-${h.substring(16, 20)}-${h.substring(20)}';
}
