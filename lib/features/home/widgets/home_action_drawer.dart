import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';

class HomeActionDrawer extends StatelessWidget {
  const HomeActionDrawer({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => const HomeActionDrawer(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              label: AppStrings.leaderboard,
              icon: Icons.leaderboard_rounded,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.leaderboard);
              },
            ),
            const SizedBox(height: 12),
            AppButton(
              label: AppStrings.settings,
              icon: Icons.settings_rounded,
              variant: AppButtonVariant.ghost,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
          ],
        ),
      ),
    );
  }
}
