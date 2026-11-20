import 'package:flutter/material.dart';


import '../data/app_state.dart';
import '../widgets/bottom_nav.dart';
import 'calendar/calendar_screen.dart';
import 'home/add_sheet.dart';
import 'home/home_screen.dart';
import 'home/home_tutorial.dart';
import 'profile/profile_screen.dart';
import 'wardrobe/wardrobe_screen.dart';


/// Kerangka utama setelah login: 4 tab + tombol + di tengah.
class MainShell extends StatelessWidget {
  const MainShell({super.key});


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        return Stack(
          children: [
            Scaffold(
              extendBody: true,
              body: IndexedStack(
                index: state.tab,
                children: const [
                  HomeScreen(),
                  WardrobeScreen(),
                  CalendarScreen(),
                  ProfileScreen(),
                ],
              ),
              bottomNavigationBar: AppBottomNav(
                index: state.tab,
                onTap: state.setTab,
                onAdd: () => showAddSheet(context),
              ),
            ),
            if (state.showTutorial && state.tab == 0)
              Positioned.fill(
                child: HomeTutorial(
                  onDone: state.dismissTutorial,
                  onAdd: () => showAddSheet(context),
                ),
              ),
          ],
        );
      },
    );
  }
}
