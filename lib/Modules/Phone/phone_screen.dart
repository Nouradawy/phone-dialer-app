

import 'package:call_log/call_log.dart';
import 'package:dialer_app/Components/contacts_components.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/Modules/Contacts/contacts_screen.dart';
import 'package:dialer_app/Themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'Cubit/cubit.dart';
import 'Cubit/state.dart';


class PhoneScreen extends StatelessWidget {
  // PhoneLogger c1 = new PhoneLogger();
  // late Future<Iterable<CallLogEntry>> logs;
  @override
  Widget build(BuildContext context) {
    // logs = c1.getCallLogs();

    if(PhoneLogsCubit.get(context).PhoneRange == true){
      PhoneLogsCubit.get(context).CallLogsUpdate(PhoneContactsCubit.get(context).Contacts);
      AppCubit.get(context).ShowHide();
    }
    // PhoneLogsList(index,context)
    return  PhoneContactsCubit.get(context).isSearching!=true?

    SafeArea(
      child:
          DefaultTabController(length: 4,
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(10,-6),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.75,
                    height: 40,
                    child: TabBar(
                      physics: NeverScrollableScrollPhysics(),
                      isScrollable: true,
                      labelStyle: TextStyle(fontSize: 9),
                    labelColor: Colors.black,
                    indicatorColor: HexColor("#F07F5C"),
                    unselectedLabelColor: Colors.black,
                    // indicator: BoxDecoration(
                    //   color: HexColor("#EB3B04").withOpacity(0.65),
                    // ),
                    tabs: [

                      Tab(text: 'All', icon: Icon(Icons.apps,size: 18),iconMargin: EdgeInsets.symmetric(vertical: 2)),
                      Tab(text: 'Missed', icon: Icon(Icons.call_missed_outgoing, size:20),iconMargin: EdgeInsets.symmetric(vertical: 2),),
                      Tab(text: 'Recived', icon: Icon(Icons.call_received,size: 20),iconMargin: EdgeInsets.symmetric(vertical: 2),),
                      Tab(text: 'Made', icon: Icon(Icons.call_made,size: 20),iconMargin: EdgeInsets.symmetric(vertical: 2),),
                    ],),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [

                        BlocBuilder<PhoneLogsCubit,PhoneLogsStates>(
                          builder: (context,index)=>ListView.builder(
                            itemCount: PhoneLogsCubit.get(context).PhoneCallLogs.length,
                            itemBuilder: (context,index) {
                              PhoneLogsCubit.get(context).LogAvatarColors();
                              return AllPhoneLogs(index,context);

                            },),
                        ),
                        BlocBuilder<PhoneLogsCubit,PhoneLogsStates>(
                          builder: (context,index)=>ListView.builder(
                            itemCount: PhoneLogsCubit.get(context).PhoneCallMissed.length,
                            itemBuilder: (context,index) {
                              PhoneLogsCubit.get(context).LogAvatarColors();
                              return MissedPhoneLogs(index,context);

                            },),
                        ),
                        BlocBuilder<PhoneLogsCubit,PhoneLogsStates>(
                          builder: (context,index)=>ListView.builder(
                            itemCount: PhoneLogsCubit.get(context).PhoneCallInBound.length,
                            itemBuilder: (context,index) {
                              PhoneLogsCubit.get(context).LogAvatarColors();
                              return InBoundPhoneLogs(index,context);

                            },),
                        ),
                        BlocBuilder<PhoneLogsCubit,PhoneLogsStates>(
                          builder: (context,index)=>ListView.builder(
                            itemCount: PhoneLogsCubit.get(context).PhoneCallOutBound.length,
                            itemBuilder: (context,index) {
                              PhoneLogsCubit.get(context).LogAvatarColors();
                              return OutBoundPhoneLogs(index,context);

                            },),
                        ),
                      ]),
                ),
              ],
            ),),


    ):ListView.builder(
      itemCount:   PhoneContactsCubit.get(context).FilterdContacts.length,
      itemBuilder: (context, index) {
        AppContact contact = PhoneContactsCubit.get(context).FilterdContacts[index];
        return Column(
          children: [
            SearchingList(context, contact),
          ],
        );}
    );

    // return PhoneContactsCubit.get(context).isSearching!=true?
    //     BlocBuilder<PhoneLogsCubit,PhoneLogsStates>(
    //       builder: (context,index)=>ListView.builder(
    //         itemCount: PhoneLogsCubit.get(context).PhoneCallLogs.length,
    //         itemBuilder: (context,index) {
    //           PhoneLogsCubit.get(context).LogAvatarColors();
    //         return Column(
    //           children: [
    //             index == 0 ?Padding(
    //                                 padding: const EdgeInsets.only(left: 30.0),
    //                                 child: Row(
    //                                   children:[
    //                                     NavigationRail(
    //                                       labelType: NavigationRailLabelType.selected,
    //                                       destinations:<NavigationRailDestination>[
    //                                         NavigationRailDestination(
    //                                           icon: Icon(Icons.star_border),
    //                                           selectedIcon: Icon(Icons.star),
    //                                           label: Text('Third'),
    //                                         ),
    //                                         NavigationRailDestination(
    //                                           icon: Icon(Icons.star_border),
    //                                           selectedIcon: Icon(Icons.star),
    //                                           label: Text('Third'),
    //                                         ),
    //                                       ],
    //                                       selectedIndex: 0,
    //                                     ),
    //                                   ],
    //                                 ),):Container(),
    //                       ],);
    //
    //       },),
    //     )


    // FutureBuilder<Iterable<CallLogEntry>>(
    //   future: logs,
    //   builder:(context,snapshot) {
    //     if(snapshot.connectionState == ConnectionState.done ) {
    //       final entries = snapshot.requireData;
    //     return ListView.builder(
    //       itemCount:entries.length,
    //       itemBuilder: (context, index) {
    //         c1.LogAvatarColors();
    //         return Column(
    //           children: [
    //             index == 0 ?Padding(
    //                     padding: const EdgeInsets.only(left: 30.0),
    //                     child: Row(
    //                       children: const [
    //                         Padding(
    //                           padding: EdgeInsets.symmetric(horizontal: 5.0),
    //                           child: Text("All"),
    //                         ),
    //                         Padding(
    //                           padding: EdgeInsets.symmetric(horizontal: 5.0),
    //                           child: Text("Missed"),
    //                         ),
    //                         Padding(
    //                           padding: EdgeInsets.symmetric(horizontal: 5.0),
    //                           child: Text("InBound"),
    //                         ),
    //                         Padding(
    //                           padding: EdgeInsets.symmetric(horizontal: 5.0),
    //                           child: Text("OutBound"),
    //                         ),
    //                       ],
    //                     ),
    //                   ):Container(),
    //             PhoneLogList(entries, index, context),
    //           ],
    //         );
    //       },
    //     );
    //   } else {
    //       return Center(child: CircularProgressIndicator());
    //     }
    // },
    // )





  }

  // ListTile PhoneLogList(Iterable<CallLogEntry> entries, int index, BuildContext context) {
  //   return ListTile(
  //                   contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
  //                   onTap: () {},
  //                   title: Transform.translate(
  //                     offset: Offset(-5,0),
  //                     child: Text(
  //                       c1.GetCallerID(entries.elementAt(index), PhoneContactsCubit.get(context).Contacts).toString(),
  //                       style: Theme.of(context).textTheme.bodyText1,
  //                     ),
  //                   ),
  //                   subtitle: Transform.translate(
  //                     offset:Offset(-5,0),
  //                     //TODO: Let the user at the initialization Screen Specify SIM1 & SIM2
  //                     child: Row(
  //                       children: [
  //
  //                     Image.asset(entries.first.phoneAccountId == entries.elementAt(index).phoneAccountId?"assets/Images/sim1.png" :"assets/Images/sim2.png",scale: 1.3),
  //                         Text(
  //                           " ${entries.elementAt(index).number.toString()}",
  //                           style: Theme.of(context).textTheme.bodyText2,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //     //TODO:Something Retarining null at loggerAvatar(Only affected by Android 32)
  //                   leading: LoggertAvatar(55, entries.elementAt(index).name.toString(), entries.elementAt(index).callType, c1.AvatarColor),
  //                   trailing: Padding(
  //                     padding: const EdgeInsets.only(right: 8.0),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.end,
  //                       children: [
  //                         ConstrainedBox(
  //                             constraints: BoxConstraints(
  //                               maxWidth: MediaQuery.of(context).size.width*0.40,
  //                             ),
  //                             child:Stack(
  //                               children: [
  //                                 Container(
  //                                   width: MediaQuery.of(context).size.width*0.40,
  //                                   height: 12,
  //                                   decoration: BoxDecoration(
  //                                     color:HexColor("#8F00B9"),
  //                                     borderRadius: BorderRadius.circular(3)
  //                                   ),
  //
  //                                 ),
  //                                 Transform.translate(
  //                                   offset: Offset(5,2),
  //                                   child: Column(
  //                                     children: [
  //                                       Container(
  //                                         width: MediaQuery.of(context).size.width*0.15,
  //                                         height: 28,
  //                                         decoration: BoxDecoration(
  //                                           color:HexColor("#BFE5F9"),
  //                                           borderRadius: BorderRadius.only(
  //                                             bottomLeft: Radius.circular(4),
  //                                           )
  //                                         ),
  //                                         child:Center(
  //                                           child: Text(calculateDifference(c1.GetDate(entries.elementAt(index))),style: TextStyle(
  //                                             fontFamily: "cairo",
  //                                             fontSize: 10,
  //
  //                                           ),),
  //                                         ),
  //                                       ),
  //                                       Container(
  //                                         width: MediaQuery.of(context).size.width*0.15,
  //                                         child:Column(
  //                                           children: [
  //                                             // Text("3",style: TextStyle(
  //                                             //   height: 1,
  //                                             // ),),
  //                                             Row(
  //                                               mainAxisAlignment: MainAxisAlignment.end,
  //                                               children: [
  //                                                 Text("calls",style: TextStyle(
  //                                                   // height: 1,
  //                                                 ),),
  //                                                 CalltypeIcon(entries.elementAt(index).callType),
  //                                               ],
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //
  //                                 ),
  //                                 Transform.translate(
  //                                   offset: Offset(MediaQuery.of(context).size.width*0.162,2),
  //                                   child: Container(
  //                                     width: MediaQuery.of(context).size.width*0.225,
  //                                     height: 55,
  //                                     decoration: BoxDecoration(
  //                                       color:HexColor("#F2E7FE"),
  //                                       borderRadius: BorderRadius.only(
  //                                         bottomLeft: Radius.circular(4),
  //                                       )
  //                                     ),
  //                                     child:Column(
  //                                       crossAxisAlignment: CrossAxisAlignment.end,
  //                                       children: [
  //                                         SizedBox(height: 5),
  //                                         Padding(
  //                                           padding: const EdgeInsets.only(right:8.0),
  //                                           child: Text(DateFormat.jm().format(c1.GetDate(entries.elementAt(index))).toString(),style: CallTimeTextStyle(),),
  //                                         ),
  //                                         Align(
  //                                           alignment: entries.elementAt(index).callType==CallType.incoming||entries.elementAt(index).callType==CallType.outgoing?AlignmentDirectional.center:AlignmentDirectional.centerEnd,
  //                                           child: Padding(
  //                                             padding: EdgeInsets.only(right: entries.elementAt(index).callType==CallType.incoming||entries.elementAt(index).callType==CallType.outgoing?0:8,),
  //                                             child: Text("${c1.GetPhoneType(entries.elementAt(index))}  ${DurationFormat(entries.elementAt(index).duration, entries.elementAt(index).callType).toString()}", style: PhoneTypeTextStyle(),),
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             )),
  //                       ],
  //                     ),
  //                   ),
  //                 );
  // }


  ListTile AllPhoneLogs( int index, BuildContext context) {
    return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    onTap: () {},
                    title: Transform.translate(
                      offset: Offset(-5,0),
                      child: Text(
                        PhoneLogsCubit.get(context).PhoneCallLogs[index]["name"].toString(),
                        style: Theme.of(context).textTheme.bodyText1,
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
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
      // //TODO:Something Retarining null at loggerAvatar(Only affected by Android 32)
                    leading: PhoneLogsCubit.get(context).AvatarColor !=null?LoggertAvatar(55, PhoneLogsCubit.get(context).PhoneCallLogs[index]["name"].toString(), PhoneLogsCubit.get(context).PhoneCallLogs[index]["callType"], PhoneLogsCubit.get(context).AvatarColor):Text(""),
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
                                      color:HexColor("#8F00B9"),
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
                                            color:HexColor("#BFE5F9"),
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
                                        color:HexColor("#F2E7FE"),
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
                      ),
                    ),
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
                    leading: PhoneLogsCubit.get(context).AvatarColor !=null?LoggertAvatar(55, PhoneLogsCubit.get(context).PhoneCallMissed[index]["name"].toString(), PhoneLogsCubit.get(context).PhoneCallMissed[index]["callType"], PhoneLogsCubit.get(context).AvatarColor):Text(""),
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
                                      color:HexColor("#8F00B9"),
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
                                            color:HexColor("#BFE5F9"),
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
                                        color:HexColor("#F2E7FE"),
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
                    leading: PhoneLogsCubit.get(context).AvatarColor !=null?LoggertAvatar(55, PhoneLogsCubit.get(context).PhoneCallInBound[index]["name"].toString(), PhoneLogsCubit.get(context).PhoneCallInBound[index]["callType"], PhoneLogsCubit.get(context).AvatarColor):Text(""),
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
                                      color:HexColor("#8F00B9"),
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
                                            color:HexColor("#BFE5F9"),
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
                                        color:HexColor("#F2E7FE"),
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
                    leading: PhoneLogsCubit.get(context).AvatarColor !=null?LoggertAvatar(55, PhoneLogsCubit.get(context).PhoneCallOutBound[index]["name"].toString(), PhoneLogsCubit.get(context).PhoneCallOutBound[index]["callType"], PhoneLogsCubit.get(context).AvatarColor):Text(""),
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
                                      color:HexColor("#8F00B9"),
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
                                            color:HexColor("#BFE5F9"),
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
                                        color:HexColor("#F2E7FE"),
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
                    trailing: ContactsTagsNotes(context),
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
          Transform.translate(
              offset: Offset(4, 9),
              child: Icon(
                Icons.phone_disabled,
                size: 15,
                color: HexColor("#E90800").withOpacity(0.81),
              )),
          Transform.translate(
              offset: Offset(7, 38),
              child: Text(
                "Declined",
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
  else return  DateFormat.d().add_MMM().format(DateTime(date.year, date.month, date.day)).toString();

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
