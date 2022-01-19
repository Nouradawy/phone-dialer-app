import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData LightThemeData() {
  return ThemeData(
    primaryColor: Colors.blueGrey,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: HexColor("#6D637F")),
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor("#FAFAFA"),
        statusBarIconBrightness: Brightness.dark,
      ),
      // shape:RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(7)
      // ),
    ),
    primarySwatch: Colors.blue,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor:HexColor("#4527A0"),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        fontFamily: "OpenSans",
        fontSize: 17,
        fontWeight:FontWeight.w500,
        color:HexColor("#616161"),
      ),
      headline2: TextStyle(
        fontFamily: "OpenSans",
        fontSize: 12,
        color: HexColor("#A1A1A1"),
      ),
      headline3: TextStyle(
        fontFamily: "Quicksand",
        // fontWeight: FontWeight.w300,
        fontSize: 35,
        // height: 0.5,
        color:Colors.black.withOpacity(0.50)
      ),
      headline4: TextStyle(
          fontFamily: "Roboto",
          fontSize: 10,
          color:HexColor("#8F8F8F").withOpacity(0.6)
      ),
      bodyText1:TextStyle(
        fontFamily: "Cairo",
        fontSize: 15,
        height: 1,
        color:HexColor("#292929"),
      ),
      bodyText2: TextStyle(
        fontSize: 12,
        fontFamily: "Cairo",
        color:HexColor("#8E8E8E"),
      ),
      subtitle1: TextStyle(
        fontFamily: "Quicksand",
        fontSize:11,
        fontWeight: FontWeight.w400,
        color:HexColor("#505050").withOpacity(0.74),
      ),
      subtitle2: TextStyle(
        fontFamily: "Roboto",
        fontSize: 10,
        color:HexColor("#949494").withOpacity(0.6),
      ),
      button:  TextStyle(
        fontFamily: "Quicksand",
        fontWeight: FontWeight.w400,
        fontSize: 10,
        color: Colors.white.withOpacity(0.80),
        letterSpacing: 0,
      ),
      caption: TextStyle(
        fontFamily: "Cairo",
        fontSize: 10,
        color: Colors.black,
        letterSpacing: 0,
        fontWeight: FontWeight.w500,
      ),

    ),

  );
}
HexColor ContactsFavBackgroundColor() => ThemeSwitch?HexColor("#F2F2F2"):HexColor("#1F1B24");
Color HomePageBackgroundColor() => ThemeSwitch?HexColor("#FAFAFA"):HexColor("#121212");
HexColor AppBarChatTextColor() => ThemeSwitch?HexColor("#616161"):HexColor("#000000");
Color SearchBackgroundColor() => ThemeSwitch?HexColor("#FFFFFF").withOpacity(0.52):HexColor("#2D4E80").withOpacity(0.52);
Color AppBarChatIconBackgroundColor() => ThemeSwitch?HexColor("#FFFFFF").withOpacity(0.52):HexColor("#FFFFFF").withOpacity(0.79);
Color AppBarMoreIconColor() => HexColor("#FFD8E4");
Color SearchIconColor() => ThemeSwitch?HexColor("#959595"):HexColor("#0075CE");
Color AppBarBackgroundColor(context) => AppCubit.get(context).EditorIsActive?AppCubit.get(context).CustomHomePageBackgroundColor:ThemeSwitch?HexColor("#EAE6F2"):HexColor("#2A2A2A");
HexColor AppBarEditIconColor() => HexColor("#0075CE");
Color AppBarEditIconBackGroundColor() => ThemeSwitch?HexColor("#FFD8E4"):HexColor("#1F0054").withOpacity(0.78);
Color TabBarlabelColor() => HexColor("#00B5EE");
Color TabBarindicatorColor() => HexColor("#00B5EE");
Color TabBarUnselectedlabelColor() => ThemeSwitch?HexColor("#A5A5A5"):HexColor("#E1E1E1");