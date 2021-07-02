import 'microservice.dart';

class Team {
  String name;
  List<Microservice> microservices;

  Team(this.name, this.microservices);

  toString() => name;
}
