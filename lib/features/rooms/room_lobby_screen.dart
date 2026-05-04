import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/player_card.dart';
import '../../core/widgets/room_code_card.dart';
import '../../state/auth_provider.dart';
import '../../state/game_provider.dart';
import '../../state/room_provider.dart';

class RoomLobbyScreen extends StatelessWidget {
  const RoomLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final room = context.watch<RoomProvider>().room;
    final user = context.watch<AuthProvider>().user;
    if (room == null) {
      return const Scaffold(body: EmptyState(message: 'لا توجد غرف متاحة'));
    }
    final isHost = user?.uid == room.hostId;
    return Scaffold(
      appBar: AppBar(title: Text(room.name)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RoomCodeCard(code: room.code),
              const SizedBox(height: 16),
              Text(
                'اللاعبون ${room.players.length} / ${room.maxPlayers}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              ...room.players.map(
                (player) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: PlayerCard(
                    player: player,
                    onRemove: isHost && !player.isHost
                        ? () => context.read<RoomProvider>().removePlayer(
                            player.uid,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (room.mode == 'team_battle')
                AppButton(
                  label: 'إعداد الفرق',
                  icon: Icons.groups_rounded,
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.teamSetup),
                ),
              if (isHost) ...[
                const SizedBox(height: 12),
                AppButton(
                  label: 'بدء المباراة',
                  icon: Icons.play_arrow_rounded,
                  onPressed: () async {
                    final currentUser = context.read<AuthProvider>().user;
                    if (currentUser == null) return;
                    await context.read<RoomProvider>().startGame();
                    if (context.mounted) {
                      await context.read<GameProvider>().startGame(
                        player: currentUser,
                        mode: room.mode,
                        questionCount: room.questionCount,
                      );
                      if (context.mounted) {
                        Navigator.pushNamed(context, AppRoutes.question);
                      }
                    }
                  },
                ),
              ],
              const SizedBox(height: 12),
              AppButton(
                label: 'مغادرة الغرفة',
                icon: Icons.logout_rounded,
                variant: AppButtonVariant.ghost,
                onPressed: () async {
                  final currentUser = context.read<AuthProvider>().user;
                  if (currentUser != null) {
                    await context.read<RoomProvider>().leave(currentUser);
                  }
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
