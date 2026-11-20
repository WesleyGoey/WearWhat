import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wearwhat/main.dart';


void main() {
  // Test tidak boleh download font dari internet.
  GoogleFonts.config.allowRuntimeFetching = false;


  testWidgets('Welcome screen tampil dengan tombol Sign Up dan Log In', (
    tester,
  ) async {
    await tester.pumpWidget(const WearWhatApp());
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });


  testWidgets('Log In lewat Google membuka Home', (tester) async {
    await tester.pumpWidget(const WearWhatApp());
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    expect(find.text("Today's Outfit"), findsOneWidget);
  });
}
