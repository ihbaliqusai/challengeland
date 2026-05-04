import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class BottomGameNav extends StatelessWidget {
  const BottomGameNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 700;
    final items = const [
      _NavItem(AppStrings.store, Icons.storefront_rounded),
      _NavItem(AppStrings.friends, Icons.people_alt_rounded),
      _NavItem(AppStrings.home, Icons.home_rounded),
      _NavItem(AppStrings.missions, Icons.assignment_rounded),
      _NavItem(AppStrings.profile, Icons.menu_book_rounded),
    ];
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(context).bottom + (compact ? 6 : 8),
        top: compact ? 7 : 9,
        left: 8,
        right: 8,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF28B9FF),
            AppColors.challengeBlue,
            AppColors.challengeNavy,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.16),
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.34),
            blurRadius: 22,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = selectedIndex == index;
          return Expanded(
            child: Tooltip(
              message: item.label,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => onSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: selected ? (compact ? 66 : 76) : (compact ? 52 : 58),
                  margin: EdgeInsets.only(
                    top: selected
                        ? 0
                        : compact
                        ? 7
                        : 10,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(
                            colors: [
                              AppColors.challengeYellow,
                              AppColors.challengeGold,
                              AppColors.challengeOrange,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        : null,
                    color: selected ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(selected ? 20 : 16),
                    border: selected
                        ? Border.all(color: Colors.white, width: 2.5)
                        : Border.all(color: Colors.transparent),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppColors.challengeGold.withValues(
                                alpha: 0.34,
                              ),
                              blurRadius: 14,
                              offset: const Offset(0, 7),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: selected ? (compact ? 27 : 31) : 24,
                        color: selected
                            ? AppColors.challengeDark
                            : AppColors.challengeLight,
                      ),
                      SizedBox(height: compact ? 2 : 4),
                      FittedBox(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            color: selected
                                ? AppColors.challengeDark
                                : AppColors.challengeLight,
                            fontWeight: selected
                                ? FontWeight.w900
                                : FontWeight.w700,
                            fontSize: selected ? 12.5 : 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon);

  final String label;
  final IconData icon;
}
