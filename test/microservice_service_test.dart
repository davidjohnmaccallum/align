import 'dart:io';

import 'package:align/models/metadata.dart';
import 'package:align/models/microservice.dart';
import 'package:align/services/microservice_service.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  var token = Platform.environment['ALIGN_GITHUB_TOKEN'] ?? '';

  setUp(() {
    expect(token, isNotEmpty);
  });

  test('Get microservices', () async {
    var microserviceService = MicroserviceService(token, "mrdelivery");
    var microservices = await microserviceService.listMicroservices();
    print(microservices);
    expect(microservices.length, greaterThan(0));
  });

  test('Parse metadata', () {
    var yaml = loadYaml("""
my-service:
  description: This is a test service
  service_dependencies:
  - another-service
  team: Great""");
    var rawMeta = yaml.values.toList()[0];
    var meta = Metadata.fromYaml(rawMeta);
    print(meta);
  });
}
