

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dialer_app/NativeBridge/native_bridge.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workmanager/workmanager.dart';

import '../Components/constants.dart';
import '../Layout/incall_screen.dart';

class NotificationsController{


  // ***************************************************************
  //    INITIALIZATIONS
  // ***************************************************************
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(

        null,
        [
          NotificationChannel(
            channelGroupKey: 'category_tests',
            channelKey: 'Incoming_calls',
            channelName: 'Incoming calls',
            channelDescription: 'Channel with call ringtone',
            defaultColor: const Color(0xFF9D50DD),
            importance: NotificationImportance.Max,
            ledColor: Colors.white,
            channelShowBadge: true,
            locked: true,
            playSound: false,
            enableVibration: true,
          ),
        ],

      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_tests', channelGroupName: 'Basic tests'),
      ],
        debug: true);
  }
  static Future<void> initializeNotificationsEventListeners() async {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationsController.onActionReceivedMethod);
  }

  // ***************************************************************
  //    NOTIFICATIONS EVENT LISTENERS
  // ***************************************************************



  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    switch (receivedAction.buttonKeyPressed) {
      case 'REJECT':
        {
          isRejected = true;
          // Workmanager().registerOneOffTask(
          //   "taskName",
          //   "simplePeriodic1HourTask",
          // );
          ///TODDO:ADD On Reject Function
        }
        break;

    }
  }
  // ***************************************************************
  //    NOTIFICATIONS HANDLING METHODS
  // ***************************************************************

  // static Future<void> receiveCallNotificationAction(
  //     ReceivedAction receivedAction) async {
  //   switch (receivedAction.buttonKeyPressed) {
  //     case 'REJECT':
  //     // Is not necessary to do anything, because the reject button is
  //     // already auto dismissible
  //       break;
  //
  //     case 'ACCEPT':
  //       loadSingletonPage(App.navigatorKey.currentState,
  //           targetPage: InCallScreen(), receivedAction: receivedAction);
  //       break;
  //
  //     default:
  //       loadSingletonPage(App.navigatorKey.currentState,
  //           targetPage: InCallScreen(), receivedAction: receivedAction);
  //       break;
  //   }
  // }
}