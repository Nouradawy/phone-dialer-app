
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bg_launcher/bg_launcher.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_states.dart';
import 'package:dialer_app/Modules/Contacts/contacts_screen.dart';
import 'package:dialer_app/NativeBridge/native_bridge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/properties/phone.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    var NativeCubit = NativeBridge.get(context);

    double AppbarSize = MediaQuery.of(context).size.height*Cubit.AppbarSize;
    return BlocListener<NativeBridge,NativeStates>(
        listener: (context,state){
          if(state is PhoneStateRinging )
          {
            NativeCubit.CheckInternetConnection();
            NativeCubit.isRinging = true;
            NativeCubit.InternetisConnected==true?NativeCubit.OnRecivedCallingSession(ProfileCubit.get(context).CurrentUser[0].phone.toString()):null;
            NativeCubit.GetCallerID(PhoneContactsCubit.get(context).Contacts);

            NativeCubit.CallerID.isNotEmpty?NativeCubit.InCallNotes():null;
            NativeCubit.Calls.add({
              "PhoneNumber" : NativeCubit.PhoneNumberQuery,
              "DisplayName" : NativeCubit.CallerID.isNotEmpty?NativeCubit.CallerID[0]["CallerID"]:"",
              "Avatar" : null,
              "PhoneState" : PhoneStateRinging,
              "Notes" : NativeCubit.CallerID.isNotEmpty?NativeCubit.CallNotes:null,
              "CallerAppID" : null,
            });

            NativeCubit.GetContactByID();
            NativeCubit.CurrentCallIndex=NativeCubit.Calls.length-1;
            NativeCubit.CallDuration.add(StopWatchTimer(
              mode: StopWatchMode.countUp,
              presetMillisecond: StopWatchTimer.getMilliSecFromMinute(0),
              // millisecond => minute.
              // onChange: (value) => ),
              // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
              // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
            ));
            BgLauncher.bringAppToForeground();
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) => InCallScreen()),
                  (Route<dynamic>route)=>false,);

          }
          if(state is PhoneStateDialing && NativeCubit.PhoneNumberQuery != null)
          {
            NativeCubit.CheckInternetConnection();
            NativeCubit.OnConference=false;
            // NativeCubit.CreateCallingSession(ProfileCubit.get(context).CurrentUser[0].phone.toString());
            NativeCubit.GetCallerID(PhoneContactsCubit.get(context).Contacts);

            NativeCubit.CallerID.isNotEmpty?NativeCubit.InCallNotes():null;
            NativeCubit.Calls.isNotEmpty?NativeCubit.Calls[NativeCubit.CurrentCallIndex]["PhoneState"] = PhoneStateHolding:null;
            NativeCubit.Calls.add({
              "PhoneNumber" : NativeCubit.PhoneNumberQuery,
              "DisplayName" : NativeCubit.CallerID.isNotEmpty?NativeCubit.CallerID[0]["CallerID"]:"",
              "Avatar" : null,
              "PhoneState" : PhoneStateDialing,
              "Notes" : NativeCubit.CallerID.isNotEmpty?NativeCubit.CallNotes:null,
              "CallerAppID" : null,
            });
            NativeCubit.GetContactByID();
            NativeCubit.CurrentCallIndex=NativeCubit.Calls.length-1;
            NativeCubit.CallDuration.add(StopWatchTimer(
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
             NativeCubit.isRinging = false;
             Navigator.pushAndRemoveUntil(context,
               MaterialPageRoute(builder: (BuildContext context) => InCallScreen()),
                   (Route<dynamic>route)=>false,);
          }
          },
      child: BlocBuilder<AppCubit,AppStates>(
        builder:(context,state)=> DefaultTabController(
          length: 2,
          child: BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
            builder:(context,state) {
              final TabController tabController = DefaultTabController.of(context)!;
              tabController.addListener(() {
                if (!tabController.indexIsChanging) {
                  PhoneContactsCubit.get(context).Daillerinput();
                }
              });
              TextEditingController DisplayName = TextEditingController();
              TextEditingController PhoneNumber = TextEditingController();
              return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: HomePageBackgroundColor(context),
              extendBodyBehindAppBar: true,
              appBar:MainAppBar(context, AppbarSize , AppCubit.get(context).searchController),
              drawer: AppDrawer(context, AppbarSize),
              drawerDragStartBehavior: DragStartBehavior.start ,
              floatingActionButton: PhoneContactsCubit.get(context).isShowen==false?tabController.index==0?FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ), onPressed: () {
                    PhoneContactsCubit.get(context).dialpadShowcontact();

                  },
                child:Image.asset("assets/Images/dialpad.png",scale:1.8 , color: HexColor("#EEEEEE"))):FloatingActionButton.extended(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                onPressed:(){
                  showModalBottomSheet(context: context,
                      shape:const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(17),
                            topLeft: Radius.circular(17)
                        ),
                      ),
                        isScrollControlled: true,
                        builder: (context)
                    {
                      return Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              IconButton(icon: Icon(Icons.cancel),onPressed: (){},),
                              Text("data"),
                              IconButton(icon: Icon(Icons.check),onPressed: () async {
                                final newContact = Contact()
                                  ..name.first = DisplayName.text
                                  ..phones = [Phone(PhoneNumber.text)];
                                await newContact.insert();

                              },),
                            ],),
                          ),
                            TextFormField(
                              controller: DisplayName,
                              decoration: InputDecoration(
                                icon: Icon(Icons.person),
                                suffixIcon: IconButton(onPressed: (){},icon: Icon(Icons.cancel)),
                                labelText: "Name",
                                fillColor: Colors.grey[200],
                                filled: true,
                              ),
                            ),
                            TextFormField(
                              controller: PhoneNumber,
                              decoration: InputDecoration(
                                icon: Icon(Icons.phone),
                                suffixIcon: IconButton(onPressed: (){},icon: Icon(Icons.cancel)),
                                labelText: "Number",
                                fillColor: Colors.grey[200],
                                filled: true,
                              ),
                            ),

                        ],),
                      );
                    }
                    );
              },
                label: Text("New Contact"),
                icon:Icon(Icons.add),
              ):null,
              body: BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
                builder:(context,state) {
                  return Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      TabBarView(
                        controller: tabController,
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
                      child: PhoneContactsCubit.get(context).isShowen?MediaQuery(
                          data:MediaQuery.of(context).copyWith(textScaleFactor: 1),
                          child: Dialpad(context, AppbarSize , AppCubit.get(context).dialerController)):null),



                ],
              );
            },
        ),
      );
            },
          ),
    ),
    ),
          );
  }


}
