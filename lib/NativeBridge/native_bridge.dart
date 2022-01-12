
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
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




  NativePhoneEvent? nativePhoneEvent;
  static const EventChannel phonestateEventsChannel = EventChannel("PhoneStatsEvents");
  late StreamSubscription _nativeEvents;

//   Future<void> invokeNativeMethod(String methodName , [dynamic arguments]) async{
//   String? result;
//   try{
//     // final String? reply = await MethodNameChanger.send(methodName);
//     if(arguments == null){
//       result = await platform.invokeMethod(methodName);
//       emit(NativeBridgeInvokeSuccess());
//     } else {
//       result = await platform.invokeMethod(methodName , arguments);
//     }
//
//     emit(NativeBridgeInvokeSuccess());
//   } on PlatformException catch (error){
//     print("Faild to run NativeMethod , error : " + error.message.toString());
//   }
//   emit(NativeBridgeInvokeFaild());
// }
  Future<void> invokeNativeMethod(String methodName , [dynamic arguments]) async{
  String? result;

    // final String? reply = await MethodNameChanger.send(methodName);
    if(arguments == null){
        result = await platform.invokeMethod(methodName).then((value)
            {
              print("this came from Mainnnn");
              emit(NativeBridgeInvokeSuccess());
            }).catchError((error){
          print("this came from Mainnnn");
          print("Faild to run NativeMethod , error : " + error.message.toString());
          emit(NativeBridgeInvokeFaild());
        });

    } else {
      result = await platform.invokeMethod(methodName , arguments).then((value) {
        print("this came from Else");
        emit(NativeBridgeInvokeSuccess());
      }).catchError((error){
        print("this came from Else");
        print("Faild to run NativeMethod , error : " + error.message.toString());
        emit(NativeBridgeInvokeFaild());
      });
    }

}

void UpdateCallerID(){
    // CallerID = callerID;
    emit(updateCallerID());
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
    _nativeEvents = phonestateEventsChannel.receiveBroadcastStream().listen((event)  {
      final Map<String, dynamic> value = (event as Map).cast();
      nativePhoneEvent = NativePhoneEvent(value);
      PhoneNumberQuery = nativePhoneEvent?.phoneNumber.toString();

      PhoneState();
    });


  }


}
