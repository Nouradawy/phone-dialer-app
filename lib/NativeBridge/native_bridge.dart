
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:call_log/call_log.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_states.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/NativeBridge/native_states.dart';
import 'package:dialer_app/Network/Local/cache_helper.dart';
import 'package:dialer_app/PhoneState/phone_events_module.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NativeBridge extends Cubit<NativeStates> {
  String? PhoneNumberQuery;
  // String? CallerID;
  NativeBridge() : super(NativeBridgeInitialState());
  MethodChannel platform = MethodChannel("NativeBridge");

  static NativeBridge get(context) => BlocProvider.of(context);
  bool? isRinging = true;
  bool? isStopWatchStart;
  NativePhoneEvent? nativePhoneEvent;
  static const EventChannel phonestateEventsChannel = EventChannel("PhoneStatsEvents");

  Future<void> invokeNativeMethod(String methodName , [dynamic arguments]) async{
  String? result;

    // final String? reply = await MethodNameChanger.send(methodName);
    if(arguments == null){
        result = await platform.invokeMethod(methodName).then((value)
            {
              emit(NativeBridgeInvokeSuccess());
            }).catchError((error){

          print("Failed to run NativeMethod , error : " + error.message.toString());
          emit(NativeBridgeInvokeFaild());
        });

    } else {
      result = await platform.invokeMethod(methodName , arguments).then((value) {

        emit(NativeBridgeInvokeSuccess());
      }).catchError((error){
        print("Failed to run NativeMethod , error : " + error.message.toString());
        emit(NativeBridgeInvokeFaild());
      });
    }

}
  bool isShowen = false;
void inCallDialerToggle(){
  isShowen =! isShowen;
    emit(ScreenRefresh());
}
void PhoneState(){

      switch ( nativePhoneEvent?.state) {
        case "NEW":
          break;
        case "RINGING":
          print(nativePhoneEvent?.state.toString());
          emit(PhoneStateRinging());
          break;
        case "DIALING":
          print(nativePhoneEvent?.state.toString());
          emit(PhoneStateDialing());
          break;
        case "ACTIVE":
          print(nativePhoneEvent?.state.toString());
          emit(PhoneStateActive());
          break;
        case "HOLDING":
          print(nativePhoneEvent?.state.toString());
          emit(PhoneStateHolding());
          break;
        case "DISCONNECTED":

          print(nativePhoneEvent?.state.toString());
          emit(PhoneStateDisconnected());
          break;
        case "DISCONNECTING":
          print(nativePhoneEvent?.state.toString());
          emit(PhoneStateDisconnecting());
          break;
        case "CONNECTING":
          print(nativePhoneEvent?.state.toString());
          emit(PhoneStateConnecting());
          break;
      }

  }

  void phonestateEvents(){
    phonestateEventsChannel.receiveBroadcastStream().listen((event)  {
      final Map<String, dynamic> value = (event as Map).cast();
      nativePhoneEvent = NativePhoneEvent(value);
      PhoneNumberQuery = nativePhoneEvent?.phoneNumber.toString();

      PhoneState();
    });


  }

  List SearchableCallerIDList = [];
  List CallerID = [];

  void GetCallerID(List<AppContact>? Contacts) {

    SearchableCallerIDList.clear();
    Contacts?.map((element){
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
// emit(CallerIDSuccessState(CallerIDName:CallerID[0]["CallerID"].toString()));
  }
}
