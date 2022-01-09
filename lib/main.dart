
import 'package:call_log/call_log.dart';

import 'package:bloc/bloc.dart';
import 'package:dialer_app/Modules/Chat/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/cubit.dart';
import 'package:dialer_app/Themes/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';

import 'Components/components.dart';
import 'Components/constants.dart';
import 'Layout/Cubit/cubit.dart';
import 'Modules/Login&Register/login_screen.dart';
import 'NativeBridge/native_bridge.dart';
import 'Network/Local/cache_helper.dart';
import 'Network/Remote/dio_helper.dart';

void callbackDispatcher() {
  Workmanager().executeTask((dynamic task, dynamic inputData) async {
    print('Background Services are Working!');
    try {
      final Iterable<CallLogEntry> cLog = await CallLog.get();
      print('Queried call log entries');
      for (CallLogEntry entry in cLog) {
        print('-------------------------------------');
        print('F. NUMBER  : ${entry.formattedNumber}');
        print('C.M. NUMBER: ${entry.cachedMatchedNumber}');
        print('NUMBER     : ${entry.number}');
        print('NAME       : ${entry.name}');
        print('TYPE       : ${entry.callType}');
        print('DATE       : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)}');
        print('DURATION   : ${entry.duration}');
        print('ACCOUNT ID : ${entry.phoneAccountId}');
        print('ACCOUNT ID : ${entry.phoneAccountId}');
        print('SIM NAME   : ${entry.simDisplayName}');
        print('-------------------------------------');
      }
      return true;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      return true;
    }
  });
}
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("on BackGround message");
  print("message data: ${message.data}");
  showToast(text: 'on BackGround', state: ToastStates.SUCCESS,);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  String NotificationToken = FirebaseMessaging.instance.getToken(
  ).toString();
  print("device token :");
  print(NotificationToken);


  // foreground fcm
  FirebaseMessaging.onMessage.listen(( RemoteMessage message)
  {
    print('Got a message whilst in the foreground');
    print("message data: ${message.data}");

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    showToast(text: 'on message', state: ToastStates.SUCCESS,);
  });

  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
    print('on message opened app');
    print(event.data.toString());

    showToast(text: 'on message opened app', state: ToastStates.SUCCESS,);
  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  DioHelper.dio;
  await CacheHelper.init();
  token = CacheHelper.getData(key: 'token');
  print("AuthorizationToken: "+token.toString());


  runApp(MyApp());

}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context)=>NativeBridge()..invokeNativeMethod..phonestateEvents(),),
        BlocProvider(
            create: (context)=>AppCubit()),
      ],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        theme: LightThemeData(),
        themeMode: ThemeMode.light,
        home: LoginScreen(),
    ));

  }
}
