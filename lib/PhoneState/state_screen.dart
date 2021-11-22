
import 'dart:math';
import 'package:dialer_app/Components/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_state/extensions_static.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:flutter_phone_state/phone_event.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'dart:async';


import 'package:hexcolor/hexcolor.dart';


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
  static const MethodChannel RejectCall = MethodChannel("RejectCallMethod");



  static Future<void> RejectCallA() async{
      return await RejectCall.invokeMethod("EndCall").then((value) {

      }).catchError((error) {

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
      backgroundColor: HexColor("#2C087A"),
      body:
      SafeArea(
        child: Expanded(
          child: Column(
                  children: [

                    Stack(
                      children:
                      [
                        ///Background image Container

                      Container(
                        height: 320,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/Images/blue purple wave.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                            ),///1st spacer
                            Stack(
                                alignment: AlignmentDirectional.center,
                                children:[
                                  Container(
                                    child: BlendMask(
                                      blendMode: BlendMode.lighten,
                                      child: CircleAvatar(backgroundColor: HexColor("#545454"),
                                        radius: 60,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2,
                                        color: HexColor("#F8F8F8").withOpacity(0.69),
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.person,
                                    color: HexColor("#D1D1D1"),
                                    size: 100,),
                                  Container(
                                    width: 180,
                                    height: 100,
                                    child: Align(
                                      alignment: AlignmentDirectional.bottomEnd,
                                      child: Stack(
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
                                              fontWeight: FontWeight.w300,
                                            )),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                            const SizedBox(height: 8),
                            const Text("Call from",style:TextStyle(
                              fontFamily: "OpenSans",
                              color: Colors.white,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,

                            )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: BlendMask(
                                    blendMode: BlendMode.difference,
                                    child: Text("Ahmed Mohammed".toUpperCase(),style: TextStyle(
                                      fontFamily: "ZenKurenaido-Regular",
                                      color: HexColor("#F5F5F5"),
                                      fontSize: 25,

                                    )),
                                  ),
                                ),
                              ],
                            ),
                            for (final call in FlutterPhoneState.activeCalls)
                              GetPhoneNumber(phoneCall: call),
                            if (FlutterPhoneState.activeCalls.isEmpty)
                              Center(child:
                              Text("02-33841909",style: TextStyle(
                                fontFamily: "Cairo",
                                fontWeight: FontWeight.w300,
                                color: HexColor("#C8C8C8"),
                                fontSize: 25,
                                letterSpacing: -1,
                                height: 1.6,
                              )))
                          ],
                        ),
                      ),
                      ],
                    ),
                    // MediaQuery:Above Quick Replay Adjust for Diff. Screens
                    SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                    Stack(
                      children:
                      [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Container(
                            height: 51,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(10),
                                topEnd: Radius.circular(10),
                              ),
                              border: Border.all(color:HexColor("#707070"),width:2),
                              color: HexColor("#D4D4D4"),
                            ),
                          ),
                        ),

                        Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:48.0,top:5,right: 7),

                                child: InkWell(
                                    onTap: (){},
                                    child: Image.asset("assets/Images/Chatting_Logo.png",scale: 2.5,)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:0,right: 8 ),
                                child: Container(
                                  height:51,
                                  width: 1.5,
                                  color:HexColor("#707070"),
                                ),
                              ),
                              Expanded(child: Text("Please accept my Sincere apologize",style: TextStyle(fontFamily: "Cairo",fontSize: 12),)),
                              Padding(
                                padding: const EdgeInsets.only(right:48.0,top:6),
                                child: InkWell(
                                    onTap:(){
                                    },
                                    child: Image.asset("assets/Images/quickreply_black_48dp.png",scale:2.4)),
                              ),]
                        ),
                      ],
                    ),
                    SizedBox(
                      // MediaQuery:Above answer and decline buttons Adjust for Diff. Screens
                      height: MediaQuery.of(context).size.height * 0.22,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          customBorder: CircleBorder(),
                          onTap: (){

                            // FlutterVoipKit.endCall(uuid);
                            RejectCallA();
                          },
                          child: CircleAvatar(
                            radius: 43,
                            backgroundColor: HexColor("#FC5757"),
                            child:Image.asset("assets/Images/call_end.png",scale: 4.1,),
                          ),

                        ),
                        const SizedBox(width: 159,),
                        InkWell(
                          customBorder: CircleBorder(),
                            onTap:(){
                              FlutterPhoneDirectCaller.callNumber("0233841909");
                            },
                          child: CircleAvatar(
                            backgroundColor: HexColor("#2AD181"),
                            radius: 43,
                            child: Image.asset("assets/Images/call_black_36dp.png",scale:3.9),),

                        ),
                      ],
                    ),
                    SizedBox(height: 2,),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                      Text("Decline",style: TextStyle(
                        color: HexColor("#B1B1B1").withOpacity(0.70),
                        fontFamily: "Cairo",
                        fontSize: 12,
                      ),),
                      SizedBox(width:209),
                      Text("Answer",style: TextStyle(
                        color: HexColor("#B1B1B1").withOpacity(0.70),
                        fontFamily: "Cairo",
                        fontSize: 12,
                      ),),
                    ],),
                    // MediaQuery:Above Swipe to send message Adjust for Diff. Screens
                    SizedBox(height: MediaQuery.of(context).size.height*0.14,),
                    Text("Swipe up to Send message",style: TextStyle(
                      color: HexColor("#B1B1B1").withOpacity(0.70),
                      fontFamily: "Cairo",
                      fontSize: 12,
                    ),),
                    SizedBox(height:7),
                    Container(width: 120,
                    height: 1,
                    color: HexColor("#B4B4B4").withOpacity(0.49)),

                  ]
              ),
        ),

      ),
    );

  }
  Widget GetPhoneNumber({required final PhoneCall phoneCall}) {
    // if (phoneCall.status == PhoneCallStatus.ringing) {}

    return Column(
      children: [
        Text("${phoneCall.phoneNumber ?? "Unknown number"}",style: TextStyle(
          fontFamily: "ZenKurenaido",
          color: HexColor("#F5F5F5"),
          fontSize: 25,
        )),
        const SizedBox(height: 10),
        // Text("${value(phoneCall.status)}",style: TextStyle(
        //     fontFamily: "ZenKurenaido-Regular",
        //     color: HexColor("#26BF5E"),
        //     fontSize: 23)),
        // const SizedBox(height: 60,),
      ],
    );
  }

}



