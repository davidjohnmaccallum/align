import 'dart:convert';
import 'dart:io';

import 'package:align/main.dart';
import 'package:align/models/repo_file.dart';
import 'package:align/models/repo_raw_file.dart';
import 'package:align/models/repo.dart';
import 'package:align/services/settings_service.dart';
import 'package:http/http.dart' as http;

class GitHubService {
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
      SettingsService settings = await SettingsService.getInstance();
      var url = Uri.parse(
          "https://api.github.com/orgs/${settings.getGitHubOrganisation()}/repos?per_page=100&page=$page");
      var response = await http.get(url, headers: getHeaders(settings));
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

  Future<RepoFile?> getFile(String repoName, String path) async {
    try {
      SettingsService settings = await SettingsService.getInstance();
      var url = Uri.parse(
          "https://api.github.com/repos/${settings.getGitHubOrganisation()}/$repoName/contents/$path");
      print(url);
      var response = await http.get(url, headers: getHeaders(settings));
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
      SettingsService settings = await SettingsService.getInstance();
      var pullsUrl = Uri.parse(
          "https://api.github.com/repos/${settings.getGitHubOrganisation()}/$repoName/contents/$path");
      var headers = getHeaders(settings);
      headers[HttpHeaders.acceptHeader] = "application/vnd.github.VERSION.raw";
      var response = await http.get(pullsUrl, headers: headers);
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

  Map<String, String> getHeaders(SettingsService settings) {
    if (dummyMode) return {};
    return {
      HttpHeaders.authorizationHeader: "Bearer ${settings.getGitHubToken()}",
    };
  }
}
