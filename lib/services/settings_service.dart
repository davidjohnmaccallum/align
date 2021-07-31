import 'package:align/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static SettingsService? _singleton;
  SharedPreferences? _prefs;

  static Future<SettingsService> getInstance() async {
    if (_singleton == null) {
      _singleton = SettingsService();
      _singleton?._prefs = await SharedPreferences.getInstance();
    }
    return _singleton!;
  }

  bool hasRequiredSettings() {
    if (dummyMode) return true;
    return getGitHubToken().isNotEmpty && getGitHubOrganisation().isNotEmpty;
  }

  static const String _GITHUB_TOKEN = 'GITHUB_TOKEN';
  static const String _GITHUB_ORGANISATION = 'GITHUB_ORGANISATION';

  String getGitHubToken() {
    if (dummyMode) return "";
    return _prefs?.getString(_GITHUB_TOKEN) ?? '';
  }

  String getGitHubOrganisation() {
    if (dummyMode) return "davidjohnmaccallum";
    return _prefs?.getString(_GITHUB_ORGANISATION) ?? '';
  }

  void setGitHubToken(String value) {
    _prefs?.setString(_GITHUB_TOKEN, value);
  }

  void setGitHubOrganisation(String value) {
    _prefs?.setString(_GITHUB_ORGANISATION, value);
  }

  String toString() => _prefs.toString();
}
