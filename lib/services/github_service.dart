import 'dart:convert';
import 'dart:io';

import 'package:align/models/commit.dart';
import 'package:align/models/repo_file.dart';
import 'package:align/models/repo_raw_file.dart';
import 'package:align/models/pull_request.dart';
import 'package:align/models/readme.dart';
import 'package:align/models/repo.dart';
import 'package:align/services/settings_service.dart';
import 'package:align/utils.dart';
import 'package:http/http.dart' as http;

class GitHubService {
  final String _token;
  final String _org;

  GitHubService(this._token, this._org);

  GitHubService.fromSettings(SettingsService settings)
      : _token = settings.getGitHubToken(),
        _org = settings.getGitHubOrganisation();

  Future<List<Repo>> listReposForOrg() async {
    List<Repo> result = [];
    var page = 1;
    while (true) {
      var repos = await _listReposForOrg(page);
      if (repos.length == 0) break;
      result.addAll(repos);
      page++;
    }
    return result;
  }

  Future<List<Repo>> _listReposForOrg(int page) async {
    try {
      var url = Uri.parse(
          "https://api.github.com/orgs/$_org/repos?per_page=100&page=$page");
      var response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: "Bearer $_token",
      });
      if (response.statusCode != 200) {
        print("$url returned ${response.statusCode}");
        return [];
      }
      List rawRepos = jsonDecode(response.body);
      List<Repo> repos =
          rawRepos.map((rawRepo) => Repo.fromJson(rawRepo)).toList();
      return repos;
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      return [];
    }
  }

  Future<List<Commit>> listCommits(
      String repoName, String branch, int limit) async {
    try {
      var url = Uri.parse(
          "https://api.github.com/repos/$_org/$repoName/commits?sha=$branch");
      var response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: "Bearer $_token",
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
      var pullsUrl =
          Uri.parse("https://api.github.com/repos/$_org/$repoName/pulls");
      var response = await http.get(pullsUrl, headers: {
        HttpHeaders.authorizationHeader: "Bearer $_token",
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

  Future<Readme> getReadme(String repoName) async {
    try {
      var pullsUrl =
          Uri.parse("https://api.github.com/repos/$_org/$repoName/readme");
      var response = await http.get(pullsUrl, headers: {
        HttpHeaders.authorizationHeader: "Bearer $_token",
        HttpHeaders.acceptHeader: "application/vnd.github.VERSION.raw"
      });
      if (response.statusCode != 200) {
        print("$pullsUrl returned ${response.statusCode} and ${response.body}");
        return Readme(repoName, '');
      }
      return Readme(repoName, response.body);
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      return Readme(repoName, '');
    }
  }

  Future<RepoFile?> getFile(String repoName, String path) async {
    try {
      var url = Uri.parse(
          "https://api.github.com/repos/$_org/$repoName/contents/$path");
      print(url);
      var response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: "Bearer $_token",
      });
      if (response.statusCode != 200) {
        print("$url returned ${response.statusCode} and ${response.body}");
        return null;
      }
      Map<String, dynamic> json = jsonDecode(response.body);
      print(json);
      return RepoFile.fromJson(json);
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      return null;
    }
  }

  Future<RepoRawFile> getRawFile(String repoName, String path) async {
    try {
      var pullsUrl = Uri.parse(
          "https://api.github.com/repos/$_org/$repoName/contents/$path");
      var response = await http.get(pullsUrl, headers: {
        HttpHeaders.authorizationHeader: "Bearer $_token",
        HttpHeaders.acceptHeader: "application/vnd.github.VERSION.raw"
      });
      if (response.statusCode != 200) {
        print("$pullsUrl returned ${response.statusCode} and ${response.body}");
        return RepoRawFile(repoName, path, '');
      }
      return RepoRawFile(repoName, path, response.body);
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      return RepoRawFile(repoName, path, '');
    }
  }
}
