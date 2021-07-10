import 'package:yaml/yaml.dart';

class Metadata {
  String team;
  List<String> dependencies;

  Metadata.fromYaml(YamlMap yaml)
      : team = yaml['team'] ?? '',
        dependencies = yaml['service_dependencies'] != null
            ? yaml['service_dependencies']
                .map<String>((element) => element.toString())
                .toList()
            : [];

  Metadata.fromJson(Map<String, dynamic> json)
      : team = json["team"],
        dependencies = List<String>.from(json["dependencies"]);

  Map<String, dynamic> toJson() => {
        'team': team,
        'dependencies': dependencies,
      };
}
