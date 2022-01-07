import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData LightThemeData() {
  return ThemeData(
    primaryColor: Colors.blueGrey,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
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
        backgroundColor:HexColor("#FFD8E4"),
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



Color SearchBackgroundColor() => HexColor("#FFFFFF").withOpacity(0.52);
Color AppBarChatIconBackgroundColor() => HexColor("#FFFFFF").withOpacity(0.52);
Color AppBarMoreIconColor() => HexColor("#FFD8E4");
Color SearchIconColor() => HexColor("#959595");
Color AppBarBackgroundColor() => HexColor("#EAE6F2");
Color AppBarEditIconColor() => HexColor("#FFD8E4");
Color TabBarlabelColor() => HexColor("#57E3A0");
Color TabBarindicatorColor() => HexColor("#57E3A0");
Color TabBarUnselectedlabelColor() => HexColor("#616161");