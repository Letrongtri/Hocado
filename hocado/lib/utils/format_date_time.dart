import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart' show ViMessages;

String formatDateTime(DateTime dateTime) {
  timeago.setLocaleMessages('vi', ViMessages());
  return timeago.format(dateTime, locale: 'vi');
}

String formatTime(int seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final secs = seconds % 60;

  final buffer = StringBuffer();

  if (hours > 0) buffer.write('${hours}h');
  if (minutes > 0) buffer.write('${minutes}p');
  if (secs > 0 || (hours == 0 && minutes == 0)) buffer.write('${secs}s');

  return buffer.toString();
}
