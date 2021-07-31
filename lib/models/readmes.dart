class ReadmesModel {
  List<Readme> readmes;
  ReadmesModel(this.readmes);
}

class Readme {
  String title;
  String team;
  String readmePath;
  String repoName;
  String repoUrl;
  String componentType;
  Readme(this.title, this.team, this.readmePath, this.repoName, this.repoUrl,
      this.componentType);

  Readme.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        team = json["team"],
        readmePath = json["readmePath"],
        repoName = json["repoName"],
        repoUrl = json["repoUrl"],
        componentType = json["componentType"];

  Map<String, dynamic> toJson() => {
        'title': title,
        'team': team,
        'readmePath': readmePath,
        'repoName': repoName,
        'repoUrl': repoUrl,
        'componentType': componentType
      };
}
