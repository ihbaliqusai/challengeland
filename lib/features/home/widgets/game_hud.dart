import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/user_avatar.dart';
import 'resource_chip.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.username,
    required this.trophies,
    required this.energy,
    required this.coins,
    required this.onMenu,
  });

  final String username;
  final int trophies;
  final int energy;
  final int coins;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 380;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.challengePurple,
            AppColors.challengeBlue,
            AppColors.challengeCyan,
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: AppColors.challengeBlue.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsetsDirectional.only(
          top: MediaQuery.paddingOf(context).top + 7,
          start: compact ? 8 : 12,
          end: compact ? 8 : 12,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.challengeGold, AppColors.challengeOrange],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.challengeGold.withValues(alpha: 0.28),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: UserAvatar(
                name: username,
                size: compact ? 44 : 56,
                level: 4,
              ),
            ),
            SizedBox(width: compact ? 6 : 9),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ResourceChip(
                      compact: compact,
                      label: AppStrings.trophies,
                      value: '$trophies',
                      icon: Icons.emoji_events_rounded,
                      color: AppColors.challengeGold,
                    ),
                  ),
                  SizedBox(width: compact ? 5 : 7),
                  Expanded(
                    child: ResourceChip(
                      compact: compact,
                      label: AppStrings.energy,
                      value: '$energy',
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.challengeOrange,
                    ),
                  ),
                  SizedBox(width: compact ? 5 : 7),
                  Expanded(
                    child: ResourceChip(
                      compact: compact,
                      label: AppStrings.coins,
                      value: '$coins',
                      icon: Icons.monetization_on_rounded,
                      color: AppColors.challengeYellow,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: compact ? 5 : 8),
            Tooltip(
              message: AppStrings.menu,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onMenu,
                  child: Ink(
                    width: compact ? 38 : 48,
                    height: compact ? 38 : 48,
                    decoration: BoxDecoration(
                      color: AppColors.challengeNavy.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                    ),
                    child: const Icon(Icons.menu_rounded, size: 28),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
