import 'package:align/models/readme.dart';
import 'package:align/models/repo.dart';
import 'package:yaml/yaml.dart';

class Microservice {
  Readme readme;
  Repo repo;
  MicroserviceMetadata metadata;
  Microservice(this.readme, this.repo, this.metadata);
  toString() => repo.name;
}

class MicroserviceMetadata {
  String description;
  String team;
  List<String> dependencies;
  MicroserviceMetadata.fromYaml(YamlMap metadata)
      : description = metadata['description'] ?? '',
        team = metadata['team'] ?? '',
        dependencies = metadata['service_dependencies'] != null
            ? metadata['service_dependencies']
                .map<String>((element) => element.toString())
                .toList()
            : [];
}
