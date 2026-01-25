import 'package:flutter/material.dart';
import 'debug_notifications.dart';

/// Page temporaire pour accéder au diagnostic des notifications
class DebugNotificationPage extends StatelessWidget {
  const DebugNotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NotificationDebugWidget();
  }
}
