
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bg_launcher/bg_launcher.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_states.dart';
import 'package:dialer_app/Modules/Contacts/contacts_screen.dart';
import 'package:dialer_app/NativeBridge/native_bridge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

import 'Components/components.dart';
import 'Components/constants.dart';
import 'Layout/incall_screen.dart';
import 'Modules/Contacts/Contacts Cubit/contacts_cubit.dart';

import 'Modules/Contacts/appcontacts.dart';
import 'Modules/Phone/Cubit/cubit.dart';
import 'Modules/Phone/phone_screen.dart';
import 'Layout/Cubit/cubit.dart';
import 'Layout/Cubit/states.dart';
import 'Modules/profile/Profile Cubit/profile_cubit.dart';
import 'NativeBridge/native_states.dart';
import 'Themes/theme_config.dart';
import 'main.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var Cubit = AppCubit.get(context);
    double AppbarSize = MediaQuery.of(context).size.height*Cubit.AppbarSize;
    return BlocListener<NativeBridge,NativeStates>(
        listener: (context,state){
          if(state is PhoneStateRinging )
          {
            NativeBridge.get(context).isRinging = true;
            NativeBridge.get(context).OnRecivedCallingSession(ProfileCubit.get(context).CurrentUser[0].phone.toString());
            NativeBridge.get(context).GetCallerID(PhoneContactsCubit.get(context).Contacts);

            NativeBridge.get(context).CallerID.isNotEmpty?NativeBridge.get(context).InCallNotes():null;
            NativeBridge.get(context).Calls.add({
              "PhoneNumber" : NativeBridge.get(context).PhoneNumberQuery,
              "DisplayName" : NativeBridge.get(context).CallerID.isNotEmpty?NativeBridge.get(context).CallerID[0]["CallerID"]:"",

              "Avatar" : NativeBridge.get(context).contact?.thumbnail,
              "PhoneState" : PhoneStateRinging,
              "Notes" : NativeBridge.get(context).CallerID.isNotEmpty?NativeBridge.get(context).CallNotes:null,
            });
            BgLauncher.bringAppToForeground();
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) => InCallScreen()),
                  (Route<dynamic>route)=>false,);

          }
          if(state is PhoneStateDialing && NativeBridge.get(context).PhoneNumberQuery != null)
          {
            NativeBridge.get(context).OnConference=false;
            // NativeBridge.get(context).CreateCallingSession(ProfileCubit.get(context).CurrentUser[0].phone.toString());
            NativeBridge.get(context).GetCallerID(PhoneContactsCubit.get(context).Contacts);

            NativeBridge.get(context).CallerID.isNotEmpty?NativeBridge.get(context).InCallNotes():null;
            NativeBridge.get(context).Calls.isNotEmpty?NativeBridge.get(context).Calls[NativeBridge.get(context).CurrentCallIndex]["PhoneState"] = PhoneStateHolding:null;
            NativeBridge.get(context).Calls.add({
              "PhoneNumber" : NativeBridge.get(context).PhoneNumberQuery,
              "DisplayName" : NativeBridge.get(context).CallerID.isNotEmpty?NativeBridge.get(context).CallerID[0]["CallerID"]:"",
              "Avatar" : null,
              "PhoneState" : PhoneStateDialing,
              "Notes" : NativeBridge.get(context).CallerID.isNotEmpty?NativeBridge.get(context).CallNotes:null,
            });


            NativeBridge.get(context).CurrentCallIndex=NativeBridge.get(context).Calls.length-1;
            NativeBridge.get(context).CallDuration.add(StopWatchTimer(
              mode: StopWatchMode.countUp,
              presetMillisecond: StopWatchTimer.getMilliSecFromMinute(0),
              // millisecond => minute.
              // onChange: (value) => ),
              // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
              // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
            ));


            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) => InCallScreen()),
                  (Route<dynamic>route)=>false,);
          }
          if(state is PhoneStateActive) {
             NativeBridge.get(context).isRinging = false;
             Navigator.pushAndRemoveUntil(context,
               MaterialPageRoute(builder: (BuildContext context) => InCallScreen()),
                   (Route<dynamic>route)=>false,);
          }
          },
      child: BlocBuilder<AppCubit,AppStates>(
        builder:(context,state)=> DefaultTabController(
          length: 2,
          child: BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
            builder:(context,state)=> Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: HomePageBackgroundColor(context),
              extendBodyBehindAppBar: true,
              appBar:MainAppBar(context, AppbarSize , AppCubit.get(context).searchController),
              drawer: AppDrawer(context, AppbarSize),
              drawerDragStartBehavior: DragStartBehavior.start ,
              floatingActionButton: PhoneContactsCubit.get(context).isShowen==false?FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ), onPressed: () {
                  PhoneContactsCubit.get(context).dialpadShowcontact();
                  // print(DialPadBackgroundImagepath(context).toString());
                  },
                child:Image.asset("assets/Images/dialpad.png",scale:1.8 , color: HexColor("#EEEEEE"),),):null,
              body: BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
                builder:(context,state) {
                  return Stack(
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
                      child: PhoneContactsCubit.get(context).isShowen?Dialpad(context, AppbarSize , AppCubit.get(context).dialerController):null),


                ],
              );
            },
        ),
      ),
          ),
    ),
    ),
          );
  }


}
