import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../state/auth_provider.dart';
import '../../state/home_provider.dart';
import 'widgets/big_play_button.dart';
import 'widgets/bottom_game_nav.dart';
import 'widgets/game_hud.dart';
import 'widgets/home_action_drawer.dart';
import 'widgets/home_scene.dart';
import 'widgets/progress_unlock_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final user = context.read<AuthProvider>().user;
    final homeProvider = context.read<HomeProvider>();
    Future.microtask(() => homeProvider.load(user));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final home = context.watch<HomeProvider>();
    final height = MediaQuery.sizeOf(context).height;
    final compact = height < 700;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeScene()),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: GameHud(
              username: user?.username ?? 'لاعب',
              trophies: home.trophies,
              energy: home.energy,
              coins: home.coins,
              onMenu: () => HomeActionDrawer.show(context),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.paddingOf(context).top + (compact ? 88 : 104),
            child: ProgressUnlockBanner(progress: home.nextUnlockProgress),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: safeBottom + (compact ? 98 : 120),
            child: Center(
              child: BigPlayButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.gameModes),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomGameNav(
              selectedIndex: home.selectedBottomTab,
              onSelected: (index) {
                if (index == 2) {
                  home.selectBottomTab(index);
                  return;
                }
                final routes = {
                  1: AppRoutes.friends,
                  3: AppRoutes.dailyChallenge,
                  4: AppRoutes.profile,
                };
                final route = routes[index];
                if (route != null) Navigator.pushNamed(context, route);
              },
            ),
          ),
        ],
      ),
    );
  }
}
