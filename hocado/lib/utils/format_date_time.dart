import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart' show ViMessages;

String formatDateTime(DateTime dateTime) {
  timeago.setLocaleMessages('vi', ViMessages());
  return timeago.format(dateTime, locale: 'vi');
}
