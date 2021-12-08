
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/NativeBridge/native_bridge.dart';
import 'package:dialer_app/NativeBridge/native_states.dart';
import 'package:dialer_app/PhoneState/phone_events_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hexcolor/hexcolor.dart';


class InCallScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NativeBridge, NativeStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: HexColor("#2C087A"),
            body: SafeArea(
              child: Column(children: [
                Stack(
                  children: [
                    ///Background image Container
                    Container(
                      height: 320,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/Images/blue purple wave.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                        ),

                        ///1st spacer
                        Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                child: BlendMask(
                                  blendMode: BlendMode.lighten,
                                  child: CircleAvatar(
                                    backgroundColor: HexColor("#545454"),
                                    radius: 60,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 2,
                                    color:
                                        HexColor("#F8F8F8").withOpacity(0.69),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.person,
                                color: HexColor("#D1D1D1"),
                                size: 100,
                              ),
                              Container(
                                width: 180,
                                height: 100,
                                child: Align(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 1.3),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              HexColor("#23DB54"),
                                          radius: 5,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Text("Avilable".toUpperCase(),
                                            style: TextStyle(
                                              fontFamily:
                                                  "ZenKurenaido-Regular",
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
                        const Text("Call from",
                            style: TextStyle(
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
                                child: Text("Ahmed Mohammed".toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: "ZenKurenaido-Regular",
                                      color: HexColor("#F5F5F5"),
                                      fontSize: 25,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Center(
                            child: Text(
                                "${NativeBridge.get(context).nativePhoneEvent?.phoneNumber}",
                                style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontWeight: FontWeight.w300,
                                  color: HexColor("#C8C8C8"),
                                  fontSize: 25,
                                  letterSpacing: -1,
                                  height: 1.6,
                                )))
                      ],
                    ),
                  ],
                ),
                // MediaQuery:Above Quick Replay Adjust for Diff. Screens
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Container(
                        height: 51,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: HexColor("#707070"), width: 2),
                          color: HexColor("#D4D4D4"),
                        ),
                      ),
                    ),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 48.0, top: 5, right: 7),
                        child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                              "assets/Images/Chatting_Logo.png",
                              scale: 2.5,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, right: 8),
                        child: Container(
                          height: 51,
                          width: 1.5,
                          color: HexColor("#707070"),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        "Please accept my Sincere apologize",
                        style: TextStyle(fontFamily: "Cairo", fontSize: 12),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(right: 48.0, top: 6),
                        child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                                "assets/Images/quickreply_black_48dp.png",
                                scale: 2.4)),
                      ),
                    ]),
                  ],
                ),
                // SizedBox(
                //   // MediaQuery:Above answer and decline buttons Adjust for Diff. Screens
                //   height: MediaQuery.of(context).size.height * 0.20,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      // customBorder: CircleBorder(),
                      onTap: () {
                        NativeBridge.get(context)
                            .invokeNativeMethod("RejectCall");
                        // RejectCallA();
                      },
                      child: CircleAvatar(
                        radius: 43,
                        backgroundColor: HexColor("#FC5757"),
                        child: Image.asset(
                          "assets/Images/call_end.png",
                          scale: 4.1,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 159,
                    ),
                    InkWell(
                      customBorder: CircleBorder(),
                      onTap: () {
                        FlutterPhoneDirectCaller.callNumber("111");
                      },
                      child: CircleAvatar(
                        backgroundColor: HexColor("#2AD181"),
                        radius: 43,
                        child: Image.asset(
                            "assets/Images/call_black_36dp.png",
                            scale: 3.9),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text("Decline",style: TextStyle(
                    //   color: HexColor("#B1B1B1").withOpacity(0.70),
                    //   fontFamily: "Cairo",
                    //   fontSize: 12,
                    // ),),
                    // SizedBox(width:209),
                    ElevatedButton(
                        onPressed: () {
                          NativeBridge.get(context)
                              .invokeNativeMethod("num1");
                        },
                        child: Text("1")),
                    ElevatedButton(
                        onPressed: () {
                          NativeBridge.get(context)
                              .invokeNativeMethod("AcceptCall");
                        },
                        child: Text("accept")),
                    ElevatedButton(
                        onPressed: () {
                          NativeBridge.get(context)
                              .invokeNativeMethod("MicToggle");
                        },
                        child: Text("micMute")),
                    ElevatedButton(
                        onPressed: () {
                          NativeBridge.get(context)
                              .invokeNativeMethod("SpeakerToggle");
                        },
                        child: Text("Speaker")),
                    ElevatedButton(
                        onPressed: () {
                          // HoldUnHold();
                          NativeBridge.get(context)
                              .invokeNativeMethod("HoldToggle");
                        },
                        child: Text("hold")),
                    Text(
                      "Answer",
                      style: TextStyle(
                        color: HexColor("#B1B1B1").withOpacity(0.70),
                        fontFamily: "Cairo",
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                // MediaQuery:Above Swipe to send message Adjust for Diff. Screens
                // SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                Text(
                  "Swipe up to Send message",
                  style: TextStyle(
                    color: HexColor("#B1B1B1").withOpacity(0.70),
                    fontFamily: "Cairo",
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 7),
                Container(
                    width: 120,
                    height: 1,
                    color: HexColor("#B4B4B4").withOpacity(0.49)),
              ]),
            ),
          );
        });
  }
}



