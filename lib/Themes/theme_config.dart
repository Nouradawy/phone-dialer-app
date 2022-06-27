import 'dart:io';

import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';

import 'Cubit/cubit.dart';

ThemeData ThemeConfig() {
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
    primarySwatch: Colors.indigo,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      ///FloatingActionButton BackGround Color
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
      ///Contact Name (title)
      bodyText1:TextStyle(
        fontFamily: "Cairo",
        fontSize: 15,
        height: 1,
        color:HexColor("#292929"),
      ),
      ///Contact Number (Subtitle)
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
        height: 1.2,
      ),

    ),

  );
}
//////////////////////////////////////////////////Other Text Styles ////////////////////////////////////////

//////////////CallLogScreen(Details)///////////////////////////
TextStyle CallTimeTextStyle() {
  return TextStyle(
    fontFamily: "cairo",
    // fontStyle: FontStyle.italic,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );
}
TextStyle PhoneTypeTextStyle() {
  return TextStyle(
    fontFamily: "Roboto",
    fontSize: 11,
    fontWeight: FontWeight.w300,
    color: Colors.red,

  );
}
TextStyle PhoneLogDate() {
  return TextStyle(
    fontFamily: "Roboto",
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Colors.black
  );
}



////////////////////////////////////////////////Colors///////////////////////////////////////////////////
///////////////////////////////////Dialer//////////////////////////////////
TextStyle DialPadNumbersColor(context) =>TextStyle(
    fontFamily: "Quicksand",
    // fontWeight: FontWeight.w300,
    fontSize: 35,
    // height: 0.5,
    color:Colors.black.withOpacity(0.50)
);
TextStyle DialPadAlphabetColor(context) =>TextStyle(
    fontFamily: "Roboto",
    fontSize: 10,
    color:HexColor("#8F8F8F").withOpacity(0.6)
);
Color DialPadVoiceSymbolColor(context) => Colors.black.withOpacity(0.50);
HexColor DialPadBorderColor(context) => HexColor("#8F00B9");

//////////////CallLogScreen///////////////////////////
HexColor CallLogDetailsBackStrip() =>HexColor("#8F00B9");
// HexColor CallLogDetailsBackStrip() => ThemeSwitch?HexColor("#8F00B9"):HexColor("#8F00B9");
HexColor CallLogDetailsleftContainer() => HexColor("#BFE5F9");
// HexColor CallLogDetailsleftContainer() => ThemeSwitch?HexColor("#BFE5F9"):HexColor("#BFE5F9");
HexColor CallLogDetailsRightContainer() => HexColor("#F2E7FE");
// HexColor CallLogDetailsRightContainer() => ThemeSwitch?HexColor("#F2E7FE"):HexColor("#F2E7FE");
HexColor PhoneLogDiallerNameColor(context) => ThemeCubit.get(context).ThemeEditorIsActive?HexColor('#'+ThemeCubit.get(context).PhoneLogDiallerNameColor.toString()
    .replaceAll("Color", "")
    .substring(5)
    .replaceAll(")", "")
    .toUpperCase()): HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["PhoneLogDiallerColor"]);

HexColor PhoneLogPhoneNumberColor(context) => ThemeCubit.get(context).ThemeEditorIsActive?HexColor('#'+ThemeCubit.get(context).PhoneLogPhoneNumberColor.toString()
    .replaceAll("Color", "")
    .substring(5)
    .replaceAll(")", "")
    .toUpperCase()): HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["PhoneLogPhoneNumberColor"]);



HexColor ContactsFavBackgroundColor() => HexColor("#F2F2F2");
// HexColor ContactsFavBackgroundColor() => ThemeSwitch?HexColor("#F2F2F2"):HexColor("#1F1B24");

Color HomePageBackgroundColor(context) => ThemeCubit.get(context).ThemeEditorIsActive?HexColor('#'+ThemeCubit.get(context).AppBackGroundColor.toString()
    .replaceAll("Color", "")
    .substring(5)
    .replaceAll(")", "")
    .toUpperCase()): HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["AppBackGroundColor"]);
HexColor AppBarChatTextColor() => HexColor("#616161");
// HexColor AppBarChatTextColor() => ThemeSwitch?HexColor("#616161"):HexColor("#000000");
Color SearchBackgroundColor(context) => HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["SearchBackgroundColor"]).withOpacity(0.52);
// Color SearchBackgroundColor() => ThemeSwitch?HexColor("#FFFFFF").withOpacity(0.52):HexColor("#2D4E80").withOpacity(0.52);
Color AppBarChatIconBackgroundColor() => HexColor("#FFFFFF").withOpacity(0.52);
// Color AppBarChatIconBackgroundColor() => ThemeSwitch?HexColor("#FFFFFF").withOpacity(0.52):HexColor("#FFFFFF").withOpacity(0.79);
Color AppBarMoreIconColor() => HexColor("#FFD8E4");
Color SearchIconColor() => HexColor("#959595");
// Color SearchIconColor() => ThemeSwitch?HexColor("#959595"):HexColor("#0075CE");
Color AppBarBackgroundColor(context) => HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["AppBarBackgroundColor"]);

HexColor AppBarEditIconColor() => HexColor("#0075CE");
Color AppBarEditIconBackGroundColor() => HexColor("#FFD8E4");
// Color AppBarEditIconBackGroundColor() => ThemeSwitch?HexColor("#FFD8E4"):HexColor("#1F0054").withOpacity(0.78);
Color TabBarlabelColor(context) => HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["TabBarColor"]);
Color TabBarindicatorColor(context) => HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["TabBarIndicatorColor"]);

Color TabBarUnselectedlabelColor(context) => HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["UnSelectedTabBarColor"]);

// Future<File> DialPadBackgroundImagepath(context)  async => await SaveImagePermanently(ThemeCubit.get(context).DialPadBackGroundImagePicker.path);
// Future<File> InCallBackgroundImagepath(context)  => SaveImagePermanently(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackground"]);

