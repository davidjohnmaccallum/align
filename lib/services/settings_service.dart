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
      getGitHubToken().isNotEmpty && getGitHubOrganisation().isNotEmpty;

  static const String _GITHUB_TOKEN = 'GITHUB_TOKEN';
  static const String _GITHUB_ORGANISATION = 'GITHUB_ORGANISATION';
  static const String _JIRA_USERNAME = 'JIRA_USERNAME';
  static const String _JIRA_PASSWORD = 'JIRA_PASSWORD';

  String getGitHubToken() {
    return _prefs?.getString(_GITHUB_TOKEN) ?? '';
  }

  String getGitHubOrganisation() {
    return _prefs?.getString(_GITHUB_ORGANISATION) ?? '';
  }

  String getJiraUsername() {
    return _prefs?.getString(_JIRA_USERNAME) ?? '';
  }

  String getJiraPassword() {
    return _prefs?.getString(_JIRA_PASSWORD) ?? '';
  }

  void setGitHubToken(String value) {
    _prefs?.setString(_GITHUB_TOKEN, value);
  }

  void setGitHubOrganisation(String value) {
    _prefs?.setString(_GITHUB_ORGANISATION, value);
  }

  void setJiraUsername(String value) {
    _prefs?.setString(_JIRA_USERNAME, value);
  }

  void setJiraPassword(String value) {
    _prefs?.setString(_JIRA_PASSWORD, value);
  }

  String toString() => _prefs.toString();

  // String toString() => """$_GITHUB_TOKEN: ${getGitHubToken()}
  //     $_GITHUB_ORGANISATION: ${getGitHubOrganisation()}
  //     $_JIRA_USERNAME: ${_prefs.toString()}""";
}
