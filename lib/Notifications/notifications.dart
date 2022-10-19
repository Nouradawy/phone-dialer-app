import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> CreateCallNotification(Title,Body) async{
  await  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: CreateUniqueId(),
        channelKey: 'Incoming_calls',
        title: Title,
        body:Body,
        notificationLayout: NotificationLayout.Default,
        payload: {'username': 'Little Mary'},
        autoDismissible: true,
        displayOnBackground: true,
        displayOnForeground: false,
        // fullScreenIntent: true,
        showWhen: false,
        category: NotificationCategory.Call,
        actionType: ActionType.DismissAction,
        criticalAlert: true,

      ),
      actionButtons: [
      NotificationActionButton(
      key: 'ACCEPT',
      label: 'Accept Call',
      actionType: ActionType.Default,
      color: Colors.green,
      autoDismissible: true),
      NotificationActionButton(
      key: 'REJECT',
      label: 'Reject',
      actionType: ActionType.Default,
      isDangerousOption: true,
      autoDismissible: true),
      ],
  );


}

int CreateUniqueId(){
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}