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
            ThemeCubit.get(context).ApplyThemeChanges?Container(
                height: 150,
                color: Colors.white,
                alignment: AlignmentDirectional.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Enter ThemeName: "),
                    TextField(
                      style: const TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 12,
                      ),
                      controller: ThemeCubit.get(context).ThemeName,
                      textAlign:TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: (value){

                      },
                      decoration: InputDecoration(
                        // hintText: "Search among ${PhoneContactsCubit.get(context).Contacts.length} contact(s)",
                        // contentPadding: EdgeInsets.all(0),
                        // alignLabelWithHint: true,
                        // labelText:"Search",
                        // hintStyle:TextStyle(
                        //   fontFamily: "OpenSans",
                        //   fontSize: 12,
                        //   color: HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["SearchTextColor"]),
                        // ),
                        // isCollapsed: true,
                        border:InputBorder.none,
                        // fillColor: SearchBackgroundColor(),
                      ),
                    ),
                    MaterialButton(onPressed: (){
                      ThemeCubit.get(context).ThemeEditorIsActive = false;
                      ThemeCubit.get(context).addNewTheme();
                      ThemeCubit.get(context).SaveThemeList();
                      ThemeCubit.get(context).ApplyThemeChanges=false;
                      Navigator.push(context,MaterialPageRoute(builder: (
                          BuildContext context)=>Home()));
                    },
                      child: Text("Submit"),
                      color:Colors.black45,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ):Container(),


            ]),


          ),
        );
      }
    );
  }
}
