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
      print(response.body);
      return [];
      // return await github.repositories
      //     .listCommits(gh.RepositorySlug(org, repoName))
      //     .take(limit)
      //     .map((it) => Commit.fromGitHub(it))
      //     .toList();

    } catch (err) {
      print(err);
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
