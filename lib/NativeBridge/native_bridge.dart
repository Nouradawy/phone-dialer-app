
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_states.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/NativeBridge/native_states.dart';
import 'package:dialer_app/Network/Local/cache_helper.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../Models/user_model.dart';

class NativeBridge extends Cubit<NativeStates> {
  String? PhoneNumberQuery;
  String? CallerappID;
  bool? ConferenceManage =false;
  bool? OnConference =false;
  bool? MergedOrRinging = false;
  bool isShowen = false;
  bool ExpandeNotes = false;
  bool NewNote = false;
  bool _isNear = false;
  List Calls =[];
  List ConferenceCalls =[];
  List<StopWatchTimer> CallDuration =[];
  final StopWatchTimer ConferenceTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    presetMillisecond: StopWatchTimer.getMilliSecFromMinute(0),
    // millisecond => minute.
    // onChange: (value) => ),
    // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );
  NativeBridge() : super(NativeBridgeInitialState());
  MethodChannel platform = MethodChannel("NativeBridge");

  late StreamSubscription<dynamic> streamSubscription;
  static NativeBridge get(context) => BlocProvider.of(context);
  Contact? contact;
  bool? isRinging= false;
  TextEditingController CallReasonController = TextEditingController();
  bool? Dialing = false;
  bool? isStopWatchStart;
  NativePhoneEvent? nativePhoneEvent;
  static const EventChannel phonestateEventsChannel = EventChannel("PhoneStatsEvents");

  Future<void> invokeNativeMethod(String methodName,
      [dynamic arguments]) async {
    String? result;

    // final String? reply = await MethodNameChanger.send(methodName);
    if (arguments == null) {
      result = await platform.invokeMethod(methodName).then((value) {
        emit(NativeBridgeInvokeSuccess());
      }).catchError((error) {
        print(
            "Failed to run NativeMethod , error : " + error.message.toString());
        emit(NativeBridgeInvokeFaild());
      });
    } else {
      result = await platform.invokeMethod(methodName, arguments).then((value) {
        emit(NativeBridgeInvokeSuccess());
      }).catchError((error) {
        print(
            "Failed to run NativeMethod , error : " + error.message.toString());
        emit(NativeBridgeInvokeFaild());
      });
    }
  }



  void inCallDialerToggle() {
    isShowen = !isShowen;
    emit(ScreenRefresh());
  }

  void proximity() {
    emit(ScreenRefresh());
  }

  void NotesToggle() {
    ExpandeNotes = !ExpandeNotes;
    emit(NotesEpandeSuccess());
  }

  void AddNewNote() {
    NewNote = !NewNote;
    emit(NewNoteAddedSuccess());
  }


  void PhoneState() {
    switch (nativePhoneEvent?.state) {
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

  void phonestateEvents() {
    phonestateEventsChannel.receiveBroadcastStream().listen((event) {
      final Map<String, dynamic> value = (event as Map).cast();
      nativePhoneEvent = NativePhoneEvent(value);
      PhoneNumberQuery = nativePhoneEvent?.phoneNumber.toString();
      nativePhoneEvent?.type =="true"?OnConference=true:null;

      PhoneState();
    });
  }

  List SearchableCallerIDList = [];
  List CallerID = [];

  void GetCallerID(List<AppContact>? Contacts) {
    CallerID.clear();
    SearchableCallerIDList.clear();
    Contacts?.map((element) {
      SearchableCallerIDList.add({
        "CallerID": element.info?.displayName.toString(),
        "PhoneNumber":
        element.info?.phones.map((e) {
          return e.number.replaceAll(' ', '');
        }),
        "id": element.info?.id,
      });
    }).toList();

    CallerID = PhoneNumberQuery != null ?
    SearchableCallerIDList.where((element) {
      String SearchIN = element["PhoneNumber"].toString();
      return SearchIN.contains(PhoneNumberQuery.toString().replaceAll(" ", ""));
    }).toList() : [];
    print("Caller id:"+CallerID.toString());
    GetContactByID();
  }

  Future<void> GetContactByID() async {
    if (CallerID.isNotEmpty && CallerID[0]["id"] != [] ) {
      contact = await FlutterContacts.getContact(CallerID[0]["id"]);
      Calls[CurrentCallIndex]["Avatar"] = contact?.photoOrThumbnail;
      emit(ContactByidSuccess());
    }
    emit(ContactByidNull());
  }

  List CallNotes = [];
  List CallNotesUpdate = [];
  int CurrentCallIndex =0;
  Future<void> listenSensor() async {
    streamSubscription = ProximitySensor.events.listen((int event) {
        _isNear = (event > 0) ? true : false;
        bool ScreenOff = false;
        print("proximity: "+_isNear.toString());
        if(_isNear ==true && ScreenOff == false) {
          invokeNativeMethod("ScreenOff");
          ScreenOff = true;
          emit(ScreenRefresh());
        }
        if(_isNear ==false && ScreenOff ==true) {
        invokeNativeMethod("ScreenOn");
        emit(ScreenRefresh());
      }

    });
  }

  bool ContactIdExist=false;

  void InCallNotes() {
    CallNotes=[];
      ContactNotes.forEach((e) {
        if (e["id"] == CallerID[0]["id"]) {
          ContactIdExist=true;
          CallNotes = e["Notes"]
              .replaceAll("[", "")
              .replaceAll("]", "")
              .split(',');
        }
      });

      if(ContactIdExist==false)
      {
        ContactNotes.add({
          "id":CallerID[0]["id"],
          "Notes" : ""
        });
        ContactNotes.forEach((e) {
          if (e["id"] == CallerID[0]["id"]) {
            ContactIdExist=true;
            CallNotes = e["Notes"]
                .replaceAll("[", "")
                .replaceAll("]", "")
                .split(',');
          }
        });

      }
      ContactIdExist=false;

  }

  bool InCallMsg = false;

  void ActivateInCallMsg() {
    InCallMsg = !InCallMsg;
    print(InCallMsg);
    emit(ScreenRefresh());
  }

  void SendInCallMsg(String Msg) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(CallerappID)
        .set({
      "InCallMessage": Msg,

    },
      SetOptions(merge: true),
    ).then((value) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(token)
          .set({
        "InCallMessage": Msg,

      },
        SetOptions(merge: true),
      );
    }
    );
    emit(ScreenRefresh());
  }

  void CreateCallingSession(String UserPhoneNumber) {
    FirebaseFirestore.instance
        .collection("CallingSession")
        .doc(UserPhoneNumber.replaceAll(" ", "") + "-" +
        PhoneNumberQuery!.replaceAll(" ", ""))
        .set({
      "UserToken": token,
      "recipientToken": null,

    },
      SetOptions(merge: true),
    );
  }

  void OnRecivedCallingSession(String UserPhoneNumber) {
    FirebaseFirestore.instance
        .collection("CallingSession")
        .doc(PhoneNumberQuery!.replaceAll(" ", "").replaceAll("+", "") + "-" +
        UserPhoneNumber.replaceAll(" ", "")).get().then((docs) {
      if (docs.exists) {
        FirebaseFirestore.instance
            .collection("CallingSession")
            .doc(
            PhoneNumberQuery!.replaceAll(" ", "").replaceAll("+", "") + "-" +
                UserPhoneNumber.replaceAll(" ", ""))
            .set({
          "recipientToken": token,

        },
          SetOptions(merge: true),
        );
      } else {
        Future.delayed(Duration(seconds: 1), () {
          FirebaseFirestore.instance
              .collection("CallingSession")
              .doc(
              PhoneNumberQuery!.replaceAll(" ", "").replaceAll("+", "") + "-" +
                  UserPhoneNumber.replaceAll(" ", ""))
              .set({
            "recipientToken": token,

          },
            SetOptions(merge: true),
          );
        });
      }
    });
  }

  void ClearCallingSession(String UserPhoneNumber) {
    FirebaseFirestore.instance
        .collection("CallingSession")
        .doc(UserPhoneNumber.replaceAll(" ", "") + "-" +
        PhoneNumberQuery!.replaceAll(" ", "").replaceAll("+", ""))
        .delete();

    FirebaseFirestore.instance
        .collection("CallingSession")
        .doc(PhoneNumberQuery!.replaceAll(" ", "").replaceAll("+", "") + "-" +UserPhoneNumber.replaceAll(" ", "")
        )
        .delete();
    SendInCallMsg("");
  }


  void CallerAppID(UserPhoneNumber) {
    FirebaseFirestore.instance
        .collection("CallingSession")
        .doc(UserPhoneNumber.replaceAll(" ", "") + "-" +
        PhoneNumberQuery!.replaceAll(" ", "").replaceAll("+", ""))
        .snapshots()
        .listen((event) {

      CallerappID = event.data()?["recipientToken"];


    });
  }


}

class NativePhoneEvent {
  /// Underlying call ID assigned by the device.
  /// android: always null
  /// ios: a uuid
  /// others: ??
  String? state;

  /// If available, the phone number being dialed.
  String? phoneNumber;

  /// The type of call event.
  String? type;

  NativePhoneEvent(Map<String,dynamic>json){
    state = json["state"];
    phoneNumber = json["phoneNumber"];
    type = json["type"];
  }


}