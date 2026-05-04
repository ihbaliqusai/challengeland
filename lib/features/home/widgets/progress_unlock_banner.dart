import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ProgressUnlockBanner extends StatelessWidget {
  const ProgressUnlockBanner({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 700;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: compact ? 14 : 18),
      padding: EdgeInsets.all(compact ? 12 : 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.challengePink,
            AppColors.challengePurple,
            AppColors.challengeBlue,
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: AppColors.challengePink.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            end: -8,
            top: -18,
            child: Icon(
              Icons.star_rounded,
              color: AppColors.challengeYellow.withValues(alpha: 0.22),
              size: 82,
            ),
          ),
          Row(
            children: [
              Container(
                width: compact ? 50 : 58,
                height: compact ? 50 : 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.challengeYellow,
                      AppColors.challengeOrange,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.challengeGold.withValues(alpha: 0.38),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.challengeDark,
                  size: 34,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppStrings.nextReward,
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                        Text(
                          AppStrings.unlockProgress,
                          style: TextStyle(
                            color: AppColors.challengeYellow,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: compact ? 7 : 9),
                    Container(
                      height: compact ? 15 : 17,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.28),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.14),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0,
                            end: progress.clamp(0, 1),
                          ),
                          duration: const Duration(milliseconds: 850),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) {
                            return LinearProgressIndicator(
                              value: value,
                              backgroundColor: Colors.transparent,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.challengeGold,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 5 : 7),
                    const Text(
                      AppStrings.winTwoMore,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: compact ? 42 : 48,
                height: compact ? 42 : 48,
                decoration: BoxDecoration(
                  color: AppColors.challengeNavy.withValues(alpha: 0.52),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
                child: const Icon(
                  Icons.lock_open_rounded,
                  color: AppColors.challengeGold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
