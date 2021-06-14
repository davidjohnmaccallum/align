import 'package:align/models/commit.dart';
import 'package:align/models/pull_request.dart';
import 'package:github/github.dart' as gh;

class GitHubService {
  gh.GitHub github;

  GitHubService(String token) : github = gh.GitHub(auth: gh.Authentication.withToken(token));
  GitHubService.anonymous() : github = gh.GitHub();

  Future<List<Commit>> listCommits(String org, String repoName, int limit) async {
    try {
      return await github.repositories
          .listCommits(gh.RepositorySlug(org, repoName))
          .take(limit)
          .map((it) => Commit.fromGitHub(it))
          .toList();
    } catch (err) {
      print(err);
      return [];
    }
  }

  Future<List<PullRequest>> listPullRequests(String org, String repoName, int limit) async {
    try {
      return await github.pullRequests.list(gh.RepositorySlug(org, repoName)).take(limit).map((it) {
        return PullRequest.fromGitHub(it);
      }).toList();
    } catch (err) {
      print(err);
      return [];
    }
  }
}
