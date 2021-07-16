import 'package:yaml/yaml.dart';

class Metadata {
  String team;
  String? serviceType;
  List<String> dependencies;

  Metadata.fromYaml(YamlMap yaml)
      : team = yaml['team'] ?? '',
        serviceType = yaml['service_types']?[0],
        dependencies = yaml['service_dependencies'] != null
            ? yaml['service_dependencies']
                .map<String>((element) => element.toString())
                .toList()
            : [];

  Metadata.fromJson(Map<String, dynamic> json)
      : team = json["team"],
        serviceType = json["serviceType"],
        dependencies = List<String>.from(json["dependencies"]);

  Map<String, dynamic> toJson() => {
        'team': team,
        'serviceType': serviceType,
        'dependencies': dependencies,
      };
}
