import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class SideBoostButton extends StatefulWidget {
  const SideBoostButton({super.key});

  @override
  State<SideBoostButton> createState() => _SideBoostButtonState();
}

class _SideBoostButtonState extends State<SideBoostButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 700;
    final size = compact ? 58.0 : 66.0;
    return Semantics(
      button: true,
      label: 'تعزيز الطاقة',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -4 * _controller.value),
            child: child,
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            PositionedDirectional(
              start: -14,
              bottom: 2,
              child: _coinStack(compact),
            ),
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    AppColors.challengeYellow,
                    AppColors.challengeGold,
                    AppColors.challengeOrange,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.challengeGold.withValues(alpha: 0.45),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.28),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: AppColors.challengeDark,
                size: 36,
              ),
            ),
            Positioned(
              top: 8,
              left: 13,
              right: 13,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coinStack(bool compact) {
    final coinSize = compact ? 24.0 : 28.0;
    return SizedBox(
      width: compact ? 48 : 54,
      height: compact ? 44 : 50,
      child: Stack(
        children: List.generate(3, (index) {
          return Positioned(
            right: index * 10,
            bottom: index * 7,
            child: Container(
              width: coinSize,
              height: coinSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.challengeYellow, AppColors.challengeGold],
                ),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(
                Icons.monetization_on_rounded,
                color: AppColors.challengeDark,
                size: 15,
              ),
            ),
          );
        }),
      ),
    );
  }
}
