import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class MascotAvatar extends StatefulWidget {
  const MascotAvatar({super.key, this.size = 224});

  final double size;

  @override
  State<MascotAvatar> createState() => _MascotAvatarState();
}

class _MascotAvatarState extends State<MascotAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final lift = -9 * _controller.value;
        final scale = 1 + (_controller.value * 0.028);
        return Transform.translate(
          offset: Offset(0, lift),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size * 1.28,
        child: FittedBox(
          child: SizedBox(
            width: 224,
            height: 286,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 18,
                  child: Container(
                    width: 154,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.32),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  child: Container(
                    width: 126,
                    height: 142,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.challengeCyan,
                          AppColors.challengeBlue,
                          AppColors.challengePurple,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(44),
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.challengeCyan.withValues(
                            alpha: 0.24,
                          ),
                          blurRadius: 22,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 84,
                  child: Container(
                    width: 112,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.challengeDark.withValues(alpha: 0.62),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'تحدي',
                        style: TextStyle(
                          color: AppColors.challengeYellow,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 34,
                  child: Container(
                    width: 152,
                    height: 128,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.challengeGold,
                          AppColors.challengeOrange,
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(48),
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.challengeGold.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(top: 72, right: 60, child: _eye()),
                Positioned(top: 72, left: 60, child: _eye()),
                Positioned(top: 62, right: 54, child: _brow(angle: -0.2)),
                Positioned(top: 62, left: 54, child: _brow(angle: 0.2)),
                Positioned(
                  top: 103,
                  child: Container(
                    width: 50,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.challengeDark,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.challengePurple,
                          AppColors.challengePink,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.help_rounded, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'QUIZ',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 90,
                  right: 12,
                  child: _glove(AppColors.challengePurple),
                ),
                Positioned(
                  bottom: 90,
                  left: 12,
                  child: _glove(AppColors.challengePink),
                ),
                Positioned(
                  bottom: 36,
                  right: 54,
                  child: _shoe(AppColors.challengeGold),
                ),
                Positioned(
                  bottom: 36,
                  left: 54,
                  child: _shoe(AppColors.challengeOrange),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _eye() {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.challengeDark,
      ),
    );
  }

  Widget _glove(Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.72)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: const Icon(Icons.flash_on_rounded, size: 26),
    );
  }

  Widget _brow({required double angle}) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 26,
        height: 8,
        decoration: BoxDecoration(
          color: AppColors.challengeDark,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  Widget _shoe(Color color) {
    return Container(
      width: 45,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}
