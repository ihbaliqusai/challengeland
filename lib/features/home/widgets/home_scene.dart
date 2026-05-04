import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'mascot_avatar.dart';

class HomeScene extends StatelessWidget {
  const HomeScene({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        final compact = height < 700;
        final wallTop = compact ? 166.0 : 192.0;
        final mascotTop = (height * (compact ? 0.36 : 0.38)).clamp(
          compact ? 238.0 : 282.0,
          compact ? 310.0 : 350.0,
        );
        final lowerObjectsBottom = compact ? 108.0 : 134.0;

        return Stack(
          fit: StackFit.expand,
          children: [
            const _ArenaBackground(),
            Positioned(
              top: wallTop,
              right: 18,
              child: _poster(
                icon: Icons.quiz_rounded,
                title: 'لوحة الأسئلة',
                color: AppColors.challengeCyan,
                compact: compact,
              ),
            ),
            Positioned(
              top: wallTop + (compact ? 28 : 38),
              left: 18,
              child: _poster(
                icon: Icons.emoji_events_rounded,
                title: 'أبطال اليوم',
                color: AppColors.challengeGold,
                compact: compact,
              ),
            ),
            Positioned(
              top: wallTop + (compact ? 128 : 150),
              right: 0,
              child: _shelf(compact: compact),
            ),
            Positioned(
              top: wallTop + (compact ? 120 : 148),
              left: 0,
              child: _speakerTower(compact: compact),
            ),
            Positioned(
              bottom: lowerObjectsBottom,
              left: 16,
              child: _quizConsole(compact: compact),
            ),
            Positioned(
              bottom: lowerObjectsBottom - 4,
              right: 16,
              child: _stackedTokens(compact: compact),
            ),
            Positioned(
              top: mascotTop,
              left: 0,
              right: 0,
              child: Center(child: MascotAvatar(size: compact ? 188 : 224)),
            ),
            Positioned(
              top: wallTop - 20,
              left: width * 0.12,
              child: _lightBeam(AppColors.challengePink, compact: compact),
            ),
            Positioned(
              top: wallTop - 34,
              right: width * 0.14,
              child: _lightBeam(AppColors.challengeCyan, compact: compact),
            ),
            Positioned(
              bottom: compact ? 214 : 250,
              right: 22,
              child: _sideArrow(),
            ),
          ],
        );
      },
    );
  }

  Widget _poster({
    required IconData icon,
    required String title,
    required Color color,
    required bool compact,
  }) {
    return Container(
      width: compact ? 102 : 120,
      padding: EdgeInsets.all(compact ? 10 : 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.challengeCard.withValues(alpha: 0.88),
            AppColors.challengeNavy.withValues(alpha: 0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.56), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 12,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: compact ? 25 : 30),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: compact ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _shelf({required bool compact}) {
    return SizedBox(
      width: compact ? 118 : 140,
      height: compact ? 66 : 78,
      child: Stack(
        children: [
          Positioned(
            bottom: 6,
            child: Container(
              width: compact ? 118 : 140,
              height: 12,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.challengeOrange, AppColors.challengeGold],
                ),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            child: _shelfIcon(
              Icons.emoji_events_rounded,
              AppColors.challengeGold,
              compact,
            ),
          ),
          Positioned(
            right: compact ? 52 : 60,
            top: 10,
            child: _shelfIcon(
              Icons.military_tech_rounded,
              AppColors.challengeCyan,
              compact,
            ),
          ),
          Positioned(
            left: 12,
            top: 4,
            child: _shelfIcon(
              Icons.star_rounded,
              AppColors.challengeYellow,
              compact,
            ),
          ),
        ],
      ),
    );
  }

  Widget _shelfIcon(IconData icon, Color color, bool compact) {
    return Icon(icon, color: color, size: compact ? 28 : 34);
  }

  Widget _speakerTower({required bool compact}) {
    return Container(
      width: compact ? 48 : 56,
      height: compact ? 118 : 142,
      decoration: BoxDecoration(
        color: AppColors.challengeNavy.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          3,
          (_) => Container(
            width: compact ? 24 : 30,
            height: compact ? 24 : 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.challengeDark,
              border: Border.all(color: AppColors.challengeCyan, width: 2),
            ),
            child: Center(
              child: Container(
                width: compact ? 8 : 10,
                height: compact ? 8 : 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.challengeCyan,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _quizConsole({required bool compact}) {
    return Container(
      width: compact ? 88 : 108,
      height: compact ? 76 : 92,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.challengeNavy, AppColors.challengeCard],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.challengeBlue, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.challengeBlue.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_esports_rounded,
            color: AppColors.challengeCyan,
            size: compact ? 28 : 34,
          ),
          const SizedBox(height: 6),
          Text(
            'جاهز؟',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: compact ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stackedTokens({required bool compact}) {
    return SizedBox(
      width: compact ? 94 : 112,
      height: compact ? 70 : 84,
      child: Stack(
        children: List.generate(4, (index) {
          return Positioned(
            bottom: index * (compact ? 8 : 10),
            right: index * (compact ? 11 : 13),
            child: Container(
              width: compact ? 48 : 56,
              height: compact ? 48 : 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: index.isEven
                      ? const [
                          AppColors.challengeYellow,
                          AppColors.challengeGold,
                        ]
                      : const [
                          AppColors.challengeGold,
                          AppColors.challengeOrange,
                        ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: AppColors.challengeDark,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _lightBeam(Color color, {required bool compact}) {
    return Container(
      width: compact ? 38 : 46,
      height: compact ? 104 : 130,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.36), color.withValues(alpha: 0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _sideArrow() {
    return Container(
      width: 42,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.challengeNavy.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: const Icon(Icons.chevron_left_rounded, size: 34),
    );
  }
}

class _ArenaBackground extends StatelessWidget {
  const _ArenaBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ArenaPainter());
  }
}

class _ArenaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final background = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = const LinearGradient(
      colors: [Color(0xFF0B1024), AppColors.challengeDark, Color(0xFF29115F)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(background);
    canvas.drawRect(background, paint);

    paint.shader = null;
    paint.color = AppColors.challengeCard.withValues(alpha: 0.72);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          18,
          size.height * 0.20,
          size.width - 36,
          size.height * 0.45,
        ),
        const Radius.circular(30),
      ),
      paint,
    );

    paint.color = AppColors.challengeBlue.withValues(alpha: 0.18);
    paint.strokeWidth = 2;
    for (var i = 0; i < 5; i++) {
      final y = size.height * 0.29 + (i * 52);
      canvas.drawLine(Offset(28, y), Offset(size.width - 28, y), paint);
    }

    paint.color = AppColors.challengePurple.withValues(alpha: 0.2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.17,
          size.height * 0.22,
          size.width * 0.66,
          20,
        ),
        const Radius.circular(999),
      ),
      paint,
    );

    paint.color = AppColors.challengeCard;
    final floor = Path()
      ..moveTo(0, size.height * 0.65)
      ..lineTo(size.width, size.height * 0.61)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(floor, paint);

    paint.color = Colors.black.withValues(alpha: 0.25);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.72),
        width: size.width * 0.82,
        height: 82,
      ),
      paint,
    );

    paint.color = AppColors.challengeCyan.withValues(alpha: 0.2);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.18), 80, paint);
    paint.color = AppColors.challengePink.withValues(alpha: 0.15);
    canvas.drawCircle(
      Offset(size.width * 0.83, size.height * 0.25),
      110,
      paint,
    );

    paint.color = AppColors.challengeGold.withValues(alpha: 0.08);
    for (var i = 0; i < 7; i++) {
      canvas.drawCircle(
        Offset(
          24 + (i * size.width / 6),
          size.height * 0.67 + (i.isEven ? 8 : 0),
        ),
        3,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
