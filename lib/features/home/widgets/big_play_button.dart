import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class BigPlayButton extends StatefulWidget {
  const BigPlayButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<BigPlayButton> createState() => _BigPlayButtonState();
}

class _BigPlayButtonState extends State<BigPlayButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 700;
    return AnimatedScale(
      duration: const Duration(milliseconds: 100),
      scale: _pressed ? 0.96 : 1,
      child: Semantics(
        button: true,
        label: AppStrings.playNow,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          onTap: widget.onPressed,
          child: Container(
            width: compact ? 216 : 248,
            height: compact ? 68 : 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.challengeYellow, AppColors.challengeOrange],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.challengeOrange.withValues(alpha: 0.42),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 8,
                  left: 18,
                  right: 18,
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: -13,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.challengeBlue,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.challengeBlue.withValues(
                            alpha: 0.42,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 42),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        AppStrings.playNow,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              shadows: const [
                                Shadow(
                                  color: AppColors.challengeDark,
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                ),
                                Shadow(
                                  color: AppColors.challengeDark,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
