import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _notificationsOn = false;
  bool _autoDownloadOn = false;
  bool _convertToUSD = false;

  bool get notificationsOn => _notificationsOn;
  bool get autoDownloadOn => _autoDownloadOn;
  bool get convertToUSD => _convertToUSD;

  SettingsProvider() {
    loadSettings();
  }

  void changeNotificationSetting() async {
    _notificationsOn = !_notificationsOn;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsOn', _notificationsOn);
    print("Changed download: $_notificationsOn ");
    notifyListeners();
  }

  void changeAutoDownloadSetting() async {
    _autoDownloadOn = !_autoDownloadOn;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoDownloadOn', _autoDownloadOn);
    print("Changed download: $_autoDownloadOn ");
    notifyListeners();
  }

  void changeConvertToUsdSetting() async {
    _convertToUSD = !_convertToUSD;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('convertToUSD', _convertToUSD);
    print("Changed conver to usd: $_convertToUSD");
    notifyListeners();

  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    print("Logged: ${prefs.getBool('notificationsOn')}");
    print("Logged: ${prefs.getBool('autoDownloadOn')}");
    print("Logged: ${prefs.getBool('convertToUSD')}");
    _notificationsOn = prefs.getBool('notificationsOn') ??  false;
    _autoDownloadOn = prefs.getBool('autoDownloadOn') ??  false;
    _convertToUSD = prefs.getBool('convertToUSD') ?? false;
    notifyListeners();
  }

}