

import 'package:call_log/call_log.dart';
import 'package:dialer_app/Components/contacts_components.dart';
import 'package:dialer_app/Models/phone_log_model.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/Modules/Contacts/contacts_screen.dart';
import 'package:dialer_app/Themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';


class PhoneScreen extends StatelessWidget {
  PhoneLogger c1 = new PhoneLogger();
  late Future<Iterable<CallLogEntry>> logs;

  @override
  Widget build(BuildContext context) {
    logs = c1.getCallLogs();
    return PhoneContactsCubit.get(context).isSearching!=true?FutureBuilder<Iterable<CallLogEntry>>(
      future: logs,
      builder:(context,snapshot) {
        if(snapshot.connectionState == ConnectionState.done ) {
          final entries = snapshot.requireData;
        return ListView.builder(
          itemCount:entries.length,
          itemBuilder: (context, index) {
            c1.LogAvatarColors();
            return Column(
              children: [
                index == 0 ?Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text("All"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text("Missed"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text("InBound"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text("OutBound"),
                            ),
                          ],
                        ),
                      ):Container(),

                PhoneLogList(entries, index, context),
              ],
            );
          },
        );
      } else {
          return Center(child: CircularProgressIndicator());
        }
    },
    ):ListView.builder(
      itemCount:   PhoneContactsCubit.get(context).FilterdContacts.length,
      itemBuilder: (context, index) {
        AppContact contact = PhoneContactsCubit.get(context).FilterdContacts[index];
        return Column(
          children: [
            SearchingList(context, contact),
          ],
        );
      },
    );
  }

  ListTile PhoneLogList(Iterable<CallLogEntry> entries, int index, BuildContext context) {
    return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    onTap: () {},
                    title: Transform.translate(
                      offset: Offset(-5,0),
                      child: Text(
                        c1.GetCallerID(entries.elementAt(index), PhoneContactsCubit.get(context).Contacts).toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    subtitle: Transform.translate(
                      offset:Offset(-5,0),
                      //TODO: Let the user at the initialization Screen Specify SIM1 & SIM2
                      child: Row(
                        children: [

                      Image.asset(entries.first.phoneAccountId == entries.elementAt(index).phoneAccountId?"assets/Images/sim1.png" :"assets/Images/sim2.png",scale: 1.3),
                          Text(
                            " ${entries.elementAt(index).number.toString()}",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                    leading: LoggertAvatar(55, entries.elementAt(index).name.toString(), entries.elementAt(index).callType, c1.AvatarColor),
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
                                            child: Text(calculateDifference(c1.GetDate(entries.elementAt(index))),style: TextStyle(
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
                                                  CalltypeIcon(entries.elementAt(index).callType),
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
                                          SizedBox(height: 5,),
                                          Padding(
                                            padding: const EdgeInsets.only(right:8.0),
                                            child: Text(DateFormat.jm().format(c1.GetDate(entries.elementAt(index))).toString(),style: CallTimeTextStyle(),),
                                          ),
                                          Align(
                                            alignment: entries.elementAt(index).callType==CallType.incoming||entries.elementAt(index).callType==CallType.outgoing?AlignmentDirectional.center:AlignmentDirectional.centerEnd,
                                            child: Padding(
                                              padding: EdgeInsets.only(right: entries.elementAt(index).callType==CallType.incoming||entries.elementAt(index).callType==CallType.outgoing?0:8,),
                                              child: Text("${c1.GetPhoneType(entries.elementAt(index))}  ${DurationFormat(entries.elementAt(index).duration, entries.elementAt(index).callType).toString()}", style: PhoneTypeTextStyle(),),
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
CircleAvatar buildCircleAvatar(String? initials , AvatarColor) {
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
