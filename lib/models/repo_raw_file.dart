class RepoRawFile {
  String repo;
  String path;
  String contents;

  RepoRawFile(this.repo, this.path, this.contents);

  String toString() => repo;
}
