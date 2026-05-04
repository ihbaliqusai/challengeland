import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/challenge_scaffold.dart';
import '../../state/auth_provider.dart';
import '../../state/game_provider.dart';

class DailyChallengeScreen extends StatelessWidget {
  const DailyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChallengeScaffold(
      title: 'التحدي اليومي',
      subtitle: 'نفس مجموعة الأسئلة لكل اللاعبين اليوم.',
      children: [
        const AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.calendar_month_rounded, size: 42),
              SizedBox(height: 12),
              Text(
                'جولة اليوم',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text('حاول تسجيل أفضل نتيجة وراجع ترتيبك في لوحة اليوم.'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppButton(
          label: 'ابدأ تحدي اليوم',
          icon: Icons.play_arrow_rounded,
          onPressed: () async {
            final user = context.read<AuthProvider>().user;
            if (user == null) return;
            await context.read<GameProvider>().startGame(
              player: user,
              mode: 'daily_challenge',
              questionCount: 10,
            );
            if (context.mounted) {
              Navigator.pushNamed(context, AppRoutes.question);
            }
          },
        ),
      ],
    );
  }
}
