import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_app/schedule.dart';

class NotificationServices {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: "channelKey",
        channelName: "channelName",
        channelDescription: "channelDescription",
        importance: NotificationImportance.Max,
        defaultPrivacy: NotificationPrivacy.Public,
        defaultRingtoneType: DefaultRingtoneType.Alarm,
        defaultColor: Colors.transparent,
        locked: true,
        enableVibration: true,
        playSound: true,
        enableLights: true,
      )
    ]);
  }

  static Future<void> scheduleNotification({
    required Schedule schedule,
  }) async {
    Random random = Random();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: random.nextInt(1000) + 1,
        channelKey: "channelKey",
        title: schedule.title,
        body: schedule.label,
        category: NotificationCategory.Alarm,
        notificationLayout: NotificationLayout.BigText,
        locked: true,
        wakeUpScreen: true,
        autoDismissible: true,
        fullScreenIntent: true,
        backgroundColor: Colors.transparent,
      ),
      schedule: NotificationCalendar(
        minute: schedule.time.minute,
        hour: schedule.time.hour,
        day: schedule.time.day,
        weekday: schedule.time.weekday,
        month: schedule.time.month,
        year: schedule.time.year,
        preciseAlarm: true,
        allowWhileIdle: true,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      ),
      actionButtons: [
        NotificationActionButton(
          key: "YES",
          label: "Да",
          actionType: ActionType.SilentAction,
        ),
      ],
    );
  }
}
