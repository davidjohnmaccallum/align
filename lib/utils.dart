import 'package:timeago/timeago.dart' as timeago;

String getAgo(DateTime? date) => date == null ? "" : timeago.format(date);
