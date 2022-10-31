import 'package:dialer_app/Themes/theme_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Components/components.dart';
import '../Layout/incall_screen.dart';
import '../home.dart';
import 'Cubit/cubit.dart';
import 'Cubit/states.dart';
import 'home-editcolor.dart';
import 'InCallScreen/incall_screen_edit.dart';

class Theme_Editor extends StatelessWidget {




  List screens = [
    HomeScreenEdite(),
    InCallScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit,ThemeStates>(
      builder: (context,state) {

        return WillPopScope(
          onWillPop: ()async{
            ThemeCubit.get(context).ThemeEditorIsActive=false;
             Navigator.pop(context);
             return true;
            },
          child: Scaffold(

            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 10.0,
              currentIndex: ThemeCubit.get(context).BottomNavIndex,
              onTap: (index) {

                ThemeCubit.get(context).BottomNavIndex = index;
                ThemeCubit.get(context).ThemeUpdating();

              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.aod_rounded),
                    label: 'Home'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.phone_callback_rounded),
                    label: 'CallScreen'
                ),

              ],
            ),
            body:
            Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children:[
              screens[ThemeCubit.get(context).BottomNavIndex],
            ThemeCubit.get(context).ApplyThemeChanges?
            Container(
                height: 150,
                color: Colors.white,
                alignment: AlignmentDirectional.bottomCenter,
                child: BlocBuilder<ThemeCubit,ThemeStates>(
                    builder:(context,state){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0,top:5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

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
                                      controller: ThemeCubit.get(context).ThemeName,
                                      decoration: InputDecoration(
                                        labelStyle: ContactFormLabelTextStyle(),
                                        // icon: FaIcon(FontAwesomeIcons.userNinja,color: ContactFormIconColor(),size: 16,),
                                        suffixIcon: IconButton(onPressed: (){},icon: const Icon(Icons.cancel,size: 20,)),
                                        labelText: "Name",
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

                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(right: 5.0,left: 0),
                                          child: Icon(Icons.remove_circle,size: 18,),
                                        ),
                                        Text("cancel",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,fontFamily: "cairo"),),
                                      ],),
                                  ),
                                ),
                                SizedBox(width: 15),
                                SizedBox(
                                  width: 93,
                                  child: MaterialButton(
                                    elevation: 0,
                                    color: Colors.blue.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(
                                      5,
                                    ),),
                                    onPressed: ()  {
                                      ThemeCubit.get(context).ThemeEditorIsActive = false;
                                      ThemeCubit.get(context).addNewTheme();
                                      ThemeCubit.get(context).SaveThemeList();
                                      ThemeCubit.get(context).ApplyThemeChanges=false;
                                      Navigator.push(context,MaterialPageRoute(builder: (
                                          BuildContext context)=>Home()));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(right: 5.0,left: 0),
                                          child: Icon(Icons.brush_rounded,size: 18,),
                                        ),
                                        Text("Apply",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,fontFamily: "cairo"),),
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
                ),
              ) :
            Container(),


            ]),


          ),
        );
      }
    );
  }
}
