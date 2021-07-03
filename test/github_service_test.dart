import 'dart:io';

import 'package:align/services/github_service.dart';
import 'package:test/test.dart';

void main() {
  var token = Platform.environment['ALIGN_GITHUB_TOKEN'] ?? '';

  setUp(() {
    expect(token, isNotEmpty);
  });

  test('Get repos', () async {
    var gitHubService = GitHubService(token, "flutter");
    var repos = await gitHubService.listReposForOrg();
    // print(repos);
    expect(repos.length, greaterThan(0));
  });

  test('Get commits', () async {
    var gitHubService = GitHubService(token, "davidjohnmaccallum");
    var commits = await gitHubService.listCommits('align', 'master', 3);
    expect(commits.length, 3);
  });

  test('Get commits. Repo not found', () async {
    var gitHubService = GitHubService(token, "davidjohnmaccallum");
    var commits = await gitHubService.listCommits('xxx', 'master', 3);
    expect(commits.length, 0);
  });

  test('Get pull requests', () async {
    var gitHubService = GitHubService(token, "davidjohnmaccallum");
    var prs = await gitHubService.listPullRequests('align', 3);
    expect(prs.length, 3);
  });

  test('Get readme', () async {
    var gitHubService = GitHubService(token, "davidjohnmaccallum");
    var readme = await gitHubService.getReadme('align');
    // print(readme);
    expect(readme, startsWith("#"));
  });

  test('Get file', () async {
    var gitHubService = GitHubService(token, "davidjohnmaccallum");
    var file = await gitHubService.getFile('align', '/lib/main.dart');
    // print(file);
    expect(file, startsWith("import"));
  });
}
