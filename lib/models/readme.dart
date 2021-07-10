class Readme {
  String repo;
  String readme;

  Readme(this.repo, this.readme);

  Readme.fromJson(Map<String, dynamic> json)
      : repo = json["repo"],
        readme = json["readme"];

  Map<String, dynamic> toJson() => {
        'repo': repo,
        'readme': readme,
      };

  String toString() => repo;

  String get purpose {
    var regex = RegExp(r'^## Purpose(.*?\.)', multiLine: true, dotAll: true);
    return regex.firstMatch(readme)?.group(1)?.trim() ?? "";
  }
}
