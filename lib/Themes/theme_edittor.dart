import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Components/components.dart';
import '../home.dart';
import 'Cubit/cubit.dart';
import 'Cubit/states.dart';
import 'home-editcolor.dart';
import 'InCallScreen/incall_screen_edit.dart';

class Theme_Editor extends StatelessWidget {




  List screens = [
    HomeScreenEdite(),
    InCallScreenEdit(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit,ThemeStates>(
      builder: (context,state) {

        return Scaffold(

          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 10.0,
            currentIndex: ThemeCubit.get(context).BottomNavIndex,
            onTap: (index) {

              ThemeCubit.get(context).BottomNavIndex = index;
              ThemeCubit.get(context).ThemeEditorChangeindex();

            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt_sharp),
                  label: 'PhoneLog'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt_sharp),
                  label: 'PhoneLog'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt_sharp),
                  label: 'PhoneLog'
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
                    style: TextStyle(
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


        );
      }
    );
  }
}
