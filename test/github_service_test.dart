// Import the test package and Counter class
import 'package:align/services/github_service.dart';
import 'package:test/test.dart';

void main() {
  var gitHubService = GitHubService.anonymous();

  test('Get commits', () async {
    var commits = await gitHubService.listCommits(
        'davidjohnmaccallum', 'align', 'master', 3);
    expect(commits.length, 3);
  });

  test('Get commits. Repo not found', () async {
    var commits = await gitHubService.listCommits('xxx', 'xxx', 'master', 3);
    expect(commits.length, 0);
  });

  test('Get pull requests', () async {
    var prs =
        await gitHubService.listPullRequests('davidjohnmaccallum', 'align', 3);
    expect(prs.length, 3);
  });
}
