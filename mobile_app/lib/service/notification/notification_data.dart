/*import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationData {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Handle the foreground messages
  void handleMessage(RemoteMessage? message) {
    try {
      print('Handling background message: ${message?.data}');
      // Add your custom handling logic here
    } catch (e, stackTrace) {
      print('Error handling background message: $e\n$stackTrace');
    }
  }

  // Handle the background messages
  Future<void> handleBackgroundMessage(RemoteMessage? message) async {
    if (message == null) {
      print('Background message is null');
      return;
    }

    print('Handling background message: ${message.data}');
  }

  Future<void> initPushNotifications() async {
    // Set foreground notification presentation options for iOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    // Handle the initial notification when the app is in the foreground
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    handleMessage(initialMessage);

    // Listen for notifications when the app is in the foreground
    FirebaseMessaging.onMessage.listen(handleMessage);

    // Listen for notifications when the app is in the background
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // WHY NULL CHECK ?????
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    initPushNotifications();
  }
}*/



/*import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/admin/chat/chat_page.dart';
import 'package:mobile_app/screens/user/home_page/chat_page.dart';

class NotificationData {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final BuildContext context;

  NotificationData(this.context);

  Future<void> initPushNotifications() async {
    // Set foreground notification presentation options for iOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    try {
      // Handle the initial notification when the app is in the foreground
      FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

      // Listen for notifications when the app is in the foreground
      FirebaseMessaging.onMessage.listen(handleMessage);

      // Listen for notifications when the app is in the background
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    } catch (e) {
      print(e.toString());
    }
  }

  // Handle the foreground and background messages
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
  }

  // Handle the background message
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Title: ${message.notification?.title}');
    // Extract the sender information from the notification payload
    String senderId = message.data['senderId'];
    String senderEmail = message.data['senderEmail'];

    // Determine which chat page to open based on sender information
    if (senderId == 'admin') {
      // Open admin chat page
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              AdminChatPage(receiverId: senderId, receiverEmail: senderEmail)));
    } else {
      // Open user chat page
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ChatPage(receiverId: senderId, receiverEmail: senderEmail)));
    }
  }

  // Request permission and get the FCM token
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    await initPushNotifications();
  }
}*/
