import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_states.dart';
import 'package:dialer_app/Modules/Contacts/contacts_screen.dart';
import 'package:dialer_app/NativeBridge/native_bridge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Components/components.dart';
import 'Layout/incall_screen.dart';
import 'Modules/Contacts/Contacts Cubit/contacts_cubit.dart';
import 'Modules/Phone/phone_screen.dart';
import 'Layout/Cubit/cubit.dart';
import 'Layout/Cubit/states.dart';
import 'NativeBridge/native_states.dart';
import 'Themes/light_theme.dart';


class HomeScreenEdite extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var Cubit = AppCubit.get(context);
    double AppbarSize = MediaQuery.of(context).size.height*Cubit.AppbarSize;

    return MultiBlocListener(
      listeners: [
        BlocListener<NativeBridge,NativeStates>(
        listener: (context,state){
          if(state is PhoneStateRinging)
          {
            Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => InCallScreen()));
          }}),
        BlocListener<PhoneContactsCubit,PhoneContactStates>(
          listener: (context,State){
            if(AppCubit.get(context).searchController.text.isEmpty || AppCubit.get(context).dialerController.text.isEmpty){
              PhoneContactsCubit.get(context).isSearching = false;
            }

            if(AppCubit.get(context).searchController.text.isNotEmpty || AppCubit.get(context).dialerController.text.isNotEmpty){
              PhoneContactsCubit.get(context).isSearching = true;
            }
            }),
      ],
    child: BlocBuilder<AppCubit,AppStates>(
      builder:(context,state) {
        return DefaultTabController(
                length: 2,
                child: Scaffold(
                  backgroundColor: HomePageBackgroundColor(),
                  extendBodyBehindAppBar: true,
                  appBar:MainAppBarEditor(context, AppbarSize , AppCubit.get(context).searchController),
                  drawer: AppDrawer(context, AppbarSize),
                  drawerDragStartBehavior: DragStartBehavior.start ,
                  floatingActionButton: Cubit.isShowen==false?FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onPressed: () {
                      Cubit.dialpadShow();
                    },
                    child:Image.asset("assets/Images/dialpad.png",scale:1.8 , color: HexColor("#EEEEEE"),),
                  ):null,
                  body: BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
                    builder:(context,state)=>Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          TabBarView(
                                children:<Widget> [
                                  PhoneScreen(),
                                  ContactsScreen(),
                                ],
                              ),

                          Material(
                              color: HexColor("#F9F9F9"),
                              borderRadius: const BorderRadiusDirectional.only(
                                topStart: Radius.circular(30),
                                topEnd: Radius.circular(30),
                              ),
                              elevation: 10,
                              child: Cubit.isShowen?Dialpad(context, AppbarSize , AppCubit.get(context).dialerController):null),

                        ],
                      ),
                  ),
                ),
              );
      },
    )


        );
  }


}
