import 'package:timeago/timeago.dart' as timeago;

String getAgo(DateTime? date) => date == null ? '' : timeago.format(date);

String getAgoFromStr(String? date) {
  if (date == null) return '';
  try {
    DateTime dt = DateTime.parse(date);
    return getAgo(dt);
  } catch (err) {
    print(err);
    return '';
  }
}

List<String> getMarkdownImages(String markdown) {
  var matches = RegExp(r'!\[.*?\]\((.*?)\)').allMatches(markdown);
  return matches.map((match) => match.group(1) ?? "").toList();
}

String replaceMarkdownImages(
  String markdown,
  Map<String, String> githubImages,
) {
  String out = markdown;
  githubImages.forEach((key, value) {
    out = out.replaceAllMapped(
      RegExp(r"!\[(.*?)\]\((.*?)\)"),
      (match) => match.group(2) == key
          ? "![${match.group(1)}]($value)"
          : match.group(0) ?? "",
    );
  });
  return out;
}
