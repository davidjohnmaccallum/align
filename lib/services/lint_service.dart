class LintService {
  bool _isPurposeDocumented(String readme) => readme.contains("## Purpose");

  bool check(String readme) {
    return _isPurposeDocumented(readme);
  }

  String message(String readme) {
    var out = [];
    if (!_isPurposeDocumented(readme)) {
      out.add("Please update service docs");
    }
    return out.join("\n");
  }
}
