import 'package:chairil/core/database/box/notification/notification_box.dart';
import 'package:chairil/core/database/pintupay_box.dart';

import '../../../util/core_function.dart';
import '../../core_database.dart';

class NotficationBoxController {

  static Future save(NotificationBox notificationBoxNew) async {
    await CoreDatabase.openBoxDatabase(PintuPayBox.notification).then((notificationBox) async {
      await notificationBox.add(notificationBoxNew);
    });
  }

  static Future<List<NotificationBox>> load() async {
    List<NotificationBox> listNotification = [];
    await CoreDatabase.openBoxDatabase(PintuPayBox.notification).then((notificationBox) {
      CoreFunction.logPrint("Notification Box", notificationBox.values.toString());
      for (var element in notificationBox.values) {
        listNotification.add(element);
      }
    });
    return listNotification;
  }
}