
import 'package:call_log/call_log.dart';

import 'package:bloc/bloc.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:dialer_app/Modules/Chat/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/profile/Profile%20Cubit/profile_cubit.dart';
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
import 'Modules/Phone/Cubit/cubit.dart';
import 'NativeBridge/native_bridge.dart';
import 'Network/Local/cache_helper.dart';
import 'Network/Local/shared_data.dart';
import 'Network/Remote/dio_helper.dart';
import 'Themes/dark_theme.dart';
import 'home.dart';

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


  DioHelper.dio;
  await CacheHelper.init();
  token = CacheHelper.getData(key: 'token');
  ThemeSharedPref();
  // GetShardData();
  print("AuthorizationToken: "+token.toString());
  Widget Homescreen = Home();

  if(token != null)
  {
    Homescreen = Home();
  } else {
    Homescreen = LoginScreen();
  }

  BlocOverrides.runZoned(
        () =>runApp(MyApp(
          themeSwitch :ThemeSwitch,
          homeScreen:Homescreen,
    )),
    blocObserver: MyBlocObserver(),
  );

}

class MyApp extends StatelessWidget {
  final bool themeSwitch;
  final Widget homeScreen;


  const MyApp({
    required this.themeSwitch,
    required this.homeScreen,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider(create:(context)=> ChatAppCubit()),
        BlocProvider(create: (context)=>NativeBridge()..phonestateEvents()),
        BlocProvider(create:(context)=> PhoneContactsCubit()..GetRawContacts()),
        BlocProvider(create: (context)=> AppCubit()),
        BlocProvider(create: (context)=>ProfileCubit()),
        BlocProvider(create: (context)=>PhoneLogsCubit()),

      ],
    child:BlocBuilder<AppCubit,AppStates>(
      builder:(context,state) =>MaterialApp(
                      debugShowCheckedModeBanner: false,
                      debugShowMaterialGrid: false,
                      theme: LightThemeData(),
                      darkTheme: DarkThemeData(),
                      themeMode: themeSwitch?ThemeMode.light:ThemeMode.dark,
                      home: MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value:ProfileCubit.get(context)..GetChatContacts()),
                          BlocProvider.value(
                              value:PhoneLogsCubit.get(context)..getCallLogsInitial(PhoneContactsCubit.get(context).Contacts)),
                        ],
                            child: homeScreen),
                      ),
                  ),
    );
  }
}
