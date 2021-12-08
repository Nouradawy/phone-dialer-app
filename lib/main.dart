

import 'package:bloc/bloc.dart';
import 'package:dialer_app/Themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Components/constants.dart';

import 'NativeBridge/native_bridge.dart';
import 'home.dart';


main() {

  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());

}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context)=>NativeBridge()..invokeNativeMethod("methodName")..phonestateEvents(),),
      ],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        theme: LightThemeData(),
        themeMode: ThemeMode.light,
        home: Home(),
    ));

  }
}
