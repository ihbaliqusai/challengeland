import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/match_history_tile.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/user_avatar.dart';
import '../../state/auth_provider.dart';
import '../../state/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) context.read<ProfileProvider>().load(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final profile = context.watch<ProfileProvider>().profile ?? user;
    final history = context.watch<ProfileProvider>().history;
    if (profile == null) return const EmptyState(message: 'سجل الدخول أولًا');
    final winRate = (profile.winRate * 100).round();
    final correctRate = (profile.correctRate * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        actions: [
          IconButton(
            tooltip: 'الإعدادات',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: UserAvatar(
                  name: profile.username,
                  size: 92,
                  level: profile.level,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                profile.username,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (profile.xp / (profile.level * 250)).clamp(0, 1),
                minHeight: 10,
                color: AppColors.challengeGold,
              ),
              const SizedBox(height: 18),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.35,
                children: [
                  StatCard(
                    label: 'العملات',
                    value: '${profile.coins}',
                    icon: Icons.monetization_on_rounded,
                    color: AppColors.challengeGold,
                  ),
                  StatCard(
                    label: 'الكؤوس',
                    value: '${profile.trophies}',
                    icon: Icons.emoji_events_rounded,
                    color: AppColors.challengeOrange,
                  ),
                  StatCard(
                    label: 'التقييم',
                    value: '${profile.rating}',
                    icon: Icons.trending_up_rounded,
                    color: AppColors.challengeCyan,
                  ),
                  StatCard(
                    label: 'نسبة الفوز',
                    value: '$winRate%',
                    icon: Icons.ssid_chart_rounded,
                    color: AppColors.challengeGreen,
                  ),
                  StatCard(
                    label: 'إجابات صحيحة',
                    value: '$correctRate%',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.challengeGreen,
                  ),
                  StatCard(
                    label: 'المباريات',
                    value: '${profile.totalGames}',
                    icon: Icons.sports_esports_rounded,
                    color: AppColors.challengePurple,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              AppButton(
                label: 'تعديل اسم اللاعب',
                icon: Icons.edit_rounded,
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.username),
              ),
              const SizedBox(height: 22),
              Text(
                'آخر المباريات',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              if (history.isEmpty)
                const EmptyState(message: 'لا توجد مباريات سابقة')
              else
                ...history.map(
                  (match) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: MatchHistoryTile(match: match),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
