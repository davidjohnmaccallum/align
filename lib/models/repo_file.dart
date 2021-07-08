class RepoFile {
  String downloadUrl;

  RepoFile.fromJson(Map<String, dynamic> file)
      : downloadUrl = file['download_url'];

  String toString() => "$downloadUrl";
}
