import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../state/auth_provider.dart';
import '../../state/home_provider.dart';
import 'widgets/big_play_button.dart';
import 'widgets/bottom_game_nav.dart';
import 'widgets/game_hud.dart';
import 'widgets/game_page_shell.dart';
import 'widgets/home_action_drawer.dart';
import 'widgets/home_scene.dart';
import 'widgets/progress_unlock_banner.dart';
import 'widgets/side_boost_button.dart';

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
    final padding = MediaQuery.paddingOf(context);

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
            top: padding.top + (compact ? 70 : 82),
            child: ProgressUnlockBanner(progress: home.nextUnlockProgress),
          ),
          PositionedDirectional(
            end: -1,
            top: height * (compact ? 0.35 : 0.36),
            child: const SideBoostButton(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: padding.bottom + (compact ? 104 : 124),
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
                goToGameTab(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
