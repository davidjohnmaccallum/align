class Swagger {
  Map<String, dynamic> _json;

  Swagger(this._json);

  List<Operation> get operations {
    List<Operation> out = [];
    Map<String, dynamic> paths = _json["paths"];
    for (String pathKey in paths.keys) {
      Map<String, dynamic> path = paths[pathKey];
      for (String verb in path.keys) {
        Map<String, dynamic> jsonOperations = path[verb];

        List<Parameter> parameters = [];

        for (var jsonParameter in jsonOperations['parameters']) {
          parameters.add(Parameter(
            xin: jsonParameter['in'] ?? "",
            name: jsonParameter['name'] ?? "",
            description: jsonParameter['description'] ?? "",
            required: jsonParameter['required'] ?? false,
            schema: "",
          ));
        }

        out.add(Operation(
            id: jsonOperations['operationId'],
            verb: verb,
            path: pathKey,
            description: [
              jsonOperations['summary'],
              jsonOperations['description']
            ].where((it) => it != null && "$it".isNotEmpty).join("\n"),
            parameters: parameters));

        // Map<String, dynamic> responses = operation['responses'];
        // for (String responseKey in responses.keys) {
        //   Map<String, dynamic> response = responses[responseKey];
        //   out += "## Response: $responseKey ${response['description']}\n";
        // }
      }
    }
    return out;
  }
}

class Operation {
  String id;
  String verb;
  String path;
  String description;
  List<Parameter> parameters;
  Operation(
      {required this.id,
      required this.verb,
      required this.path,
      required this.description,
      required this.parameters});
}

class Parameter {
  String xin;
  String name;
  String description;
  bool required;
  String schema;
  Parameter({
    required this.xin,
    required this.name,
    required this.description,
    required this.required,
    required this.schema,
  });
}
