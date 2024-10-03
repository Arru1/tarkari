import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  SharedPreferences? _prefs;

  // ValueNotifier to notify listeners of changes in notifications list
  ValueNotifier<List<String>> notificationsList =
      ValueNotifier<List<String>>([]);

  void initialize() async {
    // Set up Firebase messaging
    await _firebaseMessaging.requestPermission();
    _firebaseMessaging.setAutoInitEnabled(false);

    // Set the background message handler
   // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // Configure local notification settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Initialize the flutterLocalNotificationsPlugin without onSelectNotification
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Initialize shared preferences
    _prefs = await SharedPreferences.getInstance();

    // Load existing notifications from SharedPreferences
    _loadStoredNotifications();

    // Start listening for incoming messages
    _listenForMessages();
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Handling background message: ${message.notification?.title}");
  // Store the notification data
  _storeNotification(
      '${message.notification?.title}: ${message.notification?.body}');
  // You can also schedule a local notification here if needed
}


  void _listenForMessages() {
    // Listen for incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received message: ${message.notification?.title}');
      // Handle the message here
      _showLocalNotification(
          message.notification?.title ?? '', message.notification?.body ?? '');
      // Store the notification data
      _storeNotification(
          '${message.notification?.title}: ${message.notification?.body}');
    });

    // Handle notification taps when the app is in the background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'Notification tapped while app is in background: ${message.notification?.title}');
      // Handle the tap here (e.g., navigate to a specific screen)
    });
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> _storeNotification(String notification) async {
    if (_prefs != null) {
      List<String> notifications = _prefs!.getStringList('notifications') ?? [];
      notifications.add(notification);
      await _prefs!.setStringList('notifications', notifications);

      // Update the notifications list
      _loadStoredNotifications();
    }
  }

  Future<void> _loadStoredNotifications() async {
    if (_prefs != null) {
      List<String> notifications = _prefs!.getStringList('notifications') ?? [];
      notificationsList.value = notifications;
      print('Stored notifications: $notifications');
    }
  }
}
