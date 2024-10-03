import 'package:flutter/material.dart';
import 'package:final_year_project/services/notificationhandling.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List<String> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifications = prefs.getStringList('notifications') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Text('No notifications'),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_notifications[index]),
                );
              },
            ),
    );
  }
}
