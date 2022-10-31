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
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'theme_edittor.dart';
import 'Cubit/states.dart';
import 'home-editcolor.dart';
import 'Cubit/cubit.dart';
import 'theme_config.dart';




class MultipleThemesView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // ThemeCubit.get(context).ThemeNameController  = List.generate(ThemeCubit.get(context).MyThemeData.length, (i) => TextEditingController());
    return

        BlocBuilder<ThemeCubit,ThemeStates>(
          builder: (context ,state) {

             return Scaffold(
              appBar: MultipleThemeViewAppBar(context , MediaQuery.of(context).size.height * 0.11),
              floatingActionButton: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ), onPressed: () {
                ThemeCubit.get(context).ThemeNameController.text=ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["name"];
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(17),
                          topLeft: Radius.circular(17)),
                    ),
                    builder: (context){

                      return BlocBuilder<ThemeCubit,ThemeStates>(
                        builder:(context,state){
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0,top:5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                  TextButton(onPressed: (){}, child: Text("Cancel")),
                                  Text("Properties"),
                                  TextButton(onPressed: (){}, child: Text("Done")),
                                ]),
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0,right: 25.0,top:10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Theme Name"),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.60,
                                        child: TextFormField(
                                          style: ContactFormMainTextStyle(),
                                          controller: ThemeCubit.get(context).ThemeNameController,
                                          decoration: InputDecoration(
                                            labelStyle: ContactFormLabelTextStyle(),
                                            // icon: FaIcon(FontAwesomeIcons.userNinja,color: ContactFormIconColor(),size: 16,),
                                            suffixIcon: IconButton(onPressed: (){},icon: const Icon(Icons.cancel,size: 20,)),
                                            labelText: "Nickname",
                                            fillColor: ContactFormfillColor(),
                                            filled: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    SizedBox(
                                      width: 93,
                                      child: MaterialButton(
                                        elevation: 0,
                                        color: Colors.red.withOpacity(0.2),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(
                                          5,
                                        ),),
                                        onPressed: (){
                                          ThemeCubit.get(context).CurrentThemeEditIndex = ThemeCubit.get(context).CurrentThemeEditIndex-1;
                                          ThemeCubit.get(context).ThemeSwitcher(ThemeCubit.get(context).CurrentThemeEditIndex).then((value) {
                                            ThemeCubit.get(context).MyThemeData.removeAt(ThemeCubit.get(context).CurrentThemeEditIndex+1);
                                            AppCubit.get(context).SaveActiveTheme();
                                            CacheHelper.saveData(key: "ThemeList", value: json.encode(ThemeCubit.get(context).MyThemeData));
                                            ThemeCubit.get(context).ThemeUpdating();
                                          });



                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                          Padding(
                                            padding: EdgeInsets.only(right: 5.0,left: 0),
                                            child: Icon(Icons.remove_circle,size: 18,),
                                          ),
                                          Text("delete",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,fontFamily: "cairo"),),
                                        ],),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    SizedBox(
                                      width: 86,
                                      child: MaterialButton(
                                        elevation: 0,
                                        color: Colors.blue.withOpacity(0.2),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(
                                          5,
                                        ),),
                                        onPressed: () async {
                                          ThemeCubit.get(context).ThemeEditorIsActive = true;
                                          ThemeCubit.get(context).IsEditting = true;

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
                                          ThemeCubit.get(context).DialPadNumColor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["DialPadNumColor"]);
                                          ThemeCubit.get(context).DialPadAlphaColor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["DialPadAlphabetColor"]);
                                          ThemeCubit.get(context).DialPadSpliteColor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["DialPadSpliteColor"]);
                                          ThemeCubit.get(context).DialPadBackgroundColor = HexColor(ThemeCubit.get(context).MyThemeData[ThemeCubit.get(context).CurrentThemeEditIndex]["DialPadBackgroundColor"]);
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
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                          Padding(
                                            padding: EdgeInsets.only(right: 5.0,left: 0),
                                            child: Icon(Icons.brush_rounded,size: 18,),
                                          ),
                                          Text("edit",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,fontFamily: "cairo"),),
                                        ],),
                                      ),
                                    ),
                                    SizedBox(width: 22,),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      );
                    });
                // ThemeCubit.get(context).ThemeEditorIsActive = !ThemeCubit.get(context).ThemeEditorIsActive;
                //   ThemeCubit.get(context).MultipleThemeEdit = !ThemeCubit.get(context).MultipleThemeEdit;
                  ThemeCubit.get(context).ThemeUpdating();
              },
                child:Icon(Icons.edit)),
                body: Stack(
                  // alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top:28.0,left: 15),
                            child: Text("Theme",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700,height: 0.2)),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 15,bottom: 7),
                            child: Text("Customize your UI theme",style: TextStyle(fontSize: 14)),
                          ),
                          GridView.count(
                              childAspectRatio: 0.7/1,
                              crossAxisCount: 3 ,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                              shrinkWrap: true,
                              children:
                              List.generate(ThemeCubit.get(context).MyThemeData.length+1, (index) {

                                // index <ThemeCubit.get(context).MyThemeData.length?ThemeCubit.get(context).ThemeNameController[index].text = ThemeCubit.get(context).MyThemeData[index]["name"]:null;

                                return index ==ThemeCubit.get(context).MyThemeData.length?InkWell(
                                  onTap:(){
                                    ThemeCubit.get(context).ThemeEditorIsActive = true;
                                    ThemeCubit.get(context).IsEditting = false;
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Theme_Editor()));},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 28.0,top: 15),
                                          child: Icon(Icons.add_rounded,size: 45),
                                        ),
                                        Text("add New Theme")
                                      ],
                                    ),
                                  ),
                                ):Column(
                                      children: [
                                        InkWell(
                                          onTap: ()
                                           {

                                             ThemeCubit.get(context).CurrentThemeEditIndex = index;
                                              ThemeCubit.get(context).ThemeSwitcher(index);
                                              AppCubit.get(context).SaveActiveTheme();
                                          },
                                          child: Stack(
                                              alignment: AlignmentDirectional.topCenter,
                                              children: [
                                                Container(
                                                    width:MediaQuery.of(context).size.width/4,
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
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
                                                ActiveTheme==index?Container(
                                                    width:MediaQuery.of(context).size.width/4,
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(7),
                                                      border: Border.all(color: Colors.blue,width: 2),

                                                    ),
                                                  child: const Align(
                                                      alignment: AlignmentDirectional.bottomEnd,
                                                      child: Icon(Icons.check_circle,color: Colors.blue,)),
                                                ):Container(),

                                              ]
                                          ),
                                        ),
                                        Align(
                                            alignment: AlignmentDirectional.bottomCenter,
                                            child: Text(ThemeCubit.get(context).MyThemeData[index]["name"])),
                                      ]
                                  );}
                              )),
                        ],
                      ),
                    ),
                    ThemeCubit.get(context).ThemeSwitcherProgressIndicator==true?Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 45.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            color: Colors.black,
                          ),
                          width:MediaQuery.of(context).size.width*0.65,
                          height:80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(ThemeCubit.get(context).ThemeSwitcherStarted==true?"Updating Theme on progress":"Theme Updated Successfully"),
                            SizedBox(width: 15),
                              ThemeCubit.get(context).ThemeSwitcherStarted==true?Lottie.network("https://assets4.lottiefiles.com/packages/lf20_jyrxvzzj.json",width: 45):
                              Lottie.network(
                                "https://assets8.lottiefiles.com/packages/lf20_xqeez8ld.json",
                                repeat: false,
                                onLoaded: (value){
                                  Future.delayed(Duration(milliseconds: 2200),(){
                                    ThemeCubit.get(context).ThemeSwitcherProgressIndicator=false;
                                    ThemeCubit.get(context).ThemeUpdating();
                                  });
                                },


                              ),
                          ],),

                        ),
                      ),
                    ):Container(),
                  ],
                ),
            );
          }
        );

  }
}
