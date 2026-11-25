import '../data/app_state.dart';
import 'routes.dart';


/// Dipanggil setelah login atau saat app dibuka dengan sesi tersimpan.
/// Ambil data user dari Supabase, lalu pilih layar pertama:
/// akun yang belum mengisi Basic Info masuk ke setup, sisanya ke Home.
Future<String> startSession() async {
  final state = AppState.instance;
  await state.load();
  state.setTab(0);
  return state.hasProfile ? Routes.main : Routes.basicInfo;
}
