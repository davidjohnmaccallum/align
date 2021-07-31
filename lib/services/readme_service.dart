import 'package:align/main.dart';
import 'package:align/models/metadata.dart';
import 'package:align/models/readmes.dart';
import 'package:align/models/repo.dart';
import 'package:align/models/repo_file.dart';
import 'package:align/models/repo_raw_file.dart';
import 'package:align/services/github_service.dart';
import 'package:align/services/storage_service.dart';
import 'package:yaml/yaml.dart';

class ReadmeService {
  List<XReadme> dummyReadmes = [
    XReadme(
      "Service 1",
      "Team 1",
      "README.md",
      "readme",
      "https://github.com/davidjohnmaccallum/readme",
      "dashboard",
    )
  ];

  String dummyReadme = """
  # Dummy Readme
  ## Purpose
  This is a dummy readme. Hooray!
  ## Details
  Excepteur non ullamco duis tempor laborum quis adipisicing voluptate ut excepteur deserunt nulla quis. Culpa sit minim sint sint enim duis et tempor consectetur incididunt. In laborum velit commodo nulla.
  """;

  Future<List<XReadme>> listMicroserviceReadmes() async {
    if (dummyMode) return dummyReadmes;

    GitHubService github = GitHubService();

    // Get all repos
    List<Repo> repos = await github.listReposForOrg();
    // Filter non microservices
    List<RepoRawFile> metas = await Future.wait(repos
        .map((repo) => github.getRawFile(repo.name, 'metadata/index.yaml')));
    List<Repo> reposWithMeta = metas
        .where((meta) => meta.contents.isNotEmpty)
        .map((meta) => repos.firstWhere((repo) => repo.name == meta.repo))
        .toList();
    print(reposWithMeta);

    List<XReadme> readmes = [];
    for (var repo in reposWithMeta) {
      var rawMeta = _getMetadata(
          metas.firstWhere((element) => element.repo == repo.name));
      var meta = Metadata.fromYaml(rawMeta);
      String title = repo.name;
      String team = meta.team;
      String readmePath = "README.md";
      String repoName = repo.name;
      String repoUrl = repo.url;
      String componentType = meta.serviceType ?? "";
      XReadme readme = XReadme(
        title,
        team,
        readmePath,
        repoName,
        repoUrl,
        componentType,
      );
      readmes.add(readme);
    }
    return readmes;
  }

  Future<String> getReadme(String repoName, String readmePath) async {
    if (dummyMode) return dummyReadme;

    var github = GitHubService();
    var file = await github.getRawFile(repoName, readmePath);
    return file.contents.replaceAll(RegExp(r'\|\s+$', multiLine: true), "|");
  }

  Map<String, String> _imageUrlCache = {};

  Future<String> getReadmeImage(String repoName, String path) async {
    String? cachedImageUrl = _imageUrlCache["$repoName/$path"];
    if (cachedImageUrl == null) {
      var github = GitHubService();
      RepoFile? file = await github.getFile(repoName, path.toString());
      print("File: $file");
      _imageUrlCache["$repoName/$path"] =
          file?.content.replaceAll(RegExp(r"\n"), "") ?? "";
    }
    return _imageUrlCache["$repoName/$path"]!;
  }

  String getPurpose(String? readmeText) {
    if (readmeText == null) return "";
    var regex = RegExp(r'^## Purpose(.*?\.)', multiLine: true, dotAll: true);
    return regex.firstMatch(readmeText)?.group(1)?.trim() ?? "";
  }

  YamlMap _getMetadata(RepoRawFile file) {
    var yaml = loadYaml(file.contents);
    return yaml.values.toList()[0];
  }
}
