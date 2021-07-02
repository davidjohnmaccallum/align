import 'dart:convert';
import 'dart:io';

import 'package:align/models/issue.dart';
import 'package:align/services/settings_service.dart';
import 'package:http/http.dart' as http;

class JiraService {
  Future<List<Issue>> findIssuesByLabel(String label) async {
    try {
      var settingsService = await SettingsService.getInstance();
      var username = settingsService.getJiraUsername();
      var password = settingsService.getJiraPassword();

      String jql = Uri.encodeComponent("labels = $label");
      var url = Uri.parse(
          "https://jira.takealot.com/jira/rest/api/2/search?jql=$jql");
      var response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader:
            _getBasicAuthHeader(username, password),
      });
      if (response.statusCode != 200) {
        print("$url returned ${response.statusCode}");
        return [];
      }
      List rawIssues = jsonDecode(response.body)['issues'];
      List<Issue> issues = rawIssues.map((rawIssue) {
        return Issue.fromJson(rawIssue);
      }).toList();
      return issues;
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      return [];
    }
  }

  String _getBasicAuthHeader(String username, String password) =>
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
}
