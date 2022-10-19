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
TextStyle PhoneLogDateTextStyle() {
  return TextStyle(
    fontFamily: "Roboto",
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}

TextStyle ContactNameTextStyle(){
  return TextStyle(
    fontFamily: "Cairo",
    fontSize: 15.2,
    height: 1,
    color:HexColor("#292929"),
  );

}TextStyle ContactNumberTextStyle(){
  return TextStyle(
    fontSize: 13.5,
    fontFamily: "Cairo",
    color:HexColor("#8E8E8E"));

}


////////////////////////////////////////////////Colors///////////////////////////////////////////////////


///////////////////////////////////Dialer//////////////////////////////////
TextStyle DialPadNumbersColor(context) =>TextStyle(
    fontFamily: "Quicksand",
    // fontWeight: FontWeight.w300,
    fontSize: 35,
    // height: 0.5,
    color: ThemeCubit.get(context).ThemeEditorIsActive?ThemeCubit.get(context).DialPadNumColor:HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["DialPadNumColor"])
);
TextStyle DialPadAlphabetColor(context) =>TextStyle(
    fontFamily: "Roboto",
    fontSize: 10,
    color:ThemeCubit.get(context).ThemeEditorIsActive?ThemeCubit.get(context).DialPadAlphaColor:HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["DialPadAlphabetColor"])
);
Color DialPadVoiceSymbolColor(context) => ThemeCubit.get(context).ThemeEditorIsActive?ThemeCubit.get(context).DialPadAlphaColor:HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["DialPadAlphabetColor"]);
Color DialPadBorderColor(context) => ThemeCubit.get(context).ThemeEditorIsActive?ThemeCubit.get(context).DialPadSpliteColor:HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["DialPadSpliteColor"]);
Color DialPadBackgroundColor(context)=>ThemeCubit.get(context).ThemeEditorIsActive?ThemeCubit.get(context).DialPadBackgroundColor:HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["DialPadBackgroundColor"]);


////////////////////InCall///////////////////////////
Color ActiveButton(context)=>ThemeCubit.get(context).ThemeEditorIsActive?ThemeCubit.get(context).InCallButtonsNotactiveColor:HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallButtonsNotactiveColor"]);

//////////////CallLogScreen///////////////////////////
HexColor CallLogDetailsBackStrip() =>HexColor("#8F00B9");

HexColor CallLogDetailsleftContainer() => HexColor("#BFE5F9");

HexColor CallLogDetailsRightContainer() => HexColor("#F2E7FE");

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


Color HomePageBackgroundColor(context) => ThemeCubit.get(context).ThemeEditorIsActive?HexColor('#'+ThemeCubit.get(context).AppBackGroundColor.toString()
    .replaceAll("Color", "")
    .substring(5)
    .replaceAll(")", "")
    .toUpperCase()): HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["AppBackGroundColor"]);
HexColor AppBarChatTextColor() => HexColor("#616161");

Color SearchBackgroundColor(context) => HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["SearchBackgroundColor"]).withOpacity(0.52);

Color AppBarChatIconBackgroundColor() => HexColor("#FFFFFF").withOpacity(0.52);

Color AppBarMoreIconColor() => HexColor("#FFD8E4");
Color SearchIconColor() => HexColor("#959595");

Color AppBarBackgroundColor(context) => HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["AppBarBackgroundColor"]);

HexColor AppBarEditIconColor() => HexColor("#0075CE");
Color AppBarEditIconBackGroundColor() => HexColor("#FFD8E4");

Color TabBarlabelColor(context) => HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["TabBarColor"]);
Color TabBarindicatorColor(context) => HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["TabBarIndicatorColor"]);

Color TabBarUnselectedlabelColor(context) => HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["UnSelectedTabBarColor"]);

////////////////////ContactEdit///////////////////////////

TextStyle ContactFormMainTextStyle()=>const TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w500,
);
TextStyle PhoneTextFormMainTextStyle()=>const TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w500,
);
TextStyle ContactFormLabelTextStyle()=>const TextStyle(
  color: Colors.indigo,
  fontWeight: FontWeight.w600,
);
TextStyle PhoneTextFormLabelTextStyle()=>const TextStyle(
  color: Colors.indigo,
  fontWeight: FontWeight.w600,
);
TextStyle PhoneTextFormDropdownTextStyle()=>const TextStyle(
  color: Colors.indigo,
  fontWeight: FontWeight.w600,
  fontSize: 11,
);
Color ContactFormfillColor()=>Colors.white;
Color ContactFormIconColor()=>Colors.indigo;
Color PhoneTextFormIconColor()=>Colors.indigo;
