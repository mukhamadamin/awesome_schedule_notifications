import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_app/awesome_notification.dart';
import 'package:push_notification_app/local_notofocations.dart';
import 'package:push_notification_app/notification_services.dart';
import 'package:push_notification_app/schedule.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeNotifications().isNotificationAllowed().then(
    (isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    },
  );
  await NotificationServices.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController textController = TextEditingController();
   static const String routeHome = '/', routeNotification = '/notification-page';
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeHome:
        return MaterialPageRoute(
            builder: (_) =>
                const MyHomePage(title: 'Awesome Notifications Example App'));

      case routeNotification:
        ReceivedAction receivedAction = settings.arguments as ReceivedAction;
        return MaterialPageRoute(
            builder: (_) => NotificationPage(receivedAction: receivedAction));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController,
            ),
            ElevatedButton(
              onPressed: () {
                NotificationServices.scheduleNotification(
                  schedule: Schedule(
                    label: textController.text.trim(),
                    title: 'Лекарства',
                    time: DateTime.now().add(Duration(seconds: 5)),
                  ),
                ).then((value) {
                  setState(() {
                    textController.clear();
                  });
                });
              },
              child: Text('Отправить'),
            )
          ],
        ),
      ),
    );
  }
}


