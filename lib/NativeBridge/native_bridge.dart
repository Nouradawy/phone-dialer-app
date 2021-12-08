
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dialer_app/NativeBridge/native_states.dart';
import 'package:dialer_app/PhoneState/phone_events_module.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NativeBridge extends Cubit<NativeStates> {
  NativeBridge() : super(NativeBridgeInitialState());
  MethodChannel platform = MethodChannel("NativeBridge");
  static NativeBridge get(context) => BlocProvider.of(context);

  NativePhoneEvent? nativePhoneEvent;
  static const EventChannel phonestateEventsChannel = EventChannel("PhoneStatsEvents");
  late StreamSubscription _nativeEvents;

  Future<void> invokeNativeMethod(String methodName , [dynamic arguments]) async{
  String? result;
  try{
    // final String? reply = await MethodNameChanger.send(methodName);
    if(arguments == null){
      result = await platform.invokeMethod(methodName);
      emit(NativeBridgeInvokeSuccess());
    } else {
      result = await platform.invokeMethod(methodName , arguments);
    }
    emit(NativeBridgeInvokeSuccess());
  } on PlatformException catch (error){
    print("Faild to run NativeMethod , error : " + error.message.toString());
  }
  emit(NativeBridgeInvokeFaild());
}

void PhoneState (){

    switch(nativePhoneEvent?.state)
    {
      case "NEW":
        break;
      case "RINGING":

        print("phoneRINGING");
        emit(PhoneStateRinging());
        break;
      case "DIALING":

        emit(PhoneStateDialing());
        break;
      case "ACTIVE":

        emit(PhoneStateActive());
        break;
      case "HOLDING":

        emit(PhoneStateHolding());
        break;
      case "DISCONNECTED":

        emit(PhoneStateDisconnected());
        break;
      case "DISCONNECTING":

        emit(PhoneStateDisconnecting());
        break;
      case "CONNECTING":
        emit(PhoneStateConnecting());
        break;
    }
}


  void phonestateEvents(){
    emit(PhoneEventsLoading());
    _nativeEvents = phonestateEventsChannel.receiveBroadcastStream().listen((event){
      final Map<String, dynamic> value = (event as Map).cast();
      nativePhoneEvent = NativePhoneEvent(value);
      PhoneState ();
    });
  }


}
