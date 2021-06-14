import 'package:align/models/commit.dart';
import 'package:github/github.dart';

class GitHubService {
  GitHub github;

  GitHubService(String token) : github = GitHub(auth: Authentication.withToken(token));
  GitHubService.anonymous() : github = GitHub();

  Future<List<Commit>> listCommits(String org, String repoName, int limit) async {
    try {
      return await github.repositories
          .listCommits(RepositorySlug(org, repoName))
          .take(limit)
          .map((it) => Commit.fromGitHub(it))
          .toList();
    } catch (err) {
      //print(err);
      return [];
    }
  }

  Future<List<PullRequest>> listPullRequests(String org, String repoName, int limit) async {
    try {
      return await github.pullRequests
          .list(RepositorySlug(org, repoName))
          .take(limit)
          .map((it) => PullRequest.fromGitHub(it))
          .toList();
    } catch (err) {
      //print(err);
      return [];
    }
  }
}
