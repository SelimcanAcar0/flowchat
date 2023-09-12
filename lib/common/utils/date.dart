import 'package:get/get.dart';
import 'package:intl/intl.dart';

String duTimeLineFormat(DateTime dt) {
  var now = DateTime.now();
  var difference = now.difference(dt);
  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} m ago';
  }

  if (difference.inHours < 24) {
    return '${difference.inHours} h ago';
  } else if (difference.inDays < 30) {
    return '${difference.inDays} d ago';
  } else if (difference.inDays < 365) {
    final dtFormat = DateFormat('MM-dd');
    return dtFormat.format(dt);
  } else {
    final dtFormat = DateFormat('yyyy-MM-dd');
    var str = dtFormat.format(dt);
    return str;
  }
}

String numberToDay(int dt) {
  switch (dt) {
    case 1:
      return 'monday'.tr;
    case 2:
      return 'tuesday'.tr;
    case 3:
      return 'wednesday'.tr;
    case 4:
      return 'thursday'.tr;
    case 5:
      return 'friday'.tr;
    case 6:
      return 'saturday'.tr;
    case 7:
      return 'sunday'.tr;
    default:
      return '';
  }
}
