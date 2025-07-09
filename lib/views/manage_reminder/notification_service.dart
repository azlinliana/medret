import 'package:flutter/material.dart';
import 'package:medret/models/medication_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService{
  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // We'll be called when button is pressed - dark theme
    Future<void> initializeNotification() async {
      // tz.initializeTimeZones(); Don't need this anymore because use _configureLocalTimezone();
      await _configureLocalTimeZone();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
          selectNotification(notificationResponse.payload);
        },
      );
    }


    // Immediate Notification when clicking the button
    Future<void> displayNotification({required String title, required String body}) async {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'channelId', 
        'channelName',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
      );

      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        0, 
        title, 
        body, 
        platformChannelSpecifics,
        payload: 'The payload has been specified, that will passed back through your application when the user has tapped on a notification.'
      );
    }

    Future<void> scheduledNotification(int hour, int minutes, MedicationModel notification) async {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        notification.medicationName,
        'Time for your medication',
        _convertTime(hour, minutes),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'Your channel ID',
            'Your channel name',
            channelDescription: 'repeating description',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }


    tz.TZDateTime _convertTime(int hour, int minutes) {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduleDate = 
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

      if(scheduleDate.isBefore(now)) {
        scheduleDate.add(const Duration(days: 1));
      }
      return scheduleDate;
    }

    Future<void> _configureLocalTimeZone() async {
      tz.initializeTimeZones();
      final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZone));
    }

  Future selectNotification(String? payload) async {
    if(payload != null) {
      // print('notification payload: $payload');
      debugPrint('notification payload: $payload');
    }
    else {
      debugPrint("Notification Done");
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }
}