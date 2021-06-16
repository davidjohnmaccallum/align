import 'dart:convert';
import 'dart:io';

import 'package:align/models/commit.dart';
import 'package:align/models/pull_request.dart';
import 'package:github/github.dart' as gh;
import 'package:http/http.dart' as http;

class GitHubService {
  gh.GitHub github;
  String token;

  GitHubService(String token)
      : github = gh.GitHub(auth: gh.Authentication.withToken(token)),
        token = token;
  GitHubService.anonymous()
      : github = gh.GitHub(),
        token = '';

  Future<List<Commit>> listCommits(
      String org, String repoName, String branch, int limit) async {
    try {
      var url = Uri.parse(
          "https://api.github.com/repos/$org/$repoName/commits?sha=$branch");
      var response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: "Basic $token",
      });
      if (response.statusCode != 200) {
        print("$url returned ${response.statusCode}");
        return [];
      }
      var rawCommits = jsonDecode(response.body);
      List<Commit> commits =
          rawCommits.map<Commit>((rawCommit) => Commit.fromGitHub(rawCommit));
      print(commits[0]);
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
      return await github.pullRequests
          .list(gh.RepositorySlug(org, repoName))
          .take(limit)
          .map((it) {
        return PullRequest.fromGitHub(it);
      }).toList();
    } catch (err) {
      print(err);
      return [];
    }
  }
}
