import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/leaderboard_tile.dart';
import '../../core/widgets/loading_view.dart';
import '../../state/leaderboard_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaderboardProvider>();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.leaderboard),
          bottom: TabBar(
            onTap: (index) {
              final period = switch (index) {
                1 => 'week',
                2 => 'all',
                _ => 'today',
              };
              context.read<LeaderboardProvider>().load(period: period);
            },
            tabs: const [
              Tab(text: 'اليوم'),
              Tab(text: 'الأسبوع'),
              Tab(text: 'الكل'),
            ],
          ),
        ),
        body: SafeArea(
          child: provider.isLoading
              ? const LoadingView()
              : provider.error != null
              ? ErrorView(message: provider.error!)
              : provider.entries.isEmpty
              ? const EmptyState(message: AppStrings.noLeaderboard)
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      LeaderboardTile(entry: provider.entries[index]),
                ),
        ),
      ),
    );
  }
}
