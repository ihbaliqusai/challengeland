import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/player_card.dart';
import '../../core/widgets/team_card.dart';
import '../../state/room_provider.dart';

class TeamSetupScreen extends StatelessWidget {
  const TeamSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final room = context.watch<RoomProvider>().room;
    if (room == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تحدي الفرق')),
        body: const EmptyState(message: 'أنشئ غرفة فرق أولًا من شاشة الأنماط.'),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pop(context),
          label: const Text('رجوع'),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('إعداد الفرق')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: room.teams
                    .map(
                      (team) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: TeamCard(team: team),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              ...room.players.map(
                (player) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: PlayerCard(player: player),
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'توزيع تلقائي',
                icon: Icons.auto_awesome_rounded,
                onPressed: () async {
                  final provider = context.read<RoomProvider>();
                  for (var i = 0; i < room.players.length; i++) {
                    await provider.assignTeam(
                      room.players[i].uid,
                      i.isEven ? 'a' : 'b',
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
