
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/NativeBridge/native_bridge.dart';
import 'package:dialer_app/NativeBridge/native_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';


class InCallScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var Cubit = NativeBridge.get(context);
    return BlocProvider.value(
      value:Cubit..phonestateEvents,
      child: BlocConsumer<NativeBridge, NativeStates>(
          listener: (context, state) {
            if(state is PhoneStateRinging || state is PhoneStateDisconnected){
              Cubit.isRinging = true;
            }
            // if(state is PhoneStateConnecting ){
            //   Cubit.isRinging = false;
            // }
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
                        height: 280,
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
                          /* 1st spacer */
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                          ),

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
                                OnlineStates(),
                              ]),
                          const SizedBox(height: 8),
                           CallStatesText(),
                          CallerPhoneNumber(),
                          CallerID(context)
                        ],
                      ),
                    ],
                  ),
                  Cubit.isRinging == false?Text("00:54",style: TextStyle(fontFamily: "cairo",fontWeight: FontWeight.w500 , fontSize: 15 , color:HexColor("#FFFFFF").withOpacity(0.70)),):Text(""),
                  // MediaQuery:Above Quick Replay Adjust for Diff. Screens
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  InCallMessages(),
                  SizedBox(
                    /*MediaQuery:Above answer and decline buttons Adjust for Diff. Screens*/

                    height: Cubit.isRinging == true?MediaQuery.of(context).size.height * 0.20:MediaQuery.of(context).size.height * 0.01,
                  ),
                  InCallButtons(context, Cubit.isRinging),
                  SizedBox(
                    /*MediaQuery:Above answer and decline buttons Adjust for Diff. Screens*/

                    height: Cubit.isRinging == true?MediaQuery.of(context).size.height * 0.08:MediaQuery.of(context).size.height * 0.04,
                  ),

                  /*MediaQuery:Above Swipe to send message Adjust for Diff. Screens*/
                  SizedBox(height: MediaQuery.of(context).size.height*0.04,),
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
          }),
    );
  }

  Stack InCallMessages() {
    return Stack(
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
              );
  }

  Row CallerPhoneNumber() {
    return Row(
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
                      );
  }

  Center CallerID(BuildContext context) {
    return Center(
                          child: Text(
                              "${NativeBridge.get(context).nativePhoneEvent?.phoneNumber}",
                              style: TextStyle(
                                fontFamily: "Cairo",
                                fontWeight: FontWeight.w300,
                                color: HexColor("#C8C8C8"),
                                fontSize: 25,
                                letterSpacing: -1,
                                height: 1.6,
                              )));
  }

  Text CallStatesText() {
    return Text("Call from",
                          style: TextStyle(
                            fontFamily: "OpenSans",
                            color: Colors.white,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                          ));
  }

  Container OnlineStates() {
    return Container(
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
                            );
  }

  Column InCallButtons(BuildContext context  , isRinging) {
    return isRinging?Column(
      children: [
        Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        // customBorder: CircleBorder(),
                        onTap: () {
                          NativeBridge.get(context)
                              .invokeNativeMethod("RejectCall");
                        },
                        child: CircleAvatar(
                          radius: 43,
                          backgroundColor: HexColor("#FC5757"),
                          child: Image.asset("assets/Images/call_end.png", scale: 4.1,),
                        ),
                      ),
                      const SizedBox(
                        width: 159,
                      ),
                      InkWell(
                        customBorder: CircleBorder(),
                        onTap: () {
                          NativeBridge.get(context).isRinging = false;
                          NativeBridge.get(context)
                              .invokeNativeMethod("AcceptCall");
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
      ],
    ):
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.note_add),iconSize: 28,color: HexColor("#E4E4E4"),),
                      Text("Notes",style: TextStyle(height: 0.6),),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.keyboard_voice,),iconSize: 28,color: HexColor("#E4E4E4"),),
                      Text("Record",style: TextStyle(height: 0.6),),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration:BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width:1,color:HexColor("#FFFFFF"),),
                        ) ,
                        child: CircleAvatar(
                          backgroundColor: HexColor("#464646"),
                            radius: 31,
                            child: IconButton(onPressed: (){
                              NativeBridge.get(context)
                                  .invokeNativeMethod("SpeakerToggle");
                            }, icon: Icon(Icons.volume_up),iconSize: 37,color: HexColor("#E4E4E4"),)),
                      ),
                      Text("Speaker",),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration:BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width:1,color:HexColor("#FFFFFF"),),
                        ) ,
                        child: CircleAvatar(
                          backgroundColor: HexColor("#464646"),
                            radius: 31,
                            child: IconButton(onPressed: (){
                              NativeBridge.get(context)
                                  .invokeNativeMethod("MicToggle");

                            }, icon: Icon(Icons.volume_mute),iconSize: 37,color: HexColor("#E4E4E4"),)),
                      ),
                      Text("Mute",),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration:BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width:1,color:HexColor("#FFFFFF"),),
                        ) ,
                        child: CircleAvatar(
                          backgroundColor: HexColor("#464646"),
                            radius: 31,
                            child: IconButton(onPressed: (){
                              NativeBridge.get(context)
                                  .invokeNativeMethod("HoldToggle");
                            }, icon: Icon(Icons.pause),iconSize: 37,color: HexColor("#E4E4E4"),)),
                      ),
                      Text("Hold",),
                    ],
                  ),


                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    Container(
                      decoration:BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width:1,color:HexColor("#FFFFFF"),),
                      ) ,
                      child: CircleAvatar(
                        backgroundColor: HexColor("#464646"),
                        radius: 31,
                        child: Image.asset("assets/Images/dialpad.png",scale: 1.4,color: HexColor("#EEEEEE"),),
                      ),
                    ),
                    Text("Keypad",),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration:BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width:1,color:HexColor("#FFFFFF"),),
                      ) ,
                      child: CircleAvatar(
                        backgroundColor: HexColor("#464646"),
                          radius: 31,
                          child: IconButton(onPressed: (){}, icon: Icon(Icons.person_add),iconSize: 37,color: HexColor("#E4E4E4"),)),
                    ),
                    Text("Add",),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap:(){

                      },
                      child: CircleAvatar(
                          backgroundColor: HexColor("#FC5757"),
                            radius: 31,
                            child: Image.asset("assets/Images/call_end.png",scale:6),
                        ),
                    ),

                    Text("End",),
                  ],
                ),


              ],
            ),
          ]
        );
  }
}



