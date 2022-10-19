
import 'dart:convert';

import 'package:call_log/call_log.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:dialer_app/Components/contacts_components.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/Modules/Contacts/contacts_screen.dart';
import 'package:dialer_app/Network/Local/cache_helper.dart';
import 'package:dialer_app/Themes/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/components.dart';
import '../../Layout/incall_screen.dart';
import '../../NativeBridge/native_bridge.dart';
import '../../Network/Local/shared_data.dart';
import '../../Themes/Cubit/cubit.dart';
import '../../Themes/Cubit/states.dart';
import 'Cubit/cubit.dart';
import 'Cubit/state.dart';

var _tapPosition;
class PhoneLogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    if(PhoneLogsCubit.get(context).PhoneRange == true){

      Future.delayed(Duration(milliseconds: 500),(){
        NativeBridge.get(context).CallDuration=[];
        NativeBridge.get(context).Calls=[];
        NativeBridge.get(context).ConferenceCalls=[];
        PhoneLogsCubit.get(context).CallLogsUpdate(PhoneContactsCubit.get(context).Contacts);

      });
      Future.delayed(Duration(seconds: 1),(){
        PhoneContactsCubit.get(context).Daillerinput();

      });

    }
    return  PhoneContactsCubit.get(context).isSearching!=true?
    SafeArea(
            child: DefaultTabController(
              length: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: Offset(10, -0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      // height: 50,
                      child: TabBar(
                        physics: NeverScrollableScrollPhysics(),
                        isScrollable: true,
                        labelStyle: TextStyle(fontSize: 10),
                        labelColor: Colors.black,
                        indicatorColor: HexColor("#F07F5C"),
                        unselectedLabelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: const [
                                Icon(Icons.apps, size: 19),
                                SizedBox(width: 2),
                                Text("All")
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(children: const [
                              Icon(Icons.call_missed_outgoing, size: 19),
                              SizedBox(width: 2),
                              Text(
                                "Missed",
                                textScaleFactor: 1,
                              )
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(children: const [
                              Icon(Icons.call_received, size: 19),
                              SizedBox(width: 2),
                              Text(
                                "Recived",
                                textScaleFactor: 1,
                              )
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(children: const [
                              Icon(Icons.call_made, size: 19),
                              SizedBox(width: 2),
                              Text(
                                "Made",
                                textScaleFactor: 1,
                              )
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(children: const [
                              Icon(Icons.block, size: 19),
                              SizedBox(width: 2),
                              Text(
                                "Blacklist",
                                textScaleFactor: 1,
                              )
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ConditionalBuilder(
                            builder: (context) => ListView.builder(
                              itemCount: PhoneLogsCubit.get(context).PhoneCallLogs.length,
                              itemBuilder: (context, index) {

                                return GestureDetector(
                                    onTapDown: (value) {
                                      _tapPosition = value.globalPosition;
                                    },
                                    child: AllPhoneLogs(index, context));
                              },
                            ),
                            condition: PhoneLogsCubit.get(context)
                                .PhoneCallLogs
                                .isNotEmpty,
                            fallback: (context) {
                              return ListView.builder(
                                itemCount: 10,
                                itemBuilder: (context, index) => ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  title: Row(
                                    children: [
                                      Shimmer.fromColors(
                                          baseColor: Colors.grey[500]!,
                                          highlightColor: Colors.grey[300]!,
                                          period: const Duration(seconds: 2),
                                          child: Container(
                                              width: 90,
                                              height: 13,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Shimmer.fromColors(
                                          baseColor: Colors.grey[500]!,
                                          highlightColor: Colors.grey[300]!,
                                          period: const Duration(seconds: 2),
                                          child: Container(
                                              width: 130,
                                              height: 13,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  leading: Shimmer.fromColors(
                                      baseColor: Colors.grey[500]!,
                                      highlightColor: Colors.grey[300]!,
                                      period: Duration(seconds: 2),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                      )),
                                  trailing: Container(
                                    width: 30,
                                    height: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                          ConditionalBuilder(
                            builder: (context) => ListView.builder(
                              itemCount: PhoneLogsCubit.get(context)
                                  .PhoneCallMissed
                                  .length,
                              itemBuilder: (context, index) {

                                return MissedPhoneLogs(index, context);
                              },
                            ),
                            condition: PhoneLogsCubit.get(context)
                                .PhoneCallMissed
                                .isNotEmpty,
                            fallback: (context) {
                              return ListView.builder(
                                itemCount: 10,
                                itemBuilder: (context, index) => ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  title: Row(
                                    children: [
                                      Shimmer.fromColors(
                                          baseColor: Colors.grey[500]!,
                                          highlightColor: Colors.grey[300]!,
                                          period: Duration(seconds: 2),
                                          child: Container(
                                              width: 90,
                                              height: 13,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Shimmer.fromColors(
                                          baseColor: Colors.grey[500]!,
                                          highlightColor: Colors.grey[300]!,
                                          period: Duration(seconds: 2),
                                          child: Container(
                                              width: 130,
                                              height: 13,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  leading: Shimmer.fromColors(
                                      baseColor: Colors.grey[500]!,
                                      highlightColor: Colors.grey[300]!,
                                      period: Duration(seconds: 2),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                      )),
                                  trailing: Container(
                                    width: 30,
                                    height: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                          ConditionalBuilder(
                            builder: (context) => ListView.builder(
                              itemCount: PhoneLogsCubit.get(context)
                                  .PhoneCallInBound
                                  .length,
                              itemBuilder: (context, index) {

                                return InBoundPhoneLogs(index, context);
                              },
                            ),
                            condition: PhoneLogsCubit.get(context)
                                .PhoneCallInBound
                                .isNotEmpty,
                            fallback: (context) {
                              return ListView.builder(
                                itemCount: 10,
                                itemBuilder: (context, index) => ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  title: Row(
                                    children: [
                                      Shimmer.fromColors(
                                          baseColor: Colors.grey[500]!,
                                          highlightColor: Colors.grey[300]!,
                                          period: Duration(seconds: 2),
                                          child: Container(
                                              width: 90,
                                              height: 13,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Shimmer.fromColors(
                                          baseColor: Colors.grey[500]!,
                                          highlightColor: Colors.grey[300]!,
                                          period: Duration(seconds: 2),
                                          child: Container(
                                              width: 130,
                                              height: 13,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  leading: Shimmer.fromColors(
                                      baseColor: Colors.grey[500]!,
                                      highlightColor: Colors.grey[300]!,
                                      period: Duration(seconds: 2),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                      )),
                                  trailing: Container(
                                    width: 30,
                                    height: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                          ConditionalBuilder(
                            builder: (context) => ListView.builder(
                              itemCount: PhoneLogsCubit.get(context)
                                  .PhoneCallOutBound
                                  .length,
                              itemBuilder: (context, index) {
                                return OutBoundPhoneLogs(index, context);
                              },
                            ),
                            condition: PhoneLogsCubit.get(context)
                                .PhoneCallOutBound
                                .isNotEmpty,
                            fallback: (context) {
                              return ListView.builder(
                                itemCount: 10,
                                itemBuilder: (context, index) => ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  title: Row(
                                    children: [
                                      Shimmer.fromColors(
                                          baseColor: Colors.grey[500]!,
                                          highlightColor: Colors.grey[300]!,
                                          period: Duration(seconds: 2),
                                          child: Container(
                                              width: 90,
                                              height: 13,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Shimmer.fromColors(
                                          baseColor: Colors.grey[500]!,
                                          highlightColor: Colors.grey[300]!,
                                          period: Duration(seconds: 2),
                                          child: Container(
                                              width: 130,
                                              height: 13,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  leading: Shimmer.fromColors(
                                      baseColor: Colors.grey[500]!,
                                      highlightColor: Colors.grey[300]!,
                                      period: Duration(seconds: 2),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                      )),
                                  trailing: Container(
                                    width: 30,
                                    height: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                          ConditionalBuilder(
                            builder: (context) => ListView.builder(
                              itemCount: BlockList.length,
                              itemBuilder: (context, index) {
                                return BlackListPhone(index, context);
                              },
                            ),
                            condition: BlockList.isNotEmpty,
                            fallback: (context) {
                              return Text("No Numbers");
                            },
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          )
        :
    ListView.builder(
    itemCount:   PhoneContactsCubit.get(context).FilterdContacts.length,
    itemBuilder: (context, index) {
    AppContact contact = PhoneContactsCubit.get(context).FilterdContacts[index];
    return Column(
    children: [
    SearchingList(context, contact),
    ],
    );}

    );








  }




  ListTile AllPhoneLogs( int index, BuildContext context) {
    return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    onLongPress: (){
                      PhoneLogsCubit.get(context).CurrentBLockIndex=index;
                      print("$index : ${PhoneLogsCubit.get(context).PhoneCallLogs[index]["number"].toString()}");
                      PhoneLogsCubit.get(context).AddToBlackList=true;
                      BlockList.forEach((element) {
                        if(element == PhoneLogsCubit.get(context).PhoneCallLogs[index]["number"].toString())
                        {
                          PhoneLogsCubit.get(context).AddToBlackList=false;
                        }
                      });
                      print("$index : ${PhoneLogsCubit.get(context).PhoneCallLogs[index]["number"].toString()} : ${PhoneLogsCubit.get(context).AddToBlackList}");
                      PhoneContactsCubit.get(context).Daillerinput();
                      showMenu(context: context,
                        items: [
                          PopupMenuItem(
                              onTap: (){
                                Clipboard.setData(ClipboardData(text: PhoneLogsCubit.get(context).PhoneCallLogs[index]["number"].toString()));
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.copy),
                                  SizedBox(width: 15),
                                  Text("Copy number"),
                            ],
                          )),
                          PopupMenuItem(child: Row(
                            children: const [
                              Icon(Icons.sms),
                              SizedBox(width: 15),
                              Text("send SMS"),
                            ],
                          )),
                          PopupMenuItem(child: Row(
                            children: const [
                              Icon(Icons.edit),
                              SizedBox(width: 15),
                              Text("Edit before Calling"),
                            ],
                          )),
                          PopupMenuItem(
                              onTap: (){

                                if(PhoneLogsCubit.get(context).AddToBlackList==true) {
                                  PhoneContactsCubit.get(context).BlockWarning = !PhoneContactsCubit.get(context).BlockWarning;
                                }
                                else
                                  {
                                    BlockList.removeWhere((element) => element == PhoneLogsCubit.get(context).PhoneCallLogs[index]["number"].toString());
                                    CacheHelper.saveData(key: "BlackList", value: json.encode(BlockList));
                                    NativeBridge.get(context).invokeNativeMethod("BlackListUpdate", BlockList);
                                  }
                                PhoneContactsCubit.get(context).Daillerinput();
                              },
                              child: Row(
                            children:  [
                              Icon(Icons.block),
                              SizedBox(width: 15),
                              Text(PhoneLogsCubit.get(context).AddToBlackList==true?"Add to BlockList":"Remove from BlackList"),
                            ],
                          )),

                        ],
                          position: RelativeRect.fromLTRB(
                            _tapPosition.dx,
                            _tapPosition.dy,
                            MediaQuery.of(context).size.width - _tapPosition.dx,
                            MediaQuery.of(context).size.height - _tapPosition.dx,

                          ),

                      );
                    },
                    onTap: () {
                      ThemeCubit.get(context).ThemeEditorIsActive == true?
                      NDialog(
                        content:BlocBuilder<ThemeCubit,ThemeStates>(
                            builder:(context,states)=> ThemeCubit.get(context).PhoneLogColorPicker()),
                        dialogStyle: DialogStyle(
                          elevation: 10,
                        ),
                      ).show(context , barrierColor: Colors.black.withOpacity(0.20))
                          :NativeBridge.get(context).PhoneNumberQuery =" ${PhoneLogsCubit.get(context).PhoneCallLogs[index]["number"].toString()}";
                      NativeBridge.get(context).GetCallerID(PhoneContactsCubit.get(context).Contacts);

                      NativeBridge.get(context).CallerID.isNotEmpty?Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ContactDetails(
                            NativeBridge.get(context).CallerID[0]["Contact"],
                            onContactDelete: (AppContact _contact) {
                              PhoneContactsCubit.get(context).GetRawContacts();
                              Navigator.of(context).pop();
                            },
                            onContactUpdate: (AppContact _contact) {
                              PhoneContactsCubit.get(context).GetRawContacts();
                            },)
                      )):null;
                    },
                    title: Transform.translate(
                      offset: Offset(-5,0),
                      child: Text(
                        PhoneLogsCubit.get(context).PhoneCallLogs[index]["name"].toString(),textScaleFactor: MediaQuery.of(context).textScaleFactor>1.2?1.2:MediaQuery.of(context).textScaleFactor,
                        style:  TextStyle(
                          fontFamily: "Cairo",
                          fontSize: 15,
                          height: 1,
                          color:PhoneLogDiallerNameColor(context),
                        ),
                      ),
                    ),
                    subtitle: Transform.translate(
                      offset:Offset(-5,0),
                      //TODO: Let the user at the initialization Screen Specify SIM1 & SIM2
                      child: Row(
                        children: [
                      Image.asset(PhoneLogsCubit.get(context).PhoneCallLogs.first["phoneAccountId"] == PhoneLogsCubit.get(context).PhoneCallLogs[index]["phoneAccountId"]?"assets/Images/sim1.png" :"assets/Images/sim2.png",scale: 1.3),
                          Text(
                            " ${PhoneLogsCubit.get(context).PhoneCallLogs[index]["number"].toString()}",
                              textScaleFactor: MediaQuery.of(context).textScaleFactor>1.2?1.2:MediaQuery.of(context).textScaleFactor,
                            style:  TextStyle(
                              fontSize: 12,
                              fontFamily: "Cairo",
                              color:PhoneLogPhoneNumberColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    leading: PhoneLogsCubit.get(context).BaseColors[index] !=null?LoggertAvatar(52, PhoneLogsCubit.get(context).PhoneCallLogs[index]["name"].toString(), PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"], PhoneLogsCubit.get(context).BaseColors[index]):Text(""),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: logDetailsStanderd(context, index),
                    ),
                  );
  }

  Column logDetailsModern(BuildContext context, int index) {
    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width*0.40,
                            ),
                            child:Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.40,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color:CallLogDetailsBackStrip(),
                                    //ToDo:Add Color Function here
                                    borderRadius: BorderRadius.circular(3)
                                  ),

                                ),
                                Transform.translate(
                                  offset: Offset(5,2),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.15,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color:CallLogDetailsleftContainer(),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(4),
                                          )
                                        ),
                                        child:Center(
                                          child: Text(calculateDifference(PhoneLogsCubit.get(context).PhoneCallLogs[index]["Date"]),style: TextStyle(
                                            fontFamily: "cairo",
                                            fontSize: 10,

                                          ),),
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.15,
                                        child:Column(
                                          children: [
                                            // Text("3",style: TextStyle(
                                            //   height: 1,
                                            // ),),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text("calls",style: TextStyle(
                                                  // height: 1,
                                                ),),
                                                CalltypeIcon(PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                                Transform.translate(
                                  offset: Offset(MediaQuery.of(context).size.width*0.162,2),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*0.225,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color:CallLogDetailsRightContainer(),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(4),
                                      )
                                    ),
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(height: 5),
                                        Padding(
                                          padding: const EdgeInsets.only(right:8.0),
                                          child: Text(DateFormat.jm().format(PhoneLogsCubit.get(context).PhoneCallLogs[index]["Date"]).toString(),style: CallTimeTextStyle(),),
                                        ),
                                        Align(
                                          alignment: PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"]==CallType.incoming||PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"]==CallType.outgoing?AlignmentDirectional.center:AlignmentDirectional.centerEnd,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"]==CallType.incoming||PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"]==CallType.outgoing?0:8,),
                                            child: Text("${PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"].toString().replaceAll("CallType.", "")}  ${DurationFormat(PhoneLogsCubit.get(context).PhoneCallLogs[index]["duration"], PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"]).toString()}", style: PhoneTypeTextStyle(),),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),

                      ],
                    );
  }


  Column logDetailsStanderd(BuildContext context, int index) {
    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width*0.40,
                            ),
                            child:Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.40,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    //ToDo:Add Color Function here
                                    borderRadius: BorderRadius.circular(3)
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(25,2),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.15,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(4),
                                          )
                                        ),
                                        child:Center(
                                          child: Text(calculateDifference(PhoneLogsCubit.get(context).PhoneCallLogs[index]["Date"]),textScaleFactor: 1,style: PhoneLogDateTextStyle(),),
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                                Transform.translate(
                                  offset: Offset(MediaQuery.of(context).size.width*0.162,2),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*0.225,
                                    height: 55,
                                    decoration: BoxDecoration(

                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(4),
                                      )
                                    ),
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(height: 5),
                                        Padding(
                                          padding: const EdgeInsets.only(right:8.0),
                                          child: Text(DateFormat.jm().format(PhoneLogsCubit.get(context).PhoneCallLogs[index]["Date"]).toString(),textScaleFactor: MediaQuery.of(context).textScaleFactor>1.05?1.05:MediaQuery.of(context).textScaleFactor,style: CallTimeTextStyle(),),
                                        ),
                                        Align(
                                          alignment: PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"]==CallType.incoming||PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"]==CallType.outgoing?AlignmentDirectional.center:AlignmentDirectional.centerEnd,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"]==CallType.incoming||PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"]==CallType.outgoing?0:8,),
                                            child: Text("${PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"].toString().replaceAll("CallType.", "")}  ${DurationFormat(PhoneLogsCubit.get(context).PhoneCallLogs[index]["duration"], PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"]).toString()}",textScaleFactor: MediaQuery.of(context).textScaleFactor>1.05?1.05:MediaQuery.of(context).textScaleFactor, style: PhoneTypeTextStyle(),),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),

                      ],
                    );
  }

  ListTile MissedPhoneLogs( int index, BuildContext context) {
    return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    onTap: () {},
                    title: Transform.translate(
                      offset: Offset(-5,0),
                      child: Text(
                        PhoneLogsCubit.get(context).PhoneCallMissed[index]["name"].toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    subtitle: Transform.translate(
                      offset:Offset(-5,0),
                      //TODO: Let the user at the initialization Screen Specify SIM1 & SIM2
                      child: Row(
                        children: [
                      Image.asset(PhoneLogsCubit.get(context).PhoneCallMissed.first["phoneAccountId"] == PhoneLogsCubit.get(context).PhoneCallMissed[index]["phoneAccountId"]?"assets/Images/sim1.png" :"assets/Images/sim2.png",scale: 1.3),
                          Text(
                            " ${PhoneLogsCubit.get(context).PhoneCallMissed[index]["number"].toString()}",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
      // //TODO:Something Retarining null at loggerAvatar(Only affected by Android 32)
                    leading: PhoneLogsCubit.get(context).BaseColors[index] !=null?LoggertAvatar(52, PhoneLogsCubit.get(context).PhoneCallMissed[index]["name"].toString(), PhoneLogsCubit.get(context).PhoneCallMissed[index]["callType"], PhoneLogsCubit.get(context).BaseColors[index]):Text(""),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width*0.40,
                              ),
                              child:Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.40,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color:CallLogDetailsBackStrip(),
                                      borderRadius: BorderRadius.circular(3)
                                    ),

                                  ),
                                  Transform.translate(
                                    offset: Offset(5,2),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.15,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color:CallLogDetailsleftContainer(),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(4),
                                            )
                                          ),
                                          child:Center(
                                            child: Text(calculateDifference(PhoneLogsCubit.get(context).PhoneCallMissed[index]["Date"]),style: TextStyle(
                                              fontFamily: "cairo",
                                              fontSize: 10,

                                            ),),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.15,
                                          child:Column(
                                            children: [
                                              // Text("3",style: TextStyle(
                                              //   height: 1,
                                              // ),),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text("calls",style: TextStyle(
                                                    // height: 1,
                                                  ),),
                                                  CalltypeIcon(PhoneLogsCubit.get(context).PhoneCallMissed[index]["callType"]),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                  Transform.translate(
                                    offset: Offset(MediaQuery.of(context).size.width*0.162,2),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*0.225,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color:CallLogDetailsRightContainer(),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(4),
                                        )
                                      ),
                                      child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(height: 5),
                                          Padding(
                                            padding: const EdgeInsets.only(right:8.0),
                                            child: Text(DateFormat.jm().format(PhoneLogsCubit.get(context).PhoneCallMissed[index]["Date"]).toString(),style: CallTimeTextStyle(),),
                                          ),
                                          Align(
                                            alignment: PhoneLogsCubit.get(context).PhoneCallMissed[index]["callType"]==CallType.incoming||PhoneLogsCubit.get(context).PhoneCallMissed[index]["callType"]==CallType.outgoing?AlignmentDirectional.center:AlignmentDirectional.centerEnd,
                                            child: Padding(
                                              padding: EdgeInsets.only(right: PhoneLogsCubit.get(context).PhoneCallMissed[index]["callType"]==CallType.incoming||PhoneLogsCubit.get(context).PhoneCallMissed[index]["callType"]==CallType.outgoing?0:8,),
                                              child: Text("${PhoneLogsCubit.get(context).PhoneCallMissed[index]["callType"].toString().replaceAll("CallType.", "")}  ${DurationFormat(PhoneLogsCubit.get(context).PhoneCallMissed[index]["duration"], PhoneLogsCubit.get(context).PhoneCallMissed[index]["callType"]).toString()}", style: PhoneTypeTextStyle(),),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),

                        ],
                      ),
                    ),
                  );
  }

  ListTile InBoundPhoneLogs( int index, BuildContext context) {
    return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    onTap: () {},
                    title: Transform.translate(
                      offset: Offset(-5,0),
                      child: Text(
                        PhoneLogsCubit.get(context).PhoneCallInBound[index]["name"].toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    subtitle: Transform.translate(
                      offset:Offset(-5,0),
                      //TODO: Let the user at the initialization Screen Specify SIM1 & SIM2
                      child: Row(
                        children: [
                      Image.asset(PhoneLogsCubit.get(context).PhoneCallInBound.first["phoneAccountId"] == PhoneLogsCubit.get(context).PhoneCallInBound[index]["phoneAccountId"]?"assets/Images/sim1.png" :"assets/Images/sim2.png",scale: 1.3),
                          Text(
                            " ${PhoneLogsCubit.get(context).PhoneCallInBound[index]["number"].toString()}",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
      // //TODO:Something Retarining null at loggerAvatar(Only affected by Android 32)
                    leading: PhoneLogsCubit.get(context).BaseColors[index] !=null?LoggertAvatar(52, PhoneLogsCubit.get(context).PhoneCallInBound[index]["name"].toString(), PhoneLogsCubit.get(context).PhoneCallInBound[index]["callType"], PhoneLogsCubit.get(context).BaseColors[index]):Text(""),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width*0.40,
                              ),
                              child:Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.40,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color:CallLogDetailsBackStrip(),
                                      borderRadius: BorderRadius.circular(3)
                                    ),

                                  ),
                                  Transform.translate(
                                    offset: Offset(5,2),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.15,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color:CallLogDetailsleftContainer(),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(4),
                                            )
                                          ),
                                          child:Center(
                                            child: Text(calculateDifference(PhoneLogsCubit.get(context).PhoneCallInBound[index]["Date"]),style: TextStyle(
                                              fontFamily: "cairo",
                                              fontSize: 10,

                                            ),),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.15,
                                          child:Column(
                                            children: [
                                              // Text("3",style: TextStyle(
                                              //   height: 1,
                                              // ),),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text("calls",style: TextStyle(
                                                    // height: 1,
                                                  ),),
                                                  CalltypeIcon(PhoneLogsCubit.get(context).PhoneCallInBound[index]["callType"]),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                  Transform.translate(
                                    offset: Offset(MediaQuery.of(context).size.width*0.162,2),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*0.225,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color:CallLogDetailsRightContainer(),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(4),
                                        )
                                      ),
                                      child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(height: 5),
                                          Padding(
                                            padding: const EdgeInsets.only(right:8.0),
                                            child: Text(DateFormat.jm().format(PhoneLogsCubit.get(context).PhoneCallInBound[index]["Date"]).toString(),style: CallTimeTextStyle(),),
                                          ),
                                          Align(
                                            alignment: PhoneLogsCubit.get(context).PhoneCallInBound[index]["callType"]==CallType.incoming||PhoneLogsCubit.get(context).PhoneCallInBound[index]["callType"]==CallType.outgoing?AlignmentDirectional.center:AlignmentDirectional.centerEnd,
                                            child: Padding(
                                              padding: EdgeInsets.only(right: PhoneLogsCubit.get(context).PhoneCallInBound[index]["callType"]==CallType.incoming||PhoneLogsCubit.get(context).PhoneCallInBound[index]["callType"]==CallType.outgoing?0:8,),
                                              child: Text("${PhoneLogsCubit.get(context).PhoneCallInBound[index]["callType"].toString().replaceAll("CallType.", "")}  ${DurationFormat(PhoneLogsCubit.get(context).PhoneCallInBound[index]["duration"], PhoneLogsCubit.get(context).PhoneCallInBound[index]["callType"]).toString()}", style: PhoneTypeTextStyle(),),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),

                        ],
                      ),
                    ),
                  );
  }

  ListTile OutBoundPhoneLogs( int index, BuildContext context) {
    return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    onTap: () {},
                    title: Transform.translate(
                      offset: Offset(-5,0),
                      child: Text(
                        PhoneLogsCubit.get(context).PhoneCallOutBound[index]["name"].toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    subtitle: Transform.translate(
                      offset:Offset(-5,0),
                      //TODO: Let the user at the initialization Screen Specify SIM1 & SIM2
                      child: Row(
                        children: [
                      Image.asset(PhoneLogsCubit.get(context).PhoneCallOutBound.first["phoneAccountId"] == PhoneLogsCubit.get(context).PhoneCallOutBound[index]["phoneAccountId"]?"assets/Images/sim1.png" :"assets/Images/sim2.png",scale: 1.3),
                          Text(
                            " ${PhoneLogsCubit.get(context).PhoneCallOutBound[index]["number"].toString()}",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
      // //TODO:Something Retarining null at loggerAvatar(Only affected by Android 32)
                    leading: PhoneLogsCubit.get(context).BaseColors[index] !=null?LoggertAvatar(52, PhoneLogsCubit.get(context).PhoneCallOutBound[index]["name"].toString(), PhoneLogsCubit.get(context).PhoneCallOutBound[index]["callType"], PhoneLogsCubit.get(context).BaseColors[index]):Text(""),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width*0.40,
                              ),
                              child:Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.40,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color:CallLogDetailsBackStrip(),
                                      borderRadius: BorderRadius.circular(3)
                                    ),

                                  ),
                                  Transform.translate(
                                    offset: Offset(5,2),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.15,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color:CallLogDetailsleftContainer(),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(4),
                                            )
                                          ),
                                          child:Center(
                                            child: Text(calculateDifference(PhoneLogsCubit.get(context).PhoneCallOutBound[index]["Date"]),style: TextStyle(
                                              fontFamily: "cairo",
                                              fontSize: 10,

                                            ),),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.15,
                                          child:Column(
                                            children: [
                                              // Text("3",style: TextStyle(
                                              //   height: 1,
                                              // ),),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text("calls",style: TextStyle(
                                                    // height: 1,
                                                  ),),
                                                  CalltypeIcon(PhoneLogsCubit.get(context).PhoneCallOutBound[index]["callType"]),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                  Transform.translate(
                                    offset: Offset(MediaQuery.of(context).size.width*0.162,2),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*0.225,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color:CallLogDetailsRightContainer(),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(4),
                                        )
                                      ),
                                      child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(height: 5),
                                          Padding(
                                            padding: const EdgeInsets.only(right:8.0),
                                            child: Text(DateFormat.jm().format(PhoneLogsCubit.get(context).PhoneCallOutBound[index]["Date"]).toString(),style: CallTimeTextStyle(),),
                                          ),
                                          Align(
                                            alignment: PhoneLogsCubit.get(context).PhoneCallOutBound[index]["callType"]==CallType.incoming||PhoneLogsCubit.get(context).PhoneCallOutBound[index]["callType"]==CallType.outgoing?AlignmentDirectional.center:AlignmentDirectional.centerEnd,
                                            child: Padding(
                                              padding: EdgeInsets.only(right: PhoneLogsCubit.get(context).PhoneCallOutBound[index]["callType"]==CallType.incoming||PhoneLogsCubit.get(context).PhoneCallOutBound[index]["callType"]==CallType.outgoing?0:8,),
                                              child: Text("${PhoneLogsCubit.get(context).PhoneCallOutBound[index]["callType"].toString().replaceAll("CallType.", "")}  ${DurationFormat(PhoneLogsCubit.get(context).PhoneCallOutBound[index]["duration"], PhoneLogsCubit.get(context).PhoneCallOutBound[index]["callType"]).toString()}", style: PhoneTypeTextStyle(),),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),

                        ],
                      ),
                    ),
                  );
  }

  ListTile BlackListPhone(int index, BuildContext context){
    return ListTile(
      onTap: (){
        BlockList.removeAt(index);
        CacheHelper.saveData(key: "BlackList", value: json.encode(BlockList));
        NativeBridge.get(context).invokeNativeMethod("BlackListUpdate", BlockList);
        showToast(text: 'This number Removed Successfly', state: ToastStates.INFO , Textcolor:Colors.black);
        PhoneContactsCubit.get(context).Daillerinput();
      },
      title: Text(BlockList[index].toString()),
      trailing: Icon(Icons.remove_circle),
    );
  }



  ListTile SearchingList(BuildContext context, AppContact contact) {
    return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ContactDetails(
                                contact,
                                onContactDelete: (AppContact _contact) {
                                  PhoneContactsCubit.get(context).GetRawContacts();
                                  Navigator.of(context).pop();
                                },
                                onContactUpdate: (AppContact _contact) {
                                  PhoneContactsCubit.get(context).GetRawContacts();
                                },
                              )));
                    },
                    title: Text(
                      contact.info!.displayName.toString(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    subtitle: Text(
                      contact.info!.phones.isNotEmpty ? contact.info!.phones.elementAt(0).number.toString() : '',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    leading: ContactAvatar(contact, 45),
                    trailing: ContactsTagsNotes(context , contact),
                  );
  }
}

Icon CalltypeIcon(callType) {
  if(callType == CallType.outgoing)
  return Icon(Icons.east);
  if(callType == CallType.missed)
    return Icon(Icons.west);
  if(callType == CallType.incoming)
    return Icon(Icons.west);
  if(callType == CallType.blocked)
    return Icon(Icons.block);
  if(callType == CallType.rejected)
    return Icon(Icons.phone_disabled);
  else return Icon(Icons.battery_unknown);

}

class LoggertAvatar extends StatelessWidget {
  LoggertAvatar( this.size , this.PhoneLog , this.callType ,  this.AvatarColor);
  final CallType? callType;
  final String PhoneLog;
  final double size;
  final Color? AvatarColor;

  @override
  Widget build(BuildContext context) {
    if(callType == CallType.outgoing) {
      return Stack(
        children: [
          Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, gradient: getColorGradient(AvatarColor)), child: buildCircleAvatar(PhoneLog[0],AvatarColor)),
          Transform.translate(
              offset: Offset(15, 22),
              child: Icon(
                Icons.east,
                size: 30,
                color: HexColor("#2BDBFF").withOpacity(0.81),
              )),
          Transform.translate(
              offset: Offset(15, 35),
              child: Text(
                "calls",
                style: TextStyle(fontFamily: "OpenSans", fontStyle: FontStyle.italic, color: Colors.white, fontWeight: FontWeight.w100, fontSize: 10),
              )),
        ],
      );
    }
    if(callType == CallType.missed) {
      return Stack(
        children: [
          Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, gradient: getColorGradient(AvatarColor)), child: buildCircleAvatar(PhoneLog[0],AvatarColor )),
          Transform.translate(
              offset: Offset(15, 22),
              child: Icon(
                Icons.west,
                size: 30,
                color: HexColor("#E90800").withOpacity(0.81),
              )),
          Transform.translate(
              offset: Offset(25, 35),
              child: Text(
                "calls",
                style: TextStyle(fontFamily: "OpenSans", fontStyle: FontStyle.italic, color: Colors.white, fontWeight: FontWeight.w100, fontSize: 10),
              )),
        ],
      );
    }
    if(callType == CallType.incoming){
      return Stack(
        children: [
          Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, gradient: getColorGradient(AvatarColor)), child: buildCircleAvatar(PhoneLog[0],AvatarColor )),
          Transform.translate(
              offset: Offset(15, 22),
              child: Icon(
                Icons.west,
                size: 30,
                color: HexColor("#2BDBFF").withOpacity(0.81),
              )),
          Transform.translate(
              offset: Offset(25, 35),
              child: Text(
                "calls",
                style: TextStyle(fontFamily: "OpenSans", fontStyle: FontStyle.italic, color: Colors.white, fontWeight: FontWeight.w100, fontSize: 10),
              )),
        ],
      );
    }
    if(callType == CallType.blocked){
      return Stack(
        children: [
          Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, gradient: getColorGradient(AvatarColor)), child: buildCircleAvatar(PhoneLog[0], AvatarColor)),
          Transform.translate(
              offset: Offset(12, 12),
              child: Icon(
                Icons.block,
                size: 30,
                color: HexColor("#E90800").withOpacity(0.81),
              )),
          Transform.translate(
              offset: Offset(17, 38),
              child: Text(
                "Blocked",
                style: TextStyle(fontFamily: "OpenSans", fontStyle: FontStyle.italic, color: Colors.white, fontWeight: FontWeight.w100, fontSize: 8),
              )),
        ],
      );
    }
    if(callType == CallType.rejected){
      return Stack(
        children: [
          Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, gradient: getColorGradient(AvatarColor)), child: buildCircleAvatar(PhoneLog[0],AvatarColor )),
          // Transform.translate(
          //     offset: Offset(4, 9),
          //     child: Icon(
          //       Icons.phone_disabled,
          //       size: 15,
          //       color: HexColor("#E90800").withOpacity(0.81),
          //     )),
          Transform.translate(
              offset: Offset(7, 38),
              child: Text(
                "",
                style: TextStyle(fontFamily: "OpenSans", fontStyle: FontStyle.italic, color: Colors.white, fontWeight: FontWeight.w300, fontSize: 11),
              )),
        ],
      );
    }
    else{
      return Stack(
        children: [
          Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, gradient: getColorGradient(AvatarColor)), child: buildCircleAvatar(PhoneLog[0],AvatarColor )),
        ],
      );
    }
  }
}
CircleAvatar buildCircleAvatar(String initials , AvatarColor) {
    return CircleAvatar(child:
    Stack(
      children: [
        ClipPath(
            clipper: SemiCircleClipper(),
            child: CircleAvatar(radius: 55,backgroundColor: HexColor("#032A37").withOpacity(0.35),)),
        Center(child: Icon(Icons.person ,size: 30, color: AvatarColor == Colors.yellow || AvatarColor == Colors.orange?HexColor("#8D4A4A"):HexColor("#D1D1D1"),)),
        Transform.translate(
          offset: Offset(36,15),
          child: Text(initials.toString().toUpperCase(),
              style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
      backgroundColor: Colors.transparent,
    );
  }



LinearGradient getColorGradient(Color? color) {
  var baseColor = color as dynamic;
  Color color1 = baseColor[800];
  Color color2 = baseColor[400];
  return LinearGradient(colors: [
    color1,
    color2,
  ], begin: Alignment.bottomLeft, end: Alignment.topRight);
}

String calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  if(DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays == 0)
    {
      return  "TODAY";
    }
  if(DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays == -1)
  {
    return "YESTERDAY";
  }
  else return  DateFormat.yMMMd().format(DateTime(date.year, date.month, date.day)).toString();

}

String DurationFormat(Duration , calltype){
  String? DurationType;
  int DurationMins = (Duration/60).truncate();
  int DurationSec = (Duration%60).truncate();
  if(calltype == CallType.outgoing || calltype == CallType.incoming )
  {
      if (Duration <= 60) {
        DurationType = " Sec";
        if(Duration >9) {
        return "00:${Duration.toString()}";
      } else{
          return "00:0${Duration.toString()}";
        }
    }
      if (Duration > 60) {
        DurationType = " Min";
        if(Duration >69)
        {
        return "${DurationMins.toString()}:${DurationSec.toString()}";
      } else{
          return "${DurationMins.toString()}:0$DurationSec.toString()" ;
        }
    }
      return Duration.toString();
    }
  return "";

}

class SemiCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size){
    Path path =Path();
    path.moveTo(55, 0);
    path.lineTo(55,55);
    path.lineTo(0,55);
    // path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) =>false;
}
