import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  log("message received! ${message.notification!.title}");
}

class NotificationService {
  static Future<void> initialize() async {
    // used directly access with class name with the help of static
    // for ios permissions
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    /////////////////////////////
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        log(token);
      }
      FirebaseMessaging.onBackgroundMessage(
          backgroundHandler); // should be global background handler

      // FirebaseMessaging.onMessage.listen((event) {
      //   log("Message Receied! ${event.notification!.title}");
      // });

      log("Notifications Initialized!");
    }
  }
}
