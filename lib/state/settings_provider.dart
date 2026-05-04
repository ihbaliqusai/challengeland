import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool soundOn = true;
  bool vibrationOn = true;
  bool notificationsOn = false;
  String languageCode = 'ar';

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    soundOn = preferences.getBool('soundOn') ?? true;
    vibrationOn = preferences.getBool('vibrationOn') ?? true;
    notificationsOn = preferences.getBool('notificationsOn') ?? false;
    languageCode = preferences.getString('languageCode') ?? 'ar';
    notifyListeners();
  }

  Future<void> setSound(bool value) => _setBool('soundOn', value, (next) {
    soundOn = next;
  });

  Future<void> setVibration(bool value) =>
      _setBool('vibrationOn', value, (next) {
        vibrationOn = next;
      });

  Future<void> setNotifications(bool value) =>
      _setBool('notificationsOn', value, (next) {
        notificationsOn = next;
      });

  Future<void> _setBool(
    String key,
    bool value,
    void Function(bool value) apply,
  ) async {
    apply(value);
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }
}
