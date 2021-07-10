import 'package:align/models/readme.dart';
import 'package:align/models/repo.dart';

import 'metadata.dart';

class Microservice {
  Readme readme;
  Repo repo;
  Metadata metadata;

  Microservice(this.readme, this.repo, this.metadata);

  Microservice.fromJson(Map<String, dynamic> json)
      : readme = Readme.fromJson(json["readme"]),
        repo = Repo.fromJson(json["repo"]),
        metadata = Metadata.fromJson(json["metadata"]);

  Map<String, dynamic> toJson() => {
        'readme': readme.toJson(),
        'repo': repo.toJson(),
        'metadata': metadata.toJson(),
      };

  toString() => repo.name;
}
