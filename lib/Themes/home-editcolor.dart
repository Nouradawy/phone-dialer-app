import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_states.dart';
import 'package:dialer_app/Modules/Contacts/contacts_screen.dart';
import 'package:dialer_app/NativeBridge/native_bridge.dart';
import 'package:dialer_app/Themes/Cubit/cubit.dart';
import 'package:dialer_app/Themes/Cubit/states.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import '../Components/components.dart';
import '../Layout/incall_screen.dart';
import '../Modules/Contacts/Contacts Cubit/contacts_cubit.dart';
import '../Modules/Phone/phone_Log_screen.dart';
import '../Layout/Cubit/cubit.dart';
import '../Layout/Cubit/states.dart';
import '../NativeBridge/native_states.dart';
import '../Network/Local/shared_data.dart';
import 'theme_config.dart';


class HomeScreenEdite extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var Cubit = AppCubit.get(context);
    double AppbarSize = MediaQuery.of(context).size.height*Cubit.AppbarSize;

    return BlocListener<NativeBridge,NativeStates>(
        listener: (context,state){
          if(state is PhoneStateRinging)
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => InCallScreen()));
          }},
      child: BlocBuilder<ThemeCubit,ThemeStates>(
        builder:(context,state) {

          return DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    backgroundColor: HomePageBackgroundColor(context),
                    extendBodyBehindAppBar: true,
                    appBar:MainAppBarEditor(context, AppbarSize , AppCubit.get(context).searchController),
                    drawerDragStartBehavior: DragStartBehavior.start ,
                    floatingActionButton: ThemeCubit.get(context).dialPadIsShowen==false?FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onPressed: () {
                        ThemeCubit.get(context).dialPadSwitch();
                      },
                      child:Image.asset("assets/Images/dialpad.png",scale:1.8 , color: HexColor("#EEEEEE"),),
                    ):null,
                    body: BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
                      builder:(context,state)=>Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            TabBarView(
                                  children:<Widget> [
                                    ThemeCubit.get(context).dialPadIsShowen==false?PhoneLogScreen():
                                    SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Container(
                                        width:MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height+150,
                                        color:Colors.white,
                                      child: Padding(
                                        padding:  EdgeInsets.only(top:AppbarSize+120 ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 35.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                children: [

                                                  MaterialButton(onPressed: (){

                                                    if(ThemeCubit.get(context).DialPadBackGroundImagePicker==null)
                                                    {
                                                      ThemeCubit.get(context).BackGroundImagePicker();
                                                    }
                                                    else
                                                    {
                                                      ThemeCubit.get(context).DialPadBackGroundImagePicker=null;
                                                      ThemeCubit.get(context).ThemeUpdating();
                                                    }
                                                    // print(DialPadBackgroundShared);
                                                  },
                                                    color:Colors.black45,
                                                    textColor: Colors.white,
                                                    child: Row(

                                                      children:  [
                                                        Text(ThemeCubit.get(context).DialPadBackGroundImagePicker==null?"Add Background Image":"Remove Background Image"),
                                                        SizedBox(width: 10),
                                                        Icon(ThemeCubit.get(context).DialPadBackGroundImagePicker==null?Icons.perm_media_rounded:Icons.layers_clear_rounded),
                                                      ],
                                                    ),
                                                  ),
                                               TextButton(onPressed: (){
                                                 ThemeCubit.get(context).DialPadBackgroundImageAdjust =!ThemeCubit.get(context).DialPadBackgroundImageAdjust;
                                                 ThemeCubit.get(context).ThemeUpdating();
                                               }, child: Row(children: const [
                                                 Text("Adjust"),
                                                 Icon(Icons.arrow_drop_down_rounded),
                                               ],))

                                                ],
                                              ),
                                            ),
                                            AnimatedSize(
                                              curve:Curves.easeIn,
                                              duration: Duration(seconds: 1),
                                              child: Container(
                                                height: ThemeCubit.get(context).DialPadBackgroundImageAdjust==false?0:200,
                                                color: Colors.black,
                                                child: Container(),
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            DefaultTabController(
                                                length: 4,
                                                child: Builder(
                                                  builder: (context) {
                                                    final TabController tabController = DefaultTabController.of(context)!;
                                                    tabController.addListener(() {
                                                      if (tabController.indexIsChanging) {
                                                        print(tabController.index.toString());
                                                        ThemeCubit.get(context).ThemeUpdating();
                                                      }
                                                    });
                                                    return Column(
                                                      children: [
                                                        Container(
                                                          height: 55,
                                                          child: Material(
                                                              color:Colors.deepPurple,
                                                            child:TabBar(
                                                              controller: tabController,
                                                              labelColor: Colors.black,
                                                              labelStyle: const TextStyle(
                                                                fontFamily: "Cairo",
                                                                fontSize: 12,

                                                              ),
                                                              unselectedLabelColor: Colors.white70,
                                                              tabs:[
                                                              Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  color: tabController.index==0?Colors.white:Colors.transparent,
                                                                ),

                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: const [
                                                                    Icon(Icons.numbers),
                                                                    Text("Numbers"),
                                                                  ],)),
                                                              Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  color: tabController.index==1?Colors.white:Colors.transparent,
                                                                ),

                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: const [
                                                                    Icon(Icons.horizontal_distribute_rounded),
                                                                    Text("Divider"),
                                                                  ],)),
                                                              Container(
                                                                alignment: AlignmentDirectional.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  color: tabController.index==2?Colors.white:Colors.transparent,
                                                                ),

                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: const [
                                                                    Icon(Icons.abc_rounded),
                                                                    Text("Alphabets"),
                                                                  ],)),
                                                              Container(
                                                                alignment: AlignmentDirectional.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  color: tabController.index==3?Colors.white:Colors.transparent,
                                                                ),

                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: const [
                                                                    Icon(Icons.gradient),
                                                                    Text("Background"),
                                                                  ],)),
                                                            ],)
                                                          ),
                                                        ),
                                                        Container(
                                                          width: double.infinity,
                                                          height: MediaQuery.of(context).size.height-200,
                                                          child: TabBarView(
                                                              children: [
                                                                ColorPicker(
                                                                  wheelDiameter: 130,
                                                                  wheelSquarePadding: 5,
                                                                  wheelSquareBorderRadius:15,
                                                                  wheelWidth: 13,
                                                                  // enableOpacity: true,
                                                                  // Use the screenPickerColor as start color.
                                                                  color:ThemeCubit.get(context).DialPadNumColor,
                                                                  // Update the screenPickerColor using the callback.
                                                                  pickersEnabled: const <ColorPickerType,bool>{
                                                                    ColorPickerType.custom: true,
                                                                    ColorPickerType.accent: true,
                                                                    ColorPickerType.wheel: true,
                                                                  },
                                                                  onColorChangeEnd: (color) {
                                                                    ThemeCubit.get(context).DialPadNumColor=color;
                                                                    ThemeCubit.get(context).ThemeUpdating();
                                                                  },
                                                                  width: 25,
                                                                  height: 25,
                                                                  borderRadius: 5,

                                                                  subheading: const Align(
                                                                    alignment: AlignmentDirectional.centerStart,
                                                                    child: Text(
                                                                      'shades',
                                                                    ),
                                                                  ), onColorChanged: (Color value) {  },
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                        const Text("Add Divider",style: TextStyle(fontFamily: "Cairo",color: Colors.black)),
                                                                        Switch(value: ThemeCubit.get(context).AddSplitter,
                                                                            onChanged: (v){
                                                                              ThemeCubit.get(context).AddSplitter =! ThemeCubit.get(context).AddSplitter;
                                                                              ThemeCubit.get(context).AddSplitter==true?ThemeCubit.get(context).DialPadSpliteColor=HexColor("00FFFFFF"):ThemeCubit.get(context).DialPadSpliteColor=HexColor("00FFFFFF");
                                                                              ThemeCubit.get(context).ThemeUpdating();
                                                                            }),
                                                                      ]),
                                                                    ),
                                                                    const Divider(),
                                                                    ThemeCubit.get(context).AddSplitter==true?ColorPicker(
                                                                      wheelDiameter: 130,
                                                                      wheelSquarePadding: 5,
                                                                      wheelSquareBorderRadius:15,
                                                                      wheelWidth: 13,
                                                                      // enableOpacity: true,
                                                                      // Use the screenPickerColor as start color.
                                                                      color:ThemeCubit.get(context).DialPadSpliteColor,
                                                                      // Update the screenPickerColor using the callback.
                                                                      pickersEnabled: const <ColorPickerType,bool>{
                                                                        ColorPickerType.custom: true,
                                                                        ColorPickerType.accent: true,
                                                                        ColorPickerType.wheel: true,
                                                                      },
                                                                      onColorChangeEnd: (color) {
                                                                        ThemeCubit.get(context).DialPadSpliteColor=color;
                                                                        ThemeCubit.get(context).ThemeUpdating();
                                                                      },
                                                                      width: 25,
                                                                      height: 25,
                                                                      borderRadius:
                                                                          5,
                                                                      subheading:
                                                                          const Align(
                                                                        alignment: AlignmentDirectional.centerStart,
                                                                            child: Text(
                                                                          'shades',
                                                                        ),
                                                                      ),
                                                                      onColorChanged:
                                                                          (Color value) {},
                                                                    ):Container(),
                                                                  ],
                                                                ),
                                                                ColorPicker(
                                                                  wheelDiameter: 130,
                                                                  wheelSquarePadding: 5,
                                                                  wheelSquareBorderRadius:15,
                                                                  wheelWidth: 13,
                                                                  // enableOpacity: true,
                                                                  // Use the screenPickerColor as start color.
                                                                  color:ThemeCubit.get(context).DialPadAlphaColor,
                                                                  // Update the screenPickerColor using the callback.
                                                                  pickersEnabled: const <ColorPickerType,bool>{
                                                                    ColorPickerType.custom: true,
                                                                    ColorPickerType.accent: true,
                                                                    ColorPickerType.wheel: true,
                                                                  },
                                                                  onColorChangeEnd: (color) {
                                                                    ThemeCubit.get(context).DialPadAlphaColor=color;
                                                                    ThemeCubit.get(context).ThemeUpdating();
                                                                  },
                                                                  width: 25,
                                                                  height: 25,
                                                                  borderRadius: 5,
                                                                  subheading: const Align(
                                                                    alignment: AlignmentDirectional.centerStart,
                                                                    child: Text(
                                                                      'shades',
                                                                    ),
                                                                  ), onColorChanged: (Color value) {  },
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                                                                      child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            const Text("Apply BackgroundColor",style: TextStyle(fontFamily: "Cairo",color: Colors.black)),
                                                                            Switch(value: ThemeCubit.get(context).DialpadBackgroundColor,
                                                                                onChanged: (v){
                                                                                  ThemeCubit.get(context).DialpadBackgroundColor =! ThemeCubit.get(context).DialpadBackgroundColor;
                                                                                  ThemeCubit.get(context).DialpadBackgroundColor==true?ThemeCubit.get(context).DialPadBackgroundColor=HexColor("#F9F9F9"):ThemeCubit.get(context).DialPadBackgroundColor=HexColor("00FFFFFF");
                                                                                  ThemeCubit.get(context).ThemeUpdating();
                                                                                }),
                                                                          ]),
                                                                    ),
                                                                    const Divider(),
                                                                    ThemeCubit.get(context).DialpadBackgroundColor==true?ColorPicker(
                                                                      wheelDiameter: 130,
                                                                      wheelSquarePadding: 5,
                                                                      wheelSquareBorderRadius:15,
                                                                      wheelWidth: 13,
                                                                      // enableOpacity: true,
                                                                      // Use the screenPickerColor as start color.
                                                                      color:ThemeCubit.get(context).DialPadBackgroundColor,
                                                                      // Update the screenPickerColor using the callback.
                                                                      pickersEnabled: const <ColorPickerType,bool>{
                                                                        ColorPickerType.custom: true,
                                                                        ColorPickerType.accent: true,
                                                                        ColorPickerType.wheel: true,
                                                                      },
                                                                      onColorChangeEnd: (color) {
                                                                        ThemeCubit.get(context).DialPadBackgroundColor=color;
                                                                        ThemeCubit.get(context).ThemeUpdating();
                                                                      },
                                                                      width: 25,
                                                                      height: 25,
                                                                      borderRadius:
                                                                      5,
                                                                      subheading:
                                                                      const Align(
                                                                        alignment: AlignmentDirectional.centerStart,
                                                                        child: Text(
                                                                          'shades',
                                                                        ),
                                                                      ),
                                                                      onColorChanged:
                                                                          (Color value) {},
                                                                    ):Container(),
                                                                  ],
                                                                ),
                                                              ]),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                )),
                                          ],
                                        ),
                                      ),),
                                    ),
                                    ContactsScreen(),
                                  ],
                                ),

                            Transform.translate(
                              offset: Offset(0,30),
                              child: Transform.scale(
                                scale:0.8,
                                child: Material(
                                    color: DialPadBackgroundColor(context),
                                    borderRadius: const BorderRadiusDirectional.only(
                                      topStart: Radius.circular(30),
                                      topEnd: Radius.circular(30),
                                    ),
                                    elevation: 10,
                                    child: ThemeCubit.get(context).dialPadIsShowen==true?Dialpad(context, AppbarSize , AppCubit.get(context).dialerController):null),
                              ),
                            ),

                          ],
                        ),
                    ),
                  ),
                );
        },
      ),
    );
  }


}
