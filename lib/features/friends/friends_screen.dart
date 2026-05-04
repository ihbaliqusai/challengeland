import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/friend_tile.dart';
import '../../core/widgets/loading_view.dart';
import '../../state/auth_provider.dart';
import '../../state/friends_provider.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) context.read<FriendsProvider>().load(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FriendsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.friends),
        actions: [
          IconButton(
            tooltip: 'طلبات الصداقة',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.friendRequests),
            icon: const Icon(Icons.mark_email_unread_rounded),
          ),
        ],
      ),
      body: provider.isLoading
          ? const LoadingView()
          : provider.friends.isEmpty
          ? const EmptyState(message: AppStrings.noFriends)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final friend = provider.friends[index];
                return FriendTile(
                  user: friend,
                  onChallenge: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم تجهيز تحدي مع ${friend.username}'),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: provider.friends.length,
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.userSearch),
        icon: const Icon(Icons.person_search_rounded),
        label: const Text('بحث'),
      ),
    );
  }
}
