
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dialer_app/Components/contacts_components.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:dialer_app/Models/phone_log_model.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/Modules/Contacts/contacts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class PhoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var Cubit = AppCubit.get(context);
    return SafeArea(
      child:BlocProvider.value(
        value:AppCubit.get(context)..GetPhoneLog(),
        child: ListView.builder(
                itemCount:  Cubit.isSearching == true?Cubit.FilterdContacts.length:AppCubit.get(context).PhoneCallLogs.length,
                itemBuilder: (context, index) {
                  AppContact contact = Cubit.isSearching == true?Cubit.FilterdContacts[index]:Cubit.Contacts[index];
                  var phonelog = AppCubit.get(context).PhoneCallLogs[index];
                  return Column(
                    children: [
                      index==0 && Cubit.isSearching!=true?Padding(
                        padding: const EdgeInsets.only(left:30.0),
                        child: Row(children: const [
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
                        ],),
                      ):Container(),
                      Cubit.isSearching != true?ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                        onTap: () {},
                        title: Text(phonelog["ContactName"].toString(),style: Theme.of(context).textTheme.bodyText1,),
                        subtitle: Text(phonelog["PhoneNumber"].toString(),
                          style: Theme.of(context).textTheme.bodyText2,),
                        leading: LoggertAvatar( 45 , phonelog["ContactName"].toString() , contact),
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                            ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 150,
                                ),
                                child: calculateDifference(phonelog["Date"])),
                            Text( "${phonelog["PhoneState"]}"+DurationFormat(phonelog["Duration"])),

                          ],),
                        ),

                      ): ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ContactDetails(
                                    contact,
                                    onContactDelete: (AppContact _contact) {
                                      Cubit.GetContacts();
                                      Navigator.of(context).pop();
                                    },
                                    onContactUpdate: (AppContact _contact) {
                                      Cubit.GetContacts();
                                    },
                                  )
                          ));
                        },
                        title: Text(
                          contact.info!.displayName.toString(), style: Theme
                            .of(context)
                            .textTheme
                            .bodyText1,),
                        subtitle: Text(
                          contact.info!.phones!.isNotEmpty ? contact.info!
                              .phones!
                              .elementAt(0).value.toString() : '',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyText2,),
                        leading: ContactAvatar(contact, 45),
                        trailing: ContactsTagsNotes(context),
                      ),
                    ],
                  );
                },
              ),
      )
      );
  }
}

// class ContactDetails extends StatefulWidget {
//   ContactDetails(this.contact, {required this.onContactUpdate, required this.onContactDelete});
//
//   final AppContact contact;
//   final Function(AppContact) onContactUpdate;
//   final Function(AppContact) onContactDelete;
//   @override
//   _ContactDetailsState createState() => _ContactDetailsState();
// }
//
// class _ContactDetailsState extends State<ContactDetails> {
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> actions = <String>[
//       'Edit',
//       'Delete'
//     ];
//
//     showDeleteConfirmation() {
//       Widget cancelButton = FlatButton(
//         child: Text('Cancel'),
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//       );
//       Widget deleteButton = FlatButton(
//         color: Colors.red,
//         child: Text('Delete'),
//         onPressed: () async {
//           await ContactsService.deleteContact(widget.contact.info!);
//           widget.onContactDelete(widget.contact);
//           Navigator.of(context).pop();
//         },
//       );
//       AlertDialog alert= AlertDialog(
//         title: Text('Delete contact?'),
//         content: Text('Are you sure you want to delete this contact?'),
//         actions: <Widget>[
//           cancelButton,
//           deleteButton
//         ],
//       );
//
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return alert;
//           }
//       );
//
//     }
//
//     onAction(String action) async {
//       switch(action) {
//         case 'Edit':
//           try {
//             Contact updatedContact = await ContactsService.openExistingContact(widget.contact.info!);
//             setState(() {
//               widget.contact.info = updatedContact;
//             });
//             widget.onContactUpdate(widget.contact);
//           } on FormOperationException catch (e) {
//             switch(e.errorCode) {
//               case FormOperationErrorCode.FORM_OPERATION_CANCELED:
//               case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
//               case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
//                 print(e.toString());
//             }
//           }
//           break;
//         case 'Delete':
//           showDeleteConfirmation();
//           break;
//       }
//       print(action);
//     }
//
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: 180,
//               decoration: BoxDecoration(color: Colors.grey[300]),
//               child: Stack(
//                 alignment: Alignment.topCenter,
//                 children: <Widget>[
//                   // Center(child: ContactAvatar(widget.contact, 100)),
//                   Align(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: IconButton(
//                         icon: Icon(Icons.arrow_back),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ),
//                     alignment: Alignment.topLeft,
//                   ),
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: PopupMenuButton(
//                         onSelected: onAction,
//                         itemBuilder: (BuildContext context) {
//                           return actions.map((String action) {
//                             return PopupMenuItem(
//                               value: action,
//                               child: Text(action),
//                             );
//                           }).toList();
//                         },
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView(shrinkWrap: true, children: <Widget>[
//                 ListTile(
//                   title: Text("Name"),
//                   trailing: Text(widget.contact.info!.givenName ?? ""),
//                 ),
//                 ListTile(
//                   title: Text("Family name"),
//                   trailing: Text(widget.contact.info!.familyName ?? ""),
//                 ),
//                 Column(
//                   children: <Widget>[
//                     ListTile(title: Text("Phones")),
//                     Column(
//                       children: widget.contact.info!.phones!
//                           .map(
//                             (i) => Padding(
//                           padding:
//                           const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: ListTile(
//                             title: Text(i.label ?? ""),
//                             trailing: Text(i.value ?? ""),
//                           ),
//                         ),
//                       )
//                           .toList(),
//                     )
//                   ],
//                 )
//               ]),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class LoggertAvatar extends StatelessWidget {
  LoggertAvatar( this.size , this.PhoneLogName , this.contact);
  final String PhoneLogName;
  final double size;
  final AppContact contact;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle, gradient: getColorGradient(contact.color)),
        child:buildCircleAvatar(PhoneLogName[0]));
  }
}
CircleAvatar buildCircleAvatar(String? initials) {
    return CircleAvatar(child: Text(initials.toString(),
        style: TextStyle(color: Colors.white)),
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

Row calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  if(DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays == 0)
    {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("TODAY"),
          Text(DateFormat.d().add_MMM().format(DateTime(date.year, date.month, date.day)).toString()),
        ],
      );
    }
  if(DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays == -1)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("YESTERDAY"),
        Text(DateFormat.jm().format(DateTime(date.year, date.month, date.day)).toString()),
      ],
    );
  }
  else return  Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(DateFormat.d().add_MMM().format(DateTime(date.year, date.month, date.day)).toString(),style: TextStyle(color: Colors.white),),
        ),
      ),
      Text(DateFormat.jm().format(DateTime(date.year, date.month, date.day)).toString()),

    ],
  );

}

String DurationFormat(Duration){
  String? DurationType;
  int DurationMins = (Duration/60).truncate();
  int DurationSec = (Duration%60).truncate();
  if(Duration <= 60)
    {
      DurationType = "Sec";
      return Duration.toString() + DurationType;
    }
  if(Duration >60)
  {
    DurationType = " Min";
    return DurationMins.toString() + DurationType + DurationSec.toString() + " Sec";
  }
  return Duration.toString();

}