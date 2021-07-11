class RepoFile {
  String content;
  String encoding;

  RepoFile.fromJson(Map<String, dynamic> file)
      : content = file['content'],
        encoding = file['encoding'];

  String toString() => "$encoding file";
}
