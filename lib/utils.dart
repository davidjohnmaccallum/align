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
