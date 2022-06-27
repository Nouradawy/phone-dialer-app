
import 'dart:io';

import 'package:dialer_app/Components/components.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Phone/Cubit/cubit.dart';
import 'package:dialer_app/NativeBridge/native_bridge.dart';
import 'package:dialer_app/NativeBridge/native_states.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../Layout/Cubit/cubit.dart';
import '../../Network/Local/shared_data.dart';
import '../../home.dart';
import '../Cubit/cubit.dart';
import '../theme_config.dart';


class InCallScreenEdit extends StatefulWidget {

  @override
  State<InCallScreenEdit> createState() => _InCallScreenEditState();
}

class _InCallScreenEditState extends State<InCallScreenEdit> {
  bool InCallBackGround = false;
  bool BackgroundColorPicker  = false;
  bool CallerIDColorPicker = false;
  bool PhoneNumberColorPicker = false;
  bool PhoneStateColorPicker = false;

  @override
  Widget build(BuildContext context) {
    var Cubit = NativeBridge.get(context);

    return Scaffold(
      backgroundColor: ThemeCubit.get(context).InCallBackgroundColor,
      body: InCallBackGround == false?Stack(
        alignment: AlignmentDirectional.topStart,
        children: [

          ThemeCubit.get(context).InCallBackGroundImagePicker !=null?Padding(
            padding:  EdgeInsets.only(top:ThemeCubit.get(context).InCallBackgroundVerticalPading),
            child: Container(
              height: ThemeCubit.get(context).InCallBackgroundHeight,
              width: double.infinity,
              decoration:  BoxDecoration(
                image: DecorationImage(
                  image: ImageSwap(ThemeCubit.get(context).InCallBackGroundImagePicker),
                  fit: BoxFit.cover,
                  opacity: ThemeCubit.get(context).InCallBackgroundOpacity,
                ),
              ),
            ),
          ):Padding(
            padding:  EdgeInsets.only(top:ThemeCubit.get(context).InCallBackgroundVerticalPading),
            child: Container(
              decoration:  const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/Images/blue purple wave.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 20,
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
                Stack(

                  children: [
                    CallerID(context),
                    Align(
                      alignment: AlignmentDirectional.center,
                      child:
                      Padding(
                        padding:  EdgeInsets.only(left:MediaQuery.of(context).size.width/2),
                        child: InkWell(
                            onTap:(){
                              setState((){
                                CallerIDColorPicker = !CallerIDColorPicker;
                              });
                            },
                            child: CircleAvatar( backgroundColor:Colors.black45,radius:15,child:Icon(Icons.edit,size:15))),
                      ),

                    ),
                  ],
                ),
                Stack(
                  children: [
                    CallerPhoneNumber(context),
                    Align(
                      alignment: AlignmentDirectional.center,
                      child:
                      Padding(
                        padding:  EdgeInsets.only(left:MediaQuery.of(context).size.width/2),
                        child: InkWell(
                            onTap:(){
                              setState((){
                                PhoneNumberColorPicker = !PhoneNumberColorPicker;
                              });
                            },
                            child: CircleAvatar( backgroundColor:Colors.black45,radius:15,child:Icon(Icons.edit,size:15))),
                      ),

                    ),
                  ],
                ),

                Builder(
                    builder: (context) {
                      return StreamBuilder<int>(
                        stream: _StopWatchTimer.rawTime,
                        builder: (context,snap) {



                          if(NativeBridge.get(context).isStopWatchStart == true)
                          {
                            final value =snap.data;
                            bool? Hours;
                            bool? Minutes;

                            if (StopWatchTimer.getRawHours(value!) <= 1)
                            {
                              Hours = false;
                            } else Hours=true;
                            var displayTime = StopWatchTimer.getDisplayTime(value,hours:Hours,minute: true, milliSecond: false);
                            return Cubit.isRinging == false?Text(displayTime):Text("");
                          } else return Text("");


                        },
                      );
                    }
                ),
                // Cubit.isRinging == false?  StopWatchTimer.getDisplayTime(value): Text(""),
                // MediaQuery:Above Quick Replay Adjust for Diff. Screens
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                InCallMessages(),
                SizedBox(
                  /*MediaQuery:Above answer and decline buttons Adjust for Diff. Screens*/
                  height: Cubit.isRinging == true?MediaQuery.of(context).size.height * 0.15:MediaQuery.of(context).size.height * 0.01,
                ),
                InCallButtons(context, Cubit.isRinging),

              ]),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Padding(
              padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top+10 ,right:20),
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  InkWell(
                    onTap:(){
                      setState((){
                        InCallBackGround = !InCallBackGround;
                      });
                    },
                      child: CircleAvatar( backgroundColor:Colors.black45,radius:20,child:Icon(Icons.image))),

              CircleAvatar( backgroundColor:Colors.blue,radius:8,child:Icon(Icons.edit,size: 10,)),
                ],
              ),
            ),
          ),
          CallerIDColorPicker?Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                  height: MediaQuery.of(context).size.height/2,
                  color:Colors.black45,
                child:ColorPicker(
                  // enableOpacity: true,
                  // Use the screenPickerColor as start color.
                  color: ThemeCubit.get(context).CallerIDcolor,
                  // Update the screenPickerColor using the callback.
                  pickersEnabled: const <ColorPickerType,bool>{
                    ColorPickerType.custom: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.wheel: true,
                  },
                  onColorChangeEnd: (color) {
                    setState((){
                      ThemeCubit.get(context).CallerIDcolor = color;
                    });


                  },
                  width: 30,
                  height: 30,
                  borderRadius: 22,
                  heading: const Text(
                    'Select color',
                  ),
                  subheading: const Text(
                    'Select color shade',
                  ), onColorChanged: (Color value) {  },
                ),
              )
          ):Container(),
          PhoneNumberColorPicker?Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                  height: MediaQuery.of(context).size.height/2,
                  color:Colors.black45,
                child:ColorPicker(
                  // enableOpacity: true,
                  // Use the screenPickerColor as start color.
                  color: ThemeCubit.get(context).CallerIDPhoneNumbercolor,
                  // Update the screenPickerColor using the callback.
                  pickersEnabled: const <ColorPickerType,bool>{
                    ColorPickerType.custom: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.wheel: true,
                  },
                  onColorChangeEnd: (color) {
                    setState((){
                      ThemeCubit.get(context).CallerIDPhoneNumbercolor = color;
                    });


                  },
                  width: 30,
                  height: 30,
                  borderRadius: 22,
                  heading: const Text(
                    'Select color',
                  ),
                  subheading: const Text(
                    'Select color shade',
                  ), onColorChanged: (Color value) {  },
                ),
              )
          ):Container(),
        ],
      ):InkWell(
        onTap: (){
          setState((){
            InCallBackGround = !InCallBackGround;
          });
        },
        child: Stack(
          // alignment: AlignmentDirectional.bottomCenter,
          children: [
            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: ThemeCubit.get(context).InCallBackGroundImagePicker !=null?Padding(
                padding:  EdgeInsets.only(top:ThemeCubit.get(context).InCallBackgroundVerticalPading),
                child: Container(
                  height: ThemeCubit.get(context).InCallBackgroundHeight,
                  width: double.infinity,
                  decoration:  BoxDecoration(
                    image: DecorationImage(
                      image: ImageSwap(ThemeCubit.get(context).InCallBackGroundImagePicker),
                      fit: BoxFit.cover,
                      opacity: ThemeCubit.get(context).InCallBackgroundOpacity,
                    ),
                  ),
                ),
              ):Padding(
                padding:  EdgeInsets.only(top:ThemeCubit.get(context).InCallBackgroundVerticalPading),
                child: Container(
                  height: ThemeCubit.get(context).InCallBackgroundHeight,
                  width: double.infinity,
                  decoration:  const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/Images/blue purple wave.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                  alignment: AlignmentDirectional.bottomCenter,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: AlignmentDirectional.bottomCenter,
                    height: BackgroundColorPicker?MediaQuery.of(context).size.height:MediaQuery.of(context).size.height/3,
                    color: Colors.white.withOpacity(0.07),
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Select background Image : "),
                            MaterialButton(onPressed: () async {

                              ThemeCubit.get(context).InCallBackgroundFilePicker = await ImagePicker().pickImage(source: ImageSource.gallery);
                              if(ThemeCubit.get(context).InCallBackgroundFilePicker !=null ) {
                                final imagePermanent = await SaveImagePermanently(ThemeCubit.get(context).InCallBackgroundFilePicker.path);
                                setState((){
                                  ThemeCubit.get(context).InCallBackGroundImagePicker = imagePermanent;
                                });

                                //TODO:Spleting Uploading the image from Profile image Picker Due to the image will be Uploaded without User Concent

                              }
                              // print(DialPadBackgroundShared);
                            },
                              child: Text("Browse"),
                              color:Colors.black45,
                              textColor: Colors.white,
                            )
                          ],
                        ),
                        Slider(value: ThemeCubit.get(context).InCallBackgroundHeight,
                            max:MediaQuery.of(context).size.height,
                            divisions: 90,
                            label:ThemeCubit.get(context).InCallBackgroundHeight.round().toString(),
                            onChanged: ( value) {
                              setState((){
                                ThemeCubit.get(context).InCallBackgroundHeight = value;
                              });

                            }),
                        Slider(value: ThemeCubit.get(context).InCallBackgroundVerticalPading,
                            max:MediaQuery.of(context).size.height,
                            divisions: 90,
                            label:ThemeCubit.get(context).InCallBackgroundVerticalPading.round().toString(),
                            onChanged: ( value) {
                              setState((){
                                ThemeCubit.get(context).InCallBackgroundVerticalPading = value;
                              });

                            }),
                        Slider(value: ThemeCubit.get(context).InCallBackgroundOpacity,
                            max: 1,
                            min:0,
                            divisions: 100,
                            label:ThemeCubit.get(context).InCallBackgroundOpacity.round().toString(),
                            onChanged: ( value) {
                              setState((){
                                ThemeCubit.get(context).InCallBackgroundOpacity = value;
                              });

                            }),
                        MaterialButton(onPressed: (){
                          setState((){
                            BackgroundColorPicker = !BackgroundColorPicker;
                          });
                        },
                        child: Column(
                          children: [
                            Text("Background color"),
                            Text("v")
                          ],
                        ),),
                      BackgroundColorPicker ?ColorPicker(
                          // enableOpacity: true,
                          // Use the screenPickerColor as start color.
                          color: ThemeCubit.get(context).InCallBackgroundColor,
                          // Update the screenPickerColor using the callback.
                          pickersEnabled: const <ColorPickerType,bool>{
                            ColorPickerType.custom: true,
                            ColorPickerType.accent: true,
                            ColorPickerType.wheel: true,
                          },
                          onColorChangeEnd: (color) {
                            setState((){
                              ThemeCubit.get(context).InCallBackgroundColor = color;
                            });


                          },
                          width: 30,
                          height: 30,
                          borderRadius: 22,
                          heading: const Text(
                            'Select color',
                          ),
                          subheading: const Text(
                            'Select color shade',
                          ), onColorChanged: (Color value) {  },
                        ):Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }

 final  StopWatchTimer _StopWatchTimer = StopWatchTimer(
   mode: StopWatchMode.countUp,
   presetMillisecond: StopWatchTimer.getMilliSecFromMinute(0), // millisecond => minute.
   // onChange: (value) => ),
   // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
   // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
 );

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

  Row CallerID(context) {
    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: BlendMask(
                              blendMode: BlendMode.difference,
                              child: Text("Caller ID",
                                  style: TextStyle(
                                    fontFamily: "ZenKurenaido-Regular",
                                    color: ThemeCubit.get(context).CallerIDcolor,
                                    fontSize: ThemeCubit.get(context).CallerIDfontSize,
                                  )),
                            ),
                          ),
                        ],
                      );
  }

  Center CallerPhoneNumber(context) {
    return Center(
                          child: Text(
                              "01029788995",
                              style: TextStyle(
                                fontFamily: "Cairo",
                                fontWeight: FontWeight.w300,
                                color: ThemeCubit.get(context).CallerIDPhoneNumbercolor,
                                fontSize: ThemeCubit.get(context).CallerIDPhoneNumberfontSize,
                                letterSpacing: -1,
                                height: 1.6,
                              )));
  }

  Text CallStatesText() {
    return Text("Call from",
                          style: TextStyle(
                            fontFamily: "OpenSans",
                            color: ThemeCubit.get(context).InCallPhoneStateColor,
                            fontSize: ThemeCubit.get(context).InCallPhoneStateSize,
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
                          NativeBridge.get(context).invokeNativeMethod("RejectCall",null);

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

                          //TODO: AcceptCall Button ( you can add function for onTap)
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
          /*MediaQuery:Above answer and decline buttons Adjust for Diff. Screens*/
          height: (MediaQuery.of(context).size.height +  MediaQuery.of(context).padding.bottom) * 0.04,
        ),
        TextButton(
          onPressed: (){
            // Cubit.UpdateCallerID();
          },
          child: Text(
            "Swipe up to Send message",
            style: TextStyle(
              color: HexColor("#B1B1B1").withOpacity(0.70),
              fontFamily: "Cairo",
              fontSize: 12,
            ),
          ),
        ),
        Container(
            width: 120,
            height: 1,
            color: HexColor("#B4B4B4").withOpacity(0.49)),
      ],
    ):
    AppCubit.get(context).isShowen?InCallDialpad(context, 0 , AppCubit.get(context).dialerController):Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      IconButton(onPressed: (){
                        //TODO: implement in call NOTES

                      }, icon: Icon(Icons.note_add),iconSize: 28,color: HexColor("#E4E4E4"),),
                      Text("Notes",style: TextStyle(height: 0.6),),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: (){
                        //TODO: implement in call Recording
                      }, icon: Icon(Icons.keyboard_voice,),iconSize: 28,color: HexColor("#E4E4E4"),),
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
                                  .invokeNativeMethod("SpeakerToggle",null);
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
                                  .invokeNativeMethod("MicToggle",null);

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
                                  .invokeNativeMethod("HoldToggle",null);
                            }, icon: Icon(Icons.pause),iconSize: 37,color: HexColor("#E4E4E4"),)),
                      ),
                      Text("Hold",),
                    ],
                  ),


                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      children: [
                        InkWell(
                           // highlightColor:Colors.red,
                          splashColor: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          onTap: (){
                            AppCubit.get(context).dialpadShow();
                          },
                          child: Container(
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
                          child: InkWell(
                            splashColor: Colors.red,
                            onTap: (){
                              //TODO: Setup Confrence calls
                            },
                            child: CircleAvatar(
                              backgroundColor: HexColor("#464646"),
                                radius: 31,
                                child: IconButton(onPressed: (){}, icon: Icon(Icons.person_add),iconSize: 37,color: HexColor("#E4E4E4"),)),
                          ),
                        ),
                        Text("Add",),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          splashColor: Colors.blue,
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
                SizedBox(
                  /*MediaQuery:Above answer and decline buttons Adjust for Diff. Screens*/
                  height: (MediaQuery.of(context).size.height +  MediaQuery.of(context).padding.bottom) * 0.07,
                ),
                TextButton(
                  onPressed: (){
                    // Cubit.UpdateCallerID();
                  },
                  child: Text(
                    "Swipe up to Send message",
                    style: TextStyle(
                      color: HexColor("#B1B1B1").withOpacity(0.70),
                      fontFamily: "Cairo",
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                    width: 120,
                    height: 1,
                    color: HexColor("#B4B4B4").withOpacity(0.49)),
              ],
            ),
          ]
        );
  }
}





