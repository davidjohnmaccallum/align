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

  bool hasRequiredSettings() =>
      getGitHubToken().isNotEmpty &&
      getGitHubOrganisation().isNotEmpty &&
      getJiraUsername().isNotEmpty &&
      getJiraPassword().isNotEmpty;

  String getGitHubToken() {
    return _prefs?.getString('GITHUB_TOKEN') ?? '';
  }

  String getGitHubOrganisation() {
    return _prefs?.getString('GITHUB_ORGANISATION') ?? '';
  }

  String getJiraUsername() {
    return _prefs?.getString('JIRA_USERNAME') ?? '';
  }

  String getJiraPassword() {
    return _prefs?.getString('JIRA_PASSWORD') ?? '';
  }

  void setGitHubToken(String value) {
    _prefs?.setString('GITHUB_TOKEN', value);
  }

  void setGitHubOrganisation(String value) {
    _prefs?.setString('GITHUB_ORGANISATION', value);
  }

  void setJiraUsername(String value) {
    _prefs?.setString('JIRA_USERNAME', value);
  }

  void setJiraPassword(String value) {
    _prefs?.setString('JIRA_PASSWORD', value);
  }
}
