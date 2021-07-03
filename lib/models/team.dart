import 'repo.dart';

class Team {
  String name;
  List<Repo> repos;

  Team(this.name, this.repos);

  toString() => name;
}
