class Repo {
  String name;
  String url;

  Repo(this.name, this.url);

  Repo.fromJson(Map<String, dynamic> repo)
      : name = repo['name'] ?? '',
        url = repo["html_url"] ?? '';

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
      };

  String toString() => name;
}
