class SwaggerService {
  toMarkdown(Map<String, dynamic> json) {
    String out = "";
    Map<String, dynamic> paths = json["paths"];
    for (String pathKey in paths.keys) {
      Map<String, dynamic> path = paths[pathKey];
      for (String methodKey in path.keys) {
        Map<String, dynamic> method = path[methodKey];
        out += "# ${methodKey.toUpperCase()} $pathKey\n\n";
        String summaryDescription = [method['summary'], method['description']]
            .where((it) => it != null && "$it".isNotEmpty)
            .join("\n\n");
        if (summaryDescription.isNotEmpty) {
          out += "$summaryDescription\n\n";
        }
        //out += "\n";
        Map<String, dynamic> responses = method['responses'];
        for (String responseKey in responses.keys) {
          Map<String, dynamic> response = responses[responseKey];
          out += "## Response: $responseKey ${response['description']}\n";
        }
        out += "\n";
      }
    }
    return out;
  }
}
