import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../state/auth_provider.dart';
import '../../state/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            SwitchListTile(
              value: settings.soundOn,
              onChanged: settings.setSound,
              title: const Text('الصوت'),
              secondary: const Icon(Icons.volume_up_rounded),
            ),
            SwitchListTile(
              value: settings.vibrationOn,
              onChanged: settings.setVibration,
              title: const Text('الاهتزاز'),
              secondary: const Icon(Icons.vibration_rounded),
            ),
            SwitchListTile(
              value: settings.notificationsOn,
              onChanged: settings.setNotifications,
              title: const Text('التنبيهات'),
              subtitle: const Text('هيكل جاهز لـ FCM لاحقًا'),
              secondary: const Icon(Icons.notifications_rounded),
            ),
            ListTile(
              leading: const Icon(Icons.language_rounded),
              title: const Text('اللغة'),
              subtitle: const Text('العربية الآن، الإنجليزية لاحقًا'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_rounded),
              title: const Text('الخصوصية'),
              subtitle: const Text('سياسة الخصوصية ستضاف قبل الإطلاق'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.description_rounded),
              title: const Text('الشروط'),
              subtitle: const Text('الشروط ستضاف قبل النشر'),
              onTap: () {},
            ),
            const SizedBox(height: 18),
            AppButton(
              label: 'تغيير اسم اللاعب',
              icon: Icons.edit_rounded,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.username),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'تسجيل الخروج',
              icon: Icons.logout_rounded,
              variant: AppButtonVariant.danger,
              onPressed: () async {
                await context.read<AuthProvider>().signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (_) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
