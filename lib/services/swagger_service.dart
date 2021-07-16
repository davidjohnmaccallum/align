import 'dart:convert';

import 'package:align/models/swagger.dart';
import 'package:http/http.dart' as http;

class SwaggerService {
  Future<Swagger?> getSwagger(String url) async {
    var res = await http.get(Uri.parse(url));
    if (res.statusCode < 300) {
      return Swagger(jsonDecode(res.body));
    }
  }
}
