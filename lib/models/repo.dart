class Repo {
  String name;

  Repo(this.name);

  Repo.fromJson(Map<String, dynamic> repo) : name = repo['name'] ?? '';

  String toString() => name;
}
