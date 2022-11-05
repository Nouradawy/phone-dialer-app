
import 'dart:convert';

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
import 'package:flutter_contacts/properties/account.dart';
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
import 'Modules/Contacts/edit_contact.dart';
import 'Modules/Phone/Cubit/cubit.dart';
import 'Modules/Phone/phone_Log_screen.dart';
import 'Layout/Cubit/cubit.dart';
import 'Layout/Cubit/states.dart';
import 'Modules/profile/Profile Cubit/profile_cubit.dart';
import 'NativeBridge/native_states.dart';
import 'Network/Local/cache_helper.dart';
import 'Network/Local/shared_data.dart';
import 'Notifications/notifications.dart';
import 'Themes/theme_config.dart';
import 'main.dart';


class Home extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    var Cubit = AppCubit.get(context);
    var NativeCubit = NativeBridge.get(context);
    var PhoneCubit = PhoneContactsCubit.get(context);

    double AppbarSize = MediaQuery.of(context).size.height*Cubit.AppbarSize;
    return BlocListener<NativeBridge,NativeStates>(
        listener: (context,state){

          if(state is PhoneStateRinging )
          {

            NativeCubit.CheckInternetConnection();
            NativeCubit.isRinging = true;
            // NativeCubit.InternetisConnected==true?NativeCubit.OnRecivedCallingSession(ProfileCubit.get(context).CurrentUser[0].phone.toString()):null;
            NativeCubit.GetCallerID(PhoneContactsCubit.get(context).Contacts);


            NativeCubit.Calls.add({
              "PhoneNumber" : NativeCubit.PhoneNumberQuery,
              "DisplayName" : NativeCubit.CallerID.isNotEmpty?NativeCubit.CallerID[0]["CallerID"]:"",
              "Avatar" : null,
              "PhoneState" : "Ringing",
              "CallerAppID" : null,
            });

            NativeCubit.GetContactByID();
            NativeCubit.CurrentCallIndex=NativeCubit.Calls.length-1;

            CreateCallNotification(NativeCubit.Calls[NativeCubit.CurrentCallIndex]["DisplayName"]!=null?NativeCubit.Calls[NativeCubit.CurrentCallIndex]["DisplayName"].toString().toUpperCase():"Unkown",NativeCubit.PhoneNumberQuery);
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


            NativeCubit.Calls.isNotEmpty?NativeCubit.Calls[NativeCubit.CurrentCallIndex]["PhoneState"] = "OnHold":null;
            NativeCubit.Calls.add({
              "PhoneNumber" : NativeCubit.PhoneNumberQuery,
              "DisplayName" : NativeCubit.CallerID.isNotEmpty?NativeCubit.CallerID[0]["CallerID"]:"",
              "Avatar" : null,
              "PhoneState" : "Calling",
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
              return GestureDetector(
                onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: HomePageBackgroundColor(context),
                extendBodyBehindAppBar: true,
                appBar:MainAppBar(context, AppbarSize , AppCubit.get(context).searchController),
                drawer: AppDrawer(context, AppbarSize),
                drawerDragStartBehavior: DragStartBehavior.start ,
                floatingActionButton: BottomSheet (context, tabController , DisplayName ,PhoneNumber , PhoneCubit ),
                body: BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
                  builder:(context,state) {
                    return Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        TabBarView(
                          controller: tabController,
                          children:<Widget> [
                            PhoneLogScreen(),
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
                        Material(
                        color: HexColor("#F9F9F9"),
                        borderRadius: const BorderRadiusDirectional.only(
                          topStart: Radius.circular(30),
                          topEnd: Radius.circular(30),
                        ),
                        elevation: 10,
                        child: PhoneContactsCubit.get(context).BlockWarning==true?MediaQuery(
                            data:MediaQuery.of(context).copyWith(textScaleFactor: 1),
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height*0.23,
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*0.80,
                                      child: Text("you will not receive calls from this contact after adding it to the blocklist",textAlign: TextAlign.center,)),
                                ),
                                defaultButton(
                                    onPressed: (){
                                      int? Index = PhoneLogsCubit.get(context).CurrentBLockIndex;
                                      BlockList.add(PhoneLogsCubit.get(context).PhoneCallLogs[Index!]["number"].toString());
                                      CacheHelper.saveData(key: "BlackList", value: json.encode(BlockList));
                                      NativeBridge.get(context).invokeNativeMethod("BlackListUpdate", BlockList);
                                      PhoneContactsCubit.get(context).BlockWarning=!PhoneContactsCubit.get(context).BlockWarning;
                                      PhoneContactsCubit.get(context).Daillerinput();
                                    },
                                  width: 150,
                                    Title: "Add to bloclist",
                                    titleColor:Colors.red,
                                ),
                                Divider(),
                                defaultButton(
                                    onPressed: (){
                                      PhoneContactsCubit.get(context).BlockWarning=!PhoneContactsCubit.get(context).BlockWarning;
                                      PhoneContactsCubit.get(context).Daillerinput();
                                    },
                                  width: 150,
                                    Title: "Cancel",
                                  titleColor:Colors.black,

                                ),
                              ],),
                            )):null),



                  ],
                );
            },
        ),
      ),
              );
            },
          ),
    ),
    ),
          );
  }


}

Widget BottomSheet (context, tabController , DisplayName ,PhoneNumber ,PhoneCubit){

  if(PhoneContactsCubit.get(context).isShowen==false)
    {
      if(tabController.index==0 &&PhoneContactsCubit.get(context).BlockWarning==false )
        {
           return FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ), onPressed: () {
            PhoneContactsCubit.get(context).dialpadShowcontact();

          },
              child:Image.asset("assets/Images/dialpad.png",scale:1.8 , color: HexColor("#EEEEEE")));
        } else {
        if(tabController.index ==1) {
          TextEditingController DisplayName = TextEditingController();
          TextEditingController PrefixName = TextEditingController();
          TextEditingController SufixName = TextEditingController();
          TextEditingController FirstName = TextEditingController();
          TextEditingController LastName = TextEditingController();
          TextEditingController MiddleName = TextEditingController();
          TextEditingController PhoneticName = TextEditingController();
          TextEditingController PhoneticFirstName = TextEditingController();
          TextEditingController PhoneticLastName = TextEditingController();
          TextEditingController PhoneticMiddleName = TextEditingController();
          TextEditingController NickName = TextEditingController();
        return FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () {
            PhoneContactsCubit.get(context).PhoneNumberController.add(TextEditingController());
            PhoneContactsCubit.get(context).PhoneSideMenuController.add(PhoneLabel.mobile);
            int count=0;
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(17),
                      topLeft: Radius.circular(17)),
                ),
                isScrollControlled: true,
                builder: (context) {
                  return BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
                    builder: (context,states) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);

                                    }, child: Text("Cancel"),
                                  ),
                                  Text("New Contact"),
                                  TextButton(
                                    child:Text("Done") ,
                                    onPressed: () async {
                                      final newContact = Contact()
                                        ..name.first = DisplayName.text
                                        ..phones = [Phone(PhoneNumber.text)]
                                        ..accounts = [Account(PhoneCubit.DefaultPhoneAccounts[PhoneCubit.DefaultPhoneAccountIndex]["rawId"],PhoneCubit.DefaultPhoneAccounts[PhoneCubit.DefaultPhoneAccountIndex]["AccountType"],PhoneCubit.DefaultPhoneAccounts[PhoneCubit.DefaultPhoneAccountIndex]["AccountName"],PhoneCubit.DefaultPhoneAccounts[PhoneCubit.DefaultPhoneAccountIndex]["mimetypes"])];
                                      await newContact.insert();
                                    },
                                  ),
                                ],
                              ),
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(radius: 56,),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        PhoneContactsCubit.get(context).AccountIcon(PhoneContactsCubit.get(context).DefaultPhoneAccounts[PhoneContactsCubit.get(context).DefaultPhoneAccountIndex]["AccountType"]),
                                        Padding(
                                          padding: const EdgeInsets.only(left:8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // SizedBox(height: 4,),
                                              PhoneContactsCubit.get(context).AccountTitle(PhoneContactsCubit.get(context).DefaultPhoneAccounts[PhoneContactsCubit.get(context).DefaultPhoneAccountIndex]["AccountType"]),
                                              SizedBox(
                                                width: 100,
                                                child: Text("${PhoneContactsCubit.get(context).DefaultPhoneAccounts[PhoneContactsCubit.get(context).DefaultPhoneAccountIndex]["AccountName"]}",overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.52,
                                      child: TextFormField(
                                        style: ContactFormMainTextStyle(),
                                        controller: NickName,
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
                              ],
                            ),
                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width*0.90,
                                    child: ContactFormField(context,
                                        null,
                                        PhoneContactsCubit.get(context).DNtoggler == true?PrefixName:DisplayName,
                                        Icon(Icons.person,color: ContactFormIconColor(),),PhoneContactsCubit.get(context).DNtoggler == true?"Prefix":"Display name",true)),
                                Padding(
                                  padding: const EdgeInsets.only(right:8.0,left:10),
                                  child: IconButton(
                                    splashRadius: 15,
                                    constraints: const BoxConstraints(
                                      maxWidth: 10,
                                    ),
                                    padding:EdgeInsets.zero,onPressed: (){
                                    PhoneContactsCubit.get(context).DisplayNameToggle();
                                  }, icon: PhoneContactsCubit.get(context).DNtoggler == true?Transform.translate(
                                      offset: Offset(-7,0),
                                      child: Icon(Icons.arrow_drop_up)):
                                  Transform.translate(
                                      offset: Offset(-8,0),
                                      child: Icon(Icons.arrow_drop_down)),
                                  ),
                                )
                              ],
                            ),
                            PhoneContactsCubit.get(context).DNtoggler==true?
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ContactFormField(context,null,
                                        FirstName,null,"First name",false),
                                    ContactFormField(context,null,
                                        MiddleName,null,"Middle name",false),
                                    ContactFormField(context,null,
                                        LastName,null,"Last name",false),
                                    ContactFormField(context,null,
                                        SufixName,null,"Suffix",false),
                                  ]),
                            ):Container(),
                            SizedBox(
                              height: (PhoneContactsCubit.get(context).PhoneNumberController.length)*71,
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: PhoneContactsCubit.get(context).PhoneNumberController.length,
                                  itemBuilder: (context,index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PhoneTextForm(index,context,null),
                                    );
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 13.0,vertical: 4),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: TextButton(
                                    onPressed: (){},
                                    child: Text("Add more info",style: TextStyle(fontSize: 13),)
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  );
                }).whenComplete(() {
              PhoneContactsCubit.get(context).PhoneNumberController.clear();
              PhoneContactsCubit.get(context).PhoneSideMenuController.clear();
            });
          },
          label: Text(
            "Add Contact",
            style: TextStyle(
                fontFamily: "cairo", fontSize: 11, fontWeight: FontWeight.w600),
          ),
          icon: Icon(Icons.add),
        );
      } else return Text("");
    }
    }  else return Text("");
}