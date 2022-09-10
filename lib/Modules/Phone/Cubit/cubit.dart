import 'package:bloc/bloc.dart';
import 'package:call_log/call_log.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/Modules/Phone/Cubit/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneLogsCubit extends Cubit<PhoneLogsStates> {
  PhoneLogsCubit() : super(PhoneLogsInitialState());
  static PhoneLogsCubit get(context) => BlocProvider.of(context);
  bool PhoneRange = false;

  List BaseColors =[
    Colors.green,
    Colors.indigo,
    Colors.yellow,
    Colors.orange

  ];

  Color? AvatarColor ;
  int ColorIndex =0;

  List PhoneCallLogs =[];
  List PhoneCallMissed =[];
  List PhoneCallInBound =[];
  List PhoneCallOutBound =[];

  void LogAvatarColors(){
    AvatarColor = BaseColors[ColorIndex];
    ColorIndex == BaseColors.length-1?ColorIndex = 0:ColorIndex++;

  }

  void getCallLogsInitial(List<AppContact> contacts)  async {
    final Iterable<CallLogEntry> cLog = await CallLog.get();
    for (CallLogEntry entry in cLog)
    {

      PhoneCallLogs.add({
        "name":GetCallerID(entry,contacts),
        "number":entry.number,
        "phoneAccountId":entry.phoneAccountId,
        "duration":entry.duration,
        "callType":entry.callType,
        "Date":DateTime.fromMillisecondsSinceEpoch(entry.timestamp!),

      });

      if(entry.callType ==CallType.outgoing )
      {
        PhoneCallOutBound.add({
          "name":GetCallerID(entry,contacts),
          "number":entry.number,
          "phoneAccountId":entry.phoneAccountId,
          "duration":entry.duration,
          "callType":entry.callType,
          "Date":DateTime.fromMillisecondsSinceEpoch(entry.timestamp!),
        });
      }

      if(entry.callType ==CallType.incoming )
      {
        PhoneCallInBound.add({
          "name":GetCallerID(entry,contacts),
          "number":entry.number,
          "phoneAccountId":entry.phoneAccountId,
          "duration":entry.duration,
          "callType":entry.callType,
          "Date":DateTime.fromMillisecondsSinceEpoch(entry.timestamp!),
        });
      }

      if(entry.callType ==CallType.missed )
      {
        PhoneCallMissed.add({
          "name":GetCallerID(entry,contacts),
          "number":entry.number,
          "phoneAccountId":entry.phoneAccountId,
          "duration":entry.duration,
          "callType":entry.callType,
          "Date":DateTime.fromMillisecondsSinceEpoch(entry.timestamp!),
        });
      }

    }

  }
  List contactCalllog = [];
  void ContactCallLogs(AppContact contact){
    contactCalllog.clear();
    contactCalllog =PhoneCallLogs.toList();
    contactCalllog.retainWhere((element) {
      return contact.info!.phones.any((e) => element["number"]==e.number);
    });
  }
  void CallLogsUpdate (List<AppContact> contacts){
    PhoneCallLogs.clear();
    PhoneCallOutBound.clear();
    PhoneCallInBound.clear();
    PhoneCallMissed.clear();
    getCallLogsInitial(contacts);
    PhoneRange =false;
    emit(PhoneLogsUpdated());
  }

  void FilterLogScreen(List<AppContact> contacts){
    PhoneCallLogs.clear();
    getCallLogsInitial(contacts);
    PhoneRange =false;
    emit(PhoneLogsUpdated());
  }



  List SearchableCallerIDList = [];
  List CallerID = [];
  String? ContactID ;

  void CallerIDFetching(PhoneNumberQuery , List<AppContact> Contacts) {
    CallerID.clear();
    SearchableCallerIDList.clear();
    Contacts.map((element){
      SearchableCallerIDList.add({
        "CallerID" : element.info?.displayName.toString(),
        "PhoneNumber" :
        element.info?.phones.map((e) {
          return e.number.replaceAll(' ', '');
        }),
        "id": element.info?.id,
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
    else
      return entry.name!.isNotEmpty ? entry.name : "UNKNOWN";

  }


  GetDate(CallLogEntry entry){
    return DateTime.fromMillisecondsSinceEpoch(entry.timestamp!);
  }

  GetPhoneType(CallLogEntry entry){
    return entry.callType.toString().replaceAll("CallType.", "");
  }

}