# WearWhat


Wardrobe dan outfit planner berbasis Flutter. Kelompok Walisongo, mata kuliah DEPD.


## Status MVP


| Fitur | Status |
|---|---|
| Sign up, log in, log out (email dan password) | Tersimpan di Supabase Auth |
| Profil: nama, umur, gender, skin tone | Tabel `profiles` |
| Wardrobe: tambah baju dengan foto dari kamera atau galeri | Tabel `clothing_items` dan bucket `clothes` |
| Outfit, kalender, Mark as Worn dengan Undo | Tabel `outfits` dan `plans` |
| Deteksi baju oleh AI, saran outfit AI, cuaca | Belum ada, masih data contoh |
| Login dengan Google | Belum aktif |


## Cara menjalankan


1. Install Flutter 3.47 atau lebih baru, lalu jalankan `flutter pub get`.
2. Minta file `env.json` ke Wesley, atau buat sendiri dari `env.example.json`:
   - `SUPABASE_URL`: Supabase Dashboard > Project Settings > API > Project URL.
   - `SUPABASE_PUBLISHABLE_KEY`: di halaman yang sama, bagian API Keys, salin publishable key (atau anon key untuk project lama).
3. Simpan `env.json` di folder utama project (sejajar dengan `pubspec.yaml`). File ini tidak ikut ke GitHub.
4. Jalankan:


   ```bash
   flutter run --dart-define-from-file=env.json
   ```


Tanpa `env.json`, aplikasi tetap terbuka, tetapi login akan menampilkan pesan "Supabase is not set up".


## Setup Supabase (sekali saja)


1. Buka Supabase Dashboard > SQL Editor > New query.
2. Tempel isi `supabase/schema.sql`, lalu klik Run.
3. Untuk testing tanpa email konfirmasi: Authentication > Sign In / Providers > Email, matikan "Confirm email".


## Test


```bash
flutter analyze
flutter test
```
