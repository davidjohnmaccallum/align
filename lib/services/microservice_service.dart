import 'package:align/models/metadata.dart';
import 'package:align/models/microservice.dart';
import 'package:align/models/readme.dart';
import 'package:align/models/repo.dart';
import 'package:align/models/repo_raw_file.dart';
import 'package:align/services/github_service.dart';
import 'package:align/services/settings_service.dart';
import 'package:yaml/yaml.dart';

class MicroserviceService {
  GitHubService _github;

  MicroserviceService(String token, String org)
      : _github = GitHubService(token, org);

  MicroserviceService.fromSettings(SettingsService settings)
      : _github = GitHubService.fromSettings(settings);

  Future<List<Microservice>> listMicroservices() async {
    // Get all repos
    List<Repo> repos = await _github.listReposForOrg();
    // Filter non microservices
    List<RepoRawFile> metas = await Future.wait(repos
        .map((repo) => _github.getRawFile(repo.name, '/metadata/index.yaml')));
    List<Repo> reposWithMeta = metas
        .where((meta) => meta.contents.isNotEmpty)
        .map((meta) => repos.firstWhere((repo) => repo.name == meta.repo))
        .toList();
    print(reposWithMeta);

    List<Readme> readmes = await Future.wait(
        reposWithMeta.map((repo) => _github.getReadme(repo.name)));

    List<Microservice> microservices = [];
    for (var repo in reposWithMeta) {
      var readme = readmes.firstWhere((readme) => readme.repo == repo.name);
      var rawMeta = _getMetadata(
          metas.firstWhere((element) => element.repo == repo.name));
      var meta = Metadata.fromYaml(rawMeta);
      var swaggerUrl = "http://${repo.name}.gcp.mrdexpress.prod/swagger.json";
      var microservice = Microservice(readme, repo, meta, swaggerUrl);
      microservices.add(microservice);
    }
    // Get microservices
    return microservices;
  }

  YamlMap _getMetadata(RepoRawFile file) {
    var yaml = loadYaml(file.contents);
    return yaml.values.toList()[0];
  }
}
