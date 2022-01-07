
import 'dart:ui';

import 'package:call_log/call_log.dart';
class PhoneLogger{
  String? PhoneNumber;
  String? ContactName;
  CallType? PhoneState;
  int? Duration;
  int? Date;
  String? AccountID;
  String? SIMname;

  PhoneLogger({
    required PhoneNumber,
    required String? ContactName,
    required CallType? PhoneState,
    required int? Duration,
    required int? Date,
    required String? AccountID,
    required String? SIMname,
});
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

