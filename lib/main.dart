
import 'dart:async';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:dialer_app/Modules/Chat/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/profile/Profile%20Cubit/profile_cubit.dart';
import 'package:dialer_app/Themes/theme_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Components/components.dart';
import 'Components/constants.dart';
import 'Layout/Cubit/cubit.dart';
import 'Modules/Login&Register/Initial_Screen.dart';
import 'Modules/Login&Register/login_screen.dart';
import 'Modules/Phone/Cubit/cubit.dart';
import 'NativeBridge/native_bridge.dart';
import 'Network/Local/cache_helper.dart';
import 'Network/Local/shared_data.dart';
import 'Network/Remote/dio_helper.dart';
import 'Notifications/notifications_controller.dart';
import 'Themes/Cubit/cubit.dart';
import 'home.dart';



Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("on BackGround message");
  print("message data: ${message.data}");
  await Firebase.initializeApp();

  showToast(text: 'on BackGround', state: ToastStates.SUCCESS,);
}



// Future<void> callbackDispatcher() async {
//   Workmanager().executeTask((task, inputData) async {
//     print("I am in Background from callback dispatcher");
//     await const MethodChannel("NativeBridge").invokeMethod("RejectCall").then((value) => null);
//     return Future.value(true);
//   });
//
// }
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // FlutterBackground.initialize();
  // NotificationsController.initializeLocalNotifications();
  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await Firebase.initializeApp();
  DioHelper.dio;
  await CacheHelper.init();
  token = CacheHelper.getData(key: 'token');

  if (await Permission.contacts.request().isGranted) {
    ContactsPermission=true;
  }

  if (await Permission.phone.request().isGranted) {
    PhonePermision=true;
  }

  if (await Permission.microphone.request().isGranted) {
    MicrophonePermission=true;
  }

  // var channel = const MethodChannel('com.example/background_service');
  // var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
  // channel.invokeMethod('startService', callbackHandle?.toRawHandle());


  String NotificationToken = FirebaseMessaging.instance.getToken().toString();


  /// foreground fcm
  FirebaseMessaging.onMessage.listen(( RemoteMessage message)
  {
    print('Got a message whilst in the foreground');
    print("message data: ${message.data}");

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    showToast(text: 'on message', state: ToastStates.SUCCESS,);
  });

  /// when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {

    print('on message opened app');
    print(event.data.toString());

    showToast(text: 'on message opened app', state: ToastStates.SUCCESS,);
  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  GetShardData();
  print("AuthorizationToken: "+token.toString());
  Widget Homescreen = Home();

  if(token != null)
  {
    Homescreen = Home();
  }
  else {
    Homescreen = LoginScreen();
  }
  Bloc.observer = MyBlocObserver();
  runApp( MyApp(homeScreen: Homescreen));


}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  // final bool themeSwitch;
  final Widget homeScreen;


  const MyApp({
    // required this.themeSwitch,
    required this.homeScreen,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    final isBackground = state == AppLifecycleState.paused;
    if(isBackground || state == AppLifecycleState.detached){
      print("AppState : $state");

      const androidConfig = FlutterBackgroundAndroidConfig(
        notificationTitle: "flutter_background example app",
        notificationText: "Background notification for keeping app running in the background",
        notificationImportance: AndroidNotificationImportance.Default,
        notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
      );
      await FlutterBackground.initialize(androidConfig: androidConfig);
      await FlutterBackground.enableBackgroundExecution();

    } else {
      if(state ==AppLifecycleState.resumed) {

        FlutterBackground.initialize();
        await FlutterBackground.disableBackgroundExecution();

      }
      print("AppState : $state");

    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);

    // NotificationsController.initializeNotificationsEventListeners();


if(PhonePermision ==false || ContactsPermission==false)
{
  return MultiBlocProvider(
    providers: [

      // BlocProvider(create:(context)=> ChatAppCubit()),
      BlocProvider(create: (context)=>NativeBridge()..phonestateEvents()),
      BlocProvider(create: (context)=> AppCubit()),
      BlocProvider(create: (context)=>ProfileCubit()),
      BlocProvider(create: (context)=>ThemeCubit()),
      BlocProvider(create: (context)=>ChatAppCubit()),


    ],
    child:BlocBuilder<AppCubit,AppStates>(

        builder:(context,state)
        {
          AwesomeNotifications().isNotificationAllowed().then((value) {
            if(!value)
            {
              AwesomeNotifications().requestPermissionToSendNotifications().then((value) => Navigator.pop(context));
            }
          });
          if(Themedata.isNotEmpty)
          {
            ThemeCubit.get(context).LoadThemeData();
          }
          ThemeSharedPref(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            debugShowMaterialGrid: false,
            theme: ThemeConfig(),
            // themeMode: themeSwitch?ThemeMode.light:ThemeMode.dark,
            home: WillPopScope(
              onWillPop: () async{
                if(Navigator.of(context).canPop())
                {
                  return true;
                } else {
                  NativeBridge.get(context).invokeNativeMethod("sendToBackground");
                  return false;
                }
              },
              child: const Initial_Screen(),
            ),
          );
        }),
  );
}
else {
  return MultiBlocProvider(
      providers: [

        // BlocProvider(create:(context)=> ChatAppCubit()),
        BlocProvider(create: (context)=>NativeBridge()..phonestateEvents()),
        BlocProvider(create:(context)=> PhoneContactsCubit()..GetRawContacts()),
        BlocProvider(create: (context)=> AppCubit()),
        BlocProvider(create: (context)=>ProfileCubit()),
        BlocProvider(create: (context)=>PhoneLogsCubit()),
        BlocProvider(create: (context)=>ThemeCubit()),
        BlocProvider(create: (context)=>ChatAppCubit()),


      ],
      child:BlocBuilder<AppCubit,AppStates>(

        builder:(context,state)
        {


          if(Themedata.isNotEmpty)
            {

              ThemeCubit.get(context).LoadThemeData();
            }
          ThemeSharedPref(context);


                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  debugShowMaterialGrid: false,
                  theme: ThemeConfig(),
                  // themeMode: themeSwitch?ThemeMode.light:ThemeMode.dark,
                  home: WillPopScope(
                    onWillPop: () async{
                      if(Navigator.of(context).canPop())
                        {
                          return true;
                        } else {
                        NativeBridge.get(context).invokeNativeMethod("sendToBackground");
                        return false;
                      }
                    },
                    child: MultiBlocProvider(providers: [
                      BlocProvider.value(
                          value: ProfileCubit.get(context)..GetChatContacts(PhoneContactsCubit.get(context).Contacts)),
                      BlocProvider.value(
                          value: PhoneLogsCubit.get(context)..getCallLogsInitial(PhoneContactsCubit.get(context).Contacts,true)),
                    ], child: homeScreen),
                  ),
                );
              }),
    );
}
  }
}
