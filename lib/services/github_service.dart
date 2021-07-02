import 'dart:convert';
import 'dart:io';

import 'package:align/models/commit.dart';
import 'package:align/models/pull_request.dart';
import 'package:align/services/settings_service.dart';
import 'package:http/http.dart' as http;

class GitHubService {
  Future<List<Commit>> listCommits(
      String repoName, String branch, int limit) async {
    try {
      var settingsService = await SettingsService.getInstance();
      var token = settingsService.getGitHubToken();
      var org = settingsService.getGitHubOrganisation();

      var url = Uri.parse(
          "https://api.github.com/repos/$org/$repoName/commits?sha=$branch");
      var response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });
      if (response.statusCode != 200) {
        print("$url returned ${response.statusCode}");
        return [];
      }
      List rawCommits = jsonDecode(response.body);
      List<Commit> commits = rawCommits
          .take(limit)
          .map((rawCommit) => Commit.fromJson(rawCommit))
          .toList();
      return commits;
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      return [];
    }
  }

  Future<List<PullRequest>> listPullRequests(String repoName, int limit) async {
    try {
      var settingsService = await SettingsService.getInstance();
      var token = settingsService.getGitHubToken();
      var org = settingsService.getGitHubOrganisation();

      var pullsUrl =
          Uri.parse("https://api.github.com/repos/$org/$repoName/pulls");
      var response = await http.get(pullsUrl, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });
      if (response.statusCode != 200) {
        print("$pullsUrl returned ${response.statusCode} and ${response.body}");
        return [];
      }
      List rawPulls = jsonDecode(response.body);
      List<PullRequest> pulls = rawPulls
          .take(limit)
          .map((rawPull) => PullRequest.fromJson(rawPull))
          .toList();
      return pulls;
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      return [];
    }
  }
}
