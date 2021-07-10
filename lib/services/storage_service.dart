import 'dart:convert';

import 'package:align/models/microservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _singleton;
  SharedPreferences? _prefs;

  static Future<StorageService> getInstance() async {
    if (_singleton == null) {
      _singleton = StorageService();
      _singleton?._prefs = await SharedPreferences.getInstance();
    }
    return _singleton!;
  }

  static const String _MICROSERVICES = '_MICROSERVICES';

  List<Microservice> get microservices {
    var json = jsonDecode(_prefs?.getString(_MICROSERVICES) ?? '[]');
    return json.map<Microservice>((it) => Microservice.fromJson(it)).toList();
  }

  set microservices(List<Microservice> value) =>
      _prefs?.setString(_MICROSERVICES, jsonEncode(value));
}
