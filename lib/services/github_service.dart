import 'dart:convert';
import 'dart:io';

import 'package:align/models/commit.dart';
import 'package:align/models/pull_request.dart';
import 'package:http/http.dart' as http;

class GitHubService {
  String token;

  GitHubService(String token) : token = token;
  GitHubService.anonymous() : token = '';

  Future<List<Commit>> listCommits(
      String org, String repoName, String branch, int limit) async {
    try {
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
          .map((rawCommit) => Commit.fromGitHub(rawCommit))
          .toList();
      return commits;
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      return [];
    }
  }

  Future<List<PullRequest>> listPullRequests(
      String org, String repoName, int limit) async {
    try {
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
          .map((rawPull) => PullRequest.fromGitHub(rawPull))
          .toList();
      return pulls;
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      return [];
    }
  }
}
