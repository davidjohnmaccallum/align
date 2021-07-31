import 'dart:convert';

import 'package:align/models/readmes.dart';
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

  static const String _READMES = '_READMES';

  List<XReadme> get readmes {
    var json = jsonDecode(_prefs?.getString(_READMES) ?? '[]');
    return json.map<XReadme>((it) => XReadme.fromJson(it)).toList();
  }

  set readmes(List<XReadme> value) =>
      _prefs?.setString(_READMES, jsonEncode(value));
}
