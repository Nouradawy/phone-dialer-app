
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


  bool EndCallisActive = false;
  static const RejectCall = MethodChannel("RejectCallMethod");


  Future<void> RejectCallA() async{
    setState(() {
      EndCallisActive = !EndCallisActive ;
    });

    print(EndCallisActive.toString());
      await RejectCall.invokeMethod("EndCall").then((value) {
        print(value.toString());
      }).catchError((error) {
        print(error.toString());
      });

  }


  @override
  void initState() {
    super.initState();
    _phoneEvents = _accumulate(FlutterPhoneState.phoneCallEvents);
    _rawEvents = _accumulate(FlutterPhoneState.rawPhoneEvents);

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


  @override
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
                        const SizedBox(height: 120,),
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

                              // FlutterVoipKit.endCall(uuid);
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
  Widget GetPhoneNumber({required final PhoneCall phoneCall}) {
    // if (phoneCall.status == PhoneCallStatus.ringing) {}

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



