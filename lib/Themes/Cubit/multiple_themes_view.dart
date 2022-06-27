import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dialer_app/Components/components.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:dialer_app/Network/Local/cache_helper.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ndialog/ndialog.dart';

import '../theme_edittor.dart';
import 'states.dart';
import '../home-editcolor.dart';
import 'cubit.dart';
import '../theme_config.dart';

class MultipleThemesView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ThemeCubit.get(context).ThemeNameController  = List.generate(ThemeCubit.get(context).MyThemeData.length, (i) => TextEditingController());
    return

        BlocBuilder<ThemeCubit,ThemeStates>(
          builder: (context ,state) {
             return Scaffold(
              appBar: MultipleThemeViewAppBar(context , MediaQuery.of(context).size.height * 0.11),
              floatingActionButton: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ), onPressed: () {
                ThemeCubit.get(context).ThemeEditorIsActive = !ThemeCubit.get(context).ThemeEditorIsActive;
                  ThemeCubit.get(context).MultipleThemeEdit = !ThemeCubit.get(context).MultipleThemeEdit;
                  ThemeCubit.get(context).ThemeEditorChangeindex();
              },
                child:ThemeCubit.get(context).MultipleThemeEdit?Icon(Icons.cancel):Icon(Icons.edit)),
                body: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GridView.count(
                      childAspectRatio: ThemeCubit.get(context).MultipleThemeEdit?0.6:0.7/1,
                      crossAxisCount: 3 ,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      shrinkWrap: true,
                      children:
                      List.generate(ThemeCubit.get(context).MyThemeData.length, (index) {

                        ThemeCubit.get(context).ThemeNameController[index].text = ThemeCubit.get(context).MyThemeData[index]["name"];
                        return Column(
                              children: [
                                InkWell(
                                  onTap: ()
                                   async {
                                    if(ThemeCubit.get(context).MultipleThemeEdit == false)
                                    {
                                      ActiveTheme = index;
                                      AppCubit.get(context).ThemeSwitcher();
                                      ThemeCubit.get(context).ThemeEditorIsActive = false;
                                      if (ThemeCubit.get(context).MyThemeData[ActiveTheme]["DialPadBackground"] != "null") {
                                        final imagePermanent = await SaveImagePermanently(ThemeCubit.get(context).MyThemeData[ActiveTheme]["DialPadBackground"]);
                                        ThemeCubit.get(context).DialPadBackGroundImagePicker = imagePermanent;
                                      } else {
                                        ThemeCubit.get(context).DialPadBackGroundImagePicker = null;
                                      }

                                      if (ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackground"] != "null") {
                                        final imagePermanent = await SaveImagePermanently(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackground"]);
                                        ThemeCubit.get(context).InCallBackGroundImagePicker = imagePermanent;
                                      } else {
                                        ThemeCubit.get(context).InCallBackGroundImagePicker = null;
                                      }
                                    }
                                    else {

                                      if(ThemeCubit.get(context).DeleteTheme ==false)
                                        {
                                          ThemeCubit.get(context).CurrentThemeEditIndex = index;
                                          ThemeCubit.get(context).CustomHomePageBackgroundColor =HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["AppBarBackgroundColor"]);
                                          ThemeCubit.get(context).SearchTextColor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["SearchTextColor"]);
                                          ThemeCubit.get(context).TabBarTextColor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["TabBarColor"]);
                                          ThemeCubit.get(context).SearchBackground = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["SearchBackgroundColor"]);
                                          ThemeCubit.get(context).UnSelectedTabBarColor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["UnSelectedTabBarColor"]);
                                          ThemeCubit.get(context).TabBarIndicatorColor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["TabBarIndicatorColor"]);
                                          ThemeCubit.get(context).PhoneLogDiallerNameColor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["PhoneLogDiallerColor"]);
                                          ThemeCubit.get(context).PhoneLogPhoneNumberColor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["PhoneLogPhoneNumberColor"]);
                                          ThemeCubit.get(context).AppBackGroundColor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["AppBackGroundColor"]);
                                          ThemeCubit.get(context).InCallBackgroundHeight=double.parse(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["InCallBackgroundHeight"]);
                                          ThemeCubit.get(context).InCallBackgroundVerticalPading = double.parse(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["InCallBackgroundVerticalPadding"]);
                                          ThemeCubit.get(context).InCallBackgroundOpacity = double.parse(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["InCallBackgroundOpacity"]);
                                          ThemeCubit.get(context).InCallBackgroundColor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["InCallBackgroundColor"]);
                                          ThemeCubit.get(context).CallerIDcolor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["CallerIDcolor"]);
                                          ThemeCubit.get(context).CallerIDPhoneNumbercolor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["CallerIDPhoneNumbercolor"]);
                                          ThemeCubit.get(context).InCallPhoneStateColor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["InCallPhoneStateColor"]);
                                          ThemeCubit.get(context).CallerIDfontSize = double.parse(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["CallerIDdfontSize"]);
                                          ThemeCubit.get(context).CallerIDPhoneNumberfontSize = double.parse(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["CallerIDPhoneNumberfontSize"]);
                                          ThemeCubit.get(context).InCallPhoneStateSize = double.parse(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["InCallPhoneStateSize"]);
                                          if (ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["DialPadBackground"] != "null") {
                                            final imagePermanent = await SaveImagePermanently(ThemeCubit.get(context).MyThemeData[ActiveTheme]["DialPadBackground"]);
                                            ThemeCubit.get(context).DialPadBackGroundImagePicker = imagePermanent;
                                          } else {
                                            ThemeCubit.get(context).DialPadBackGroundImagePicker = null;
                                          }

                                          if (ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["InCallBackground"] != "null") {
                                            final imagePermanent = await SaveImagePermanently(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackground"]);
                                            ThemeCubit.get(context).InCallBackGroundImagePicker = imagePermanent;
                                          } else {
                                            ThemeCubit.get(context).InCallBackGroundImagePicker = null;
                                          }
                                          Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>Theme_Editor()));
                                        } else{
                                        ThemeCubit.get(context).MyThemeData.removeAt(ThemeCubit.get(context).CurrentThemeEditIndex);
                                       ThemeCubit.get(context).ThemeEditorChangeindex();

                                      }
                                    }
                                  },
                                  child: Stack(
                                      alignment: AlignmentDirectional.topCenter,
                                      children: [
                                        Container(
                                            width:MediaQuery.of(context).size.width/4,
                                            height: 130,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              color: HexColor(ThemeCubit.get(context).MyThemeData[index]["AppBackGroundColor"]),
                                            )
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                            decoration: BoxDecoration
                                              (
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(7) , topRight: Radius.circular(7)),
                                              color:HexColor(ThemeCubit.get(context).MyThemeData[index]["AppBarBackgroundColor"]),
                                            ),
                                            width:MediaQuery.of(context).size.width/4 , height: 24,),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            decoration: BoxDecoration
                                              (
                                              borderRadius: BorderRadius.circular(2),
                                              color:HexColor(ThemeCubit.get(context).MyThemeData[index]["SearchBackgroundColor"]).withOpacity(0.52),
                                            ),
                                            width:MediaQuery.of(context).size.width/6 , height: 9,

                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15,top:31),
                                          child: Row(
                                              children: [
                                                CircleAvatar(radius: 10,backgroundColor: HexColor("#032A37").withOpacity(0.35),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:2.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:4.0, bottom: 3),
                                                        child: Container(
                                                          decoration: BoxDecoration
                                                            (
                                                            borderRadius: BorderRadius.circular(2),
                                                            color:HexColor(ThemeCubit.get(context).MyThemeData[index]["PhoneLogDiallerColor"]).withOpacity(0.52),
                                                          ),
                                                          width:MediaQuery.of(context).size.width/7 , height: 4,

                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:4.0, bottom: 5),
                                                        child: Container(
                                                          decoration: BoxDecoration
                                                            (
                                                            borderRadius: BorderRadius.circular(2),
                                                            color:HexColor(ThemeCubit.get(context).MyThemeData[index]["PhoneLogPhoneNumberColor"]).withOpacity(0.52),
                                                          ),
                                                          width:MediaQuery.of(context).size.width/10 , height: 4,

                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),


                                              ]
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15,top:57),
                                          child: Row(
                                              children: [
                                                CircleAvatar(radius: 10,backgroundColor: HexColor("#032A37").withOpacity(0.35),),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:2.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:4.0, bottom: 3),
                                                        child: Container(
                                                          decoration: BoxDecoration
                                                            (
                                                            borderRadius: BorderRadius.circular(2),
                                                            color:HexColor(ThemeCubit.get(context).MyThemeData[index]["PhoneLogDiallerColor"]).withOpacity(0.52),
                                                          ),
                                                          width:MediaQuery.of(context).size.width/7 , height: 4,

                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:4.0, bottom: 5),
                                                        child: Container(
                                                          decoration: BoxDecoration
                                                            (
                                                            borderRadius: BorderRadius.circular(2),
                                                            color:HexColor(ThemeCubit.get(context).MyThemeData[index]["PhoneLogPhoneNumberColor"]).withOpacity(0.52),
                                                          ),
                                                          width:MediaQuery.of(context).size.width/10 , height: 4,

                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),


                                              ]
                                          ),
                                        ),


                                      ]
                                  ),
                                ),
                                Align(
                                    alignment: AlignmentDirectional.bottomCenter,
                                    child: ThemeCubit.get(context).MultipleThemeEdit == false?Text(ThemeCubit.get(context).MyThemeData[index]["name"]): TextField(controller:ThemeCubit.get(context).ThemeNameController[index])),
                              ]
                          );
                      }
                      )),
                ),
            );
          }
        );

  }
}
