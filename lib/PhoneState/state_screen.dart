
import 'dart:developer' as dev;
import 'dart:math';
import 'package:dialer_app/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_state/extensions_static.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:flutter_phone_state/phone_event.dart';

import 'dart:async';


import 'package:flutter_voip_kit/call_manager.dart';

import 'package:hexcolor/hexcolor.dart';

import 'package:flutter_voip_kit/call.dart';
import 'package:flutter_voip_kit/flutter_voip_kit.dart';
import 'package:uuid/uuid.dart';



class PhoneStateScreen extends StatefulWidget {
  const PhoneStateScreen({Key? key}) : super(key: key);

  @override
  _PhoneStateScreenState createState() => _PhoneStateScreenState();
}

class _PhoneStateScreenState extends State<PhoneStateScreen> {
  late List<RawPhoneEvent> _rawEvents;
  late List<PhoneCallEvent> _phoneEvents;
  List<Call> calls = [];
  bool hasPermission = false;
  bool callShouldFail = false;
  String? phoneid;
  late final String uuid;
  bool Endcall =false;
  static const RejectCall = MethodChannel("RejectCallMethod");

  @override
  void initState() {
    super.initState();
    _phoneEvents = _accumulate(FlutterPhoneState.phoneCallEvents);
    _rawEvents = _accumulate(FlutterPhoneState.rawPhoneEvents);


    FlutterVoipKit.init(
        callStateChangeHandler: callStateChangeHandler,
        callActionHandler: callActionHandler);

    FlutterVoipKit.callListStream.listen((allCalls) {
      setState(() {
        calls = allCalls;
      });
    });
  }

  Future<bool> callStateChangeHandler(call) async {
    dev.log("widget call state changed lisener: $call");
    setState(
            () {}); //calls states have been updated, setState so ui can reflect that

    //it is important we perform logic and return true/false for every CallState possible
    switch (call.callState) {
      case CallState
          .connecting: //simulate connection time of 3 seconds for our VOIP service
        dev.log("--------------> Call connecting");
        await Future.delayed(const Duration(seconds: 3));
        return true;
      case CallState
          .active: //here we would likely begin playig audio out of speakers
        dev.log("--------> Call active");
        return true;
      case CallState.ended: //end audio, disconnect
        dev.log("--------> Call ended");
        await Future.delayed(const Duration(seconds: 1));
        return true;
      case CallState.failed: //cleanup
        dev.log("--------> Call failed");
        return true;
      case CallState.held: //pause audio for specified call
        dev.log("--------> Call held");
        return true;
      default:
        return false;
    }
  }

  Future<bool> callActionHandler(Call call, CallAction action) async {
    dev.log("widget call action handler: $call");
    setState(
            () {}); //calls states have been updated, setState so ui can reflect that

    //it is important we perform logic and return true/false for every CallState possible
    switch (action) {
      case CallAction.muted:
      //EXAMPLE: here we would perform the logic on our end to mute the audio streams between the caller and reciever
        return true;
        break;
      default:
        return false;
    }
  }


  List<R> _accumulate<R>(Stream<R?> input) {
    final items = <R>[];
    input.forEach((item) {
      if (item != null) {
        setState(() {
          items.add(item);
        });
      }
    });
    return items;
  }

  // Iterable<PhoneCall> get _completedCalls => Map.fromEntries(_phoneEvents.reversed.map((PhoneCallEvent event) {
  //   return MapEntry(event.call.id, event.call);
  // })).values.where((c) => c.isComplete).toList();


  Widget build(BuildContext context) {
    // RejectCallA();
    return Scaffold(
      backgroundColor: HexColor("#010A0A"),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {

            return Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/Images/blue purple wave.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 120,),
                        Stack(
                            alignment: AlignmentDirectional.center,
                            children:[
                              Container(
                                child: CircleAvatar(backgroundColor: HexColor("#545454"),
                                  radius: 60,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: HexColor("#F8F8F8"),
                                  ),
                                ),
                              ),
                              Icon(Icons.person,
                                color: HexColor("#D1D1D1"),
                                size: 70,),
                            ]),
                        const SizedBox(height: 10,),
                        Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment:AlignmentDirectional.topEnd,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: BlendMask(
                                        blendMode: BlendMode.difference,
                                        child: Text("Ahmed Mohammed".toUpperCase(),style: TextStyle(
                                          fontFamily: "ZenKurenaido-Regular",
                                          color: HexColor("#F5F5F5"),
                                          fontSize: 25,
                                        )),
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top:1.3),
                                          child: CircleAvatar(backgroundColor: HexColor("#23DB54"),radius: 5,),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:12.0),
                                          child: Text("Avilable".toUpperCase(),style: TextStyle(
                                            fontFamily: "ZenKurenaido-Regular",
                                            color: HexColor("#00B3A6"),
                                            fontSize: 10,
                                          )),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                          ],

                        ),
                        for (final call in FlutterPhoneState.activeCalls)
                          GetPhoneNumber(phoneCall: call),
                        if (FlutterPhoneState.activeCalls.isEmpty)
                          Center(child: const Text("No Active Calls")),
                      ],
                    ),

                  ),
                  Stack(
                    children:
                    [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Image.asset("assets/Images/Rectangle 10.png"),
                      ),

                      Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:48.0,top:12,right: 5),

                              child: InkWell(
                                  onTap: (){},
                                  child: Image.asset("assets/Images/speaker_notes_black_36dp.png",scale: 2.7,)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:5,right: 5 ),
                              child: Container(
                                height:45,
                                width: 1.5,
                                color:HexColor("#707070"),
                              ),
                            ),
                            Expanded(child: Text("Type here ...")),
                            Padding(
                              padding: const EdgeInsets.only(right:48.0,top:4.5),
                              child: InkWell(
                                  onTap:(){
                                  },
                                  child: Image.asset("assets/Images/quickreply_black_48dp.png",scale:2.4)),
                            ),]
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:190.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: HexColor("#FC5757"),
                            child:Image.asset("assets/Images/call_end.png",scale: 3.5,),),
                          onTap: (){
                              // Endcall = !Endcall ;
                              // print(Endcall.toString());
                              // FlutterVoipKit.endCall(uuid);
                            Future<void> RejectCallA() async{
                              try{
                                await RejectCall.invokeMethod("RejectCallA");

                              } on PlatformException catch (e){
                                print("Error on Rejection: ${e.message}");

                              }
                            }
                              RejectCallA();

                          },
                        ),
                        const SizedBox(width: 165,),
                        CircleAvatar(
                          backgroundColor: HexColor("#23DB54"),
                          radius: 45,
                          child: Image.asset("assets/Images/call_black_36dp.png",scale:3),),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    child: Text("Simlualate incoming call"),
                    onPressed: () {
                      Future.delayed(const Duration(seconds: 2)).then((value) {
                        FlutterVoipKit.reportIncomingCall(
                            handle: "${Random().nextInt(10)}" * 9,
                            uuid: Uuid().v4());
                      });
                    },
                  ),
                ]
            );
          },
        ),
      ),
    );

  }

  _initiateCall() {
      setState(() {
        FlutterPhoneState.startPhoneCall("0233841909");
      });
  }
  Future CallsHandel({required final PhoneCall phoneCall}) async {
    print("End call button :   "+Endcall.toString());
    if (phoneCall.status == PhoneCallStatus.ringing) {
      // phoneCall.eventStream;
      phoneid = "${truncate(phoneCall.id, 12)}";
      uuid=Uuid().v4();
      print("uuid on Creation :  $uuid");
      final call = Call(
          address: phoneid.toString(),
          outgoing: false,
          callState: CallState.incoming,
          uuid:uuid,
      );
      CallManager().addCall(call);
      await callStateChangeHandler(call..callState = CallState.incoming);

    }
  }
  Widget GetPhoneNumber({required final PhoneCall phoneCall}) {

    CallsHandel(phoneCall: phoneCall);
    return Column(
      children: [
        Text("${phoneCall.phoneNumber ?? "Unknown number"}",style: TextStyle(
          fontFamily: "ZenKurenaido-Regular",
          color: HexColor("#F5F5F5"),
          fontSize: 25,
        )),
        const SizedBox(height: 10),
        Text("${value(phoneCall.status)}",style: TextStyle(
            fontFamily: "ZenKurenaido-Regular",
            color: HexColor("#26BF5E"),
            fontSize: 23)),
        const SizedBox(height: 60,),
      ],
    );
  }

}


// class _CallCard extends StatelessWidget {
//   final PhoneCall? phoneCall;
//
//   const _CallCard({Key? key, this.phoneCall}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Text("+${phoneCall?.phoneNumber ?? "Unknown number"}: ${value(phoneCall?.status)}");
//   }
// }


