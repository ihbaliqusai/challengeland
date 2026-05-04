import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/challenge_scaffold.dart';
import '../../state/auth_provider.dart';
import '../../state/room_provider.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _nameController = TextEditingController(text: 'غرفة التحدي');
  int _questionCount = 10;
  int _maxPlayers = 4;
  int _timerSeconds = 15;
  String _mode = 'private_battle';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final room = context.watch<RoomProvider>();
    return ChallengeScaffold(
      title: 'إنشاء غرفة',
      subtitle: 'اضبط الجولة ثم شارك الكود مع اللاعبين.',
      children: [
        AppTextField(
          controller: _nameController,
          label: 'اسم الغرفة',
          icon: Icons.meeting_room_rounded,
        ),
        const SizedBox(height: 16),
        _choiceRow(
          'النمط',
          {
            'private_battle': 'خاص',
            'team_battle': 'فرق',
            'categories_points': 'فئات',
          },
          _mode,
          (value) => setState(() => _mode = value),
        ),
        _choiceRow(
          'عدد الأسئلة',
          {5: '5', 10: '10', 15: '15', 20: '20'},
          _questionCount,
          (value) => setState(() => _questionCount = value),
        ),
        _choiceRow(
          'اللاعبون',
          {2: '2', 4: '4', 6: '6', 8: '8'},
          _maxPlayers,
          (value) => setState(() => _maxPlayers = value),
        ),
        _choiceRow(
          'المؤقت',
          {10: '10ث', 15: '15ث', 20: '20ث', 30: '30ث'},
          _timerSeconds,
          (value) => setState(() => _timerSeconds = value),
        ),
        const SizedBox(height: 18),
        AppButton(
          label: 'إنشاء الغرفة',
          icon: Icons.add_rounded,
          isLoading: room.isLoading,
          onPressed: () async {
            final user = context.read<AuthProvider>().user;
            if (user == null) return;
            await context.read<RoomProvider>().createRoom(
              host: user,
              name: _nameController.text.trim(),
              mode: _mode,
              questionCount: _questionCount,
              maxPlayers: _maxPlayers,
              timerSeconds: _timerSeconds,
            );
            if (context.mounted && context.read<RoomProvider>().room != null) {
              Navigator.pushReplacementNamed(context, AppRoutes.roomLobby);
            }
          },
        ),
        if (room.error != null) ...[
          const SizedBox(height: 12),
          Text(room.error!, textAlign: TextAlign.center),
        ],
      ],
    );
  }

  Widget _choiceRow<T>(
    String label,
    Map<T, String> choices,
    T selected,
    ValueChanged<T> onSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: choices.entries.map((entry) {
              return ChoiceChip(
                label: Text(entry.value),
                selected: entry.key == selected,
                onSelected: (_) => onSelected(entry.key),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
