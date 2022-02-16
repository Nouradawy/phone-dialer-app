
import 'package:call_log/call_log.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:flutter/material.dart';
class PhoneLogger{

List BaseColors =[
  Colors.green,
  Colors.indigo,
  Colors.yellow,
  Colors.orange

];
Color? AvatarColor ;
int ColorIndex =0;

void LogAvatarColors(){
AvatarColor = BaseColors[ColorIndex];
ColorIndex == BaseColors.length-1?ColorIndex = 0:ColorIndex++;

}

  Future<Iterable<CallLogEntry>> getCallLogs(){
   return CallLog.get();
  }



  List SearchableCallerIDList = [];
  List CallerID = [];
  void CallerIDFetching(PhoneNumberQuery , List<AppContact> Contacts) {

    SearchableCallerIDList.clear();
    Contacts.map((element){
      SearchableCallerIDList.add({
        "CallerID" : element.info?.displayName.toString(),
        "PhoneNumber" :
        element.info?.phones.map((e) {
          return e.number.replaceAll(' ', '');
        }),

      });
    }).toList();

    CallerID = PhoneNumberQuery !=null ?
    SearchableCallerIDList.where((element) {
      String SearchIN = element["PhoneNumber"].toString();
      return SearchIN.contains(PhoneNumberQuery.toString());
    }).toList():[];

  }
  GetCallerID(CallLogEntry entry,List<AppContact> Contacts){

    if(entry.name ==null)
      {
        CallerIDFetching(entry.number , Contacts);
        return CallerID.isNotEmpty ? CallerID[0]["CallerID"].toString() : "UNKNOWN";
      }
    else return entry.name;
  }

  GetDate(CallLogEntry entry){
    return DateTime.fromMillisecondsSinceEpoch(entry.timestamp!);
  }

  GetPhoneType(CallLogEntry entry){
    return entry.callType.toString().replaceAll("CallType.", "");
  }
}
// class PhoneLoggerList {
//   List<PhoneLoggerData> Phonelog=[];
//
//
//
//   PhoneLoggerList.fromJson(Map<String,dynamic>json){
//     json['Phonelog'].forEach((element){
//       Phonelog.add(PhoneLoggerData.fromJson(element));
//     });
//   }
// }

// class PhoneLoggerData{
//
//   String? PhoneNumber;
//   String? ContactName;
//   CallType? PhoneState;
//   int? Duration;
//   int? Date;
//   String? AccountID;
//   String? SIMname;
//
//   PhoneLoggerData.fromJson(Map<String,dynamic>json){
//
//     PhoneNumber = json['number'];
//     ContactName = json['name'];
//     PhoneState = json['callType'];
//     Duration = json['duration'];
//     Date = json['timestamp'];
//     AccountID = json['phoneAccountId'];
//     SIMname = json['simDisplayName'];
//   }
// }

