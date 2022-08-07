
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialer_app/Components/components.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/Modules/Phone/Cubit/cubit.dart';
import 'package:dialer_app/NativeBridge/native_bridge.dart';
import 'package:dialer_app/NativeBridge/native_states.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:dialer_app/Themes/Cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../Modules/profile/Profile Cubit/profile_cubit.dart';
import '../Network/Local/cache_helper.dart';
import '../home.dart';
import '../main.dart';
import 'Cubit/cubit.dart';


class InCallScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var Cubit = NativeBridge.get(context);

    return BlocProvider.value(
      value:NativeBridge.get(context)..GetCallerID(PhoneContactsCubit.get(context).Contacts)..GetContactByID()..InCallNotes()..listenSensor(),
      child: BlocConsumer<NativeBridge, NativeStates>(
          listener: (context, state) {
            if(state is PhoneStateDialing)
              {


              }
            if(state is PhoneStateRinging ){
              Cubit.isRinging = true;


            }
            if(state is PhoneStateActive ){
              NativeBridge.get(context).isRinging = false;
             _StopWatchTimer.onExecute.add(StopWatchExecute.start);
             Cubit.isStopWatchStart = true;
              // AppCubit.get(context).GetCallerID(Cubit.PhoneNumberQuery,true);

            }
            if(state is PhoneStateDisconnected)
              {

                _StopWatchTimer.onExecute.add(StopWatchExecute.reset);
                Cubit.isStopWatchStart =false;
                PhoneLogsCubit.get(context).PhoneRange =true;
                NativeBridge.get(context).contact=null;
                NativeBridge.get(context).CallNotes.clear();
                Cubit.ClearCallingSession(ProfileCubit.get(context).CurrentUser[0].phone.toString());

                NativeBridge.get(context).streamSubscription.cancel();
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) => Home()),
                      (Route<dynamic>route)=>false,);

              }

          },
          builder: (context, state) {
            if(NativeBridge.get(context).PhoneNumberQuery==null )
            {
              Future.delayed(Duration(seconds: 5),(){
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) => Home()),
                      (Route<dynamic>route)=>false,);
              });

            }
            // NativeBridge.get(context).GetCallerID();
            // AppCubit.get(context).GetCallerID();
            return Scaffold(
              backgroundColor: HexColor("#2C087A"),
              body: WillPopScope(
                onWillPop: () async{
                  if(Navigator.of(context).canPop())
                  {
                    return true;
                  } else {
                    NativeBridge.get(context).invokeNativeMethod("sendToBackground");
                    return false;
                  }
                },
                child: Stack(
                  children: [
                    ThemeCubit.get(context).InCallBackGroundImagePicker !=null?Padding(
                  padding:  EdgeInsets.only(top:double.parse(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackgroundVerticalPading"])),
                  child: Container(
                    height: double.parse(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackgroundHeight"]),
                    width: double.infinity,
                    decoration:  BoxDecoration(
                      image: DecorationImage(
                        image: ImageSwap(ThemeCubit.get(context).InCallBackGroundImagePicker),
                        fit: BoxFit.cover,
                        opacity: double.parse(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackgroundOpacity"]),
                      ),
                    ),
                  ),
                ):Container(

                      height: double.parse(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackgroundHeight"]),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/Images/blue purple wave.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Column(

                          mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                height: (MediaQuery.of(context).padding.top + MediaQuery.of(context).size.height)*0.11,
                              ),

                              Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Container(
                                      child: NativeBridge.get(context).contact?.thumbnail != null && NativeBridge.get(context).contact!.thumbnail!.isNotEmpty?CallerPhoto(NativeBridge.get(context).contact?.thumbnail):CircleAvatar(
                                        backgroundColor: HexColor("#545454"),
                                        radius: 45,
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
                                    NativeBridge.get(context).contact?.thumbnail != null && NativeBridge.get(context).contact!.thumbnail!.isNotEmpty?Container():Icon(
                                      Icons.person,
                                      color: HexColor("#D1D1D1"),
                                      size: 50,
                                    ),
                                    OnlineStates(),
                                  ]),
                              const SizedBox(height: 8),
                              CallStatesText(),
                              CallerID(context),
                              CallerPhoneNumber(context),
                              StreamBuilder<int>(
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
                                    return Cubit.isRinging == false?Text("Duration :"+displayTime , style: TextStyle(height: 0.8),):Text("");
                                  } else return Text("");
                                  },
                              ), //
                              // Cubit.isRinging == false?  StopWatchTimer.getDisplayTime(value): Text(""),
                          // MediaQuery:Above Quick Replay Adjust for Diff. Screens
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          // NativeBridge.get(context).isShowen==false?InCallMessages(context):Container(),
                              StreamBuilder<DocumentSnapshot>(
                                  stream: CurrentUserStream,
                                  builder: (context,snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text("Loading");
                                    }
                                    final data = snapshot..requireData;
                                    NativeBridge.get(context).CallerAppID(data.data!["phone"]);

                                    return Column(children: [
                                      data.data!["InCallMessage"]!= ""?Row(
                                        children: [
                                          Expanded(child: Column(children: [Text("CALL REASON"),Text(data.data?["InCallMessage"],style: TextStyle(fontSize: 15,color: Colors.white),),],)),
                                        ],
                                      ):Container(height: MediaQuery.of(context).size.height*0.05,),
                                      Padding(
                                        padding:  EdgeInsets.only(right: NativeBridge.get(context).InCallMsg||NativeBridge.get(context).ExpandeNotes?0:19),
                                        child: Row(
                                          mainAxisAlignment: NativeBridge.get(context).InCallMsg?MainAxisAlignment.center:MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [

                                            NativeBridge.get(context).ExpandeNotes==false?InCallMessages(context):Container(),
                                            NativeBridge.get(context).ExpandeNotes==false?NativeBridge.get(context).InCallMsg?Container():NativeBridge.get(context).contact!=null?Container(width: 1,height: 30,color: Colors.white,):Container():Container(),
                                            NativeBridge.get(context).InCallMsg?Container():NativeBridge.get(context).contact!=null?ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: NativeBridge.get(context).ExpandeNotes?MediaQuery.of(context).size.height*0.43:77,
                                                // maxHeight: NativeBridge.get(context).ExpandeNotes?MediaQuery.of(context).size.height*0.43:77,
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  IconButton(onPressed: (){
                                                    //TODO: implement in call NOTES

                                                    NativeBridge.get(context).NotesToggle();
                                                  }, icon: Icon(Icons.note),iconSize: 28,color: HexColor("#E4E4E4"),),
                                                  Text("Notes",style: TextStyle(height: 0.6),),

                                                  NativeBridge.get(context).ExpandeNotes?IconButton(onPressed: (){
                                                    //TODO: implement in call NOTES

                                                    NativeBridge.get(context).AddNewNote();
                                                  }, icon: Icon(Icons.note_add),iconSize: 28,color: HexColor("#E4E4E4"),):Container(),
                                                  NativeBridge.get(context).ExpandeNotes?Text("Add",style: TextStyle(height: 0.6),):Container(),
                                                ],
                                              ),
                                            ):Container(),

                                            NativeBridge.get(context).InCallMsg?Container():NativeBridge.get(context).contact!=null?AnimatedSize(
                                                curve:Curves.easeIn,
                                                duration: Duration(seconds: 1),
                                                child: Container(
                                                    width: NativeBridge.get(context).ExpandeNotes?MediaQuery.of(context).size.width*0.83:0,height: NativeBridge.get(context).ExpandeNotes?MediaQuery.of(context).size.height*0.43:0,color:Colors.white.withOpacity(0.50) ,
                                                    child:NativeBridge.get(context).NewNote?Padding(
                                                      padding: const EdgeInsets.only(right:15.0,left:15.0,top: 8.0),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: MediaQuery.of(context).size.height*0.34,
                                                            child: TextFormField(
                                                              maxLines: null,
                                                              keyboardType: TextInputType.multiline,
                                                              style: TextStyle(
                                                                fontFamily: "OpenSans",
                                                                fontSize: 12,
                                                              ),
                                                              controller: PhoneContactsCubit.get(context).NotesController,
                                                              textAlign:TextAlign.start,
                                                              textAlignVertical: TextAlignVertical.center,

                                                              decoration: InputDecoration(
                                                                border:InputBorder.none,
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              IconButton(onPressed: (){

                                                              }, icon: Icon(Icons.delete),iconSize: 28,color: HexColor("#E4E4E4"),),
                                                              IconButton(
                                                                onPressed: (){
                                                                  NativeBridge.get(context).CallNotes.add(PhoneContactsCubit.get(context).NotesController.text.trim());
                                                                  print(NativeBridge.get(context).CallNotes);
                                                                  ContactNotes.forEach((element) {
                                                                    if(element["id"] == NativeBridge.get(context).CallerID[0]["id"]){

                                                                      element["Notes"]=NativeBridge.get(context).CallNotes.toString();
                                                                    }
                                                                  });
                                                                  CacheHelper.saveData(key: "Notes", value: json.encode(ContactNotes));
                                                                  NativeBridge.get(context).CallNotesUpdate.add(NativeBridge.get(context).CallerID[0]["id"]);
                                                                  NativeBridge.get(context).AddNewNote();
                                                                }, icon: Icon(Icons.task_alt),iconSize: 28,color: HexColor("#E4E4E4"),),

                                                            ],)
                                                        ],
                                                      ),
                                                    ):Container(child:ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:NativeBridge.get(context).CallNotes.length ,
                                                        itemBuilder: (context,index) {
                                                          return ListTile(
                                                            title:Text(NativeBridge.get(context).CallNotes[index].toString()),
                                                          );
                                                        })))):Container(),
                                            // Column(
                                            //   children: [
                                            //     IconButton(onPressed: (){
                                            //       //TODO: implement in call Recording
                                            //     }, icon: Icon(Icons.keyboard_voice,),iconSize: 28,color: HexColor("#E4E4E4"),),
                                            //     Text("Record",style: TextStyle(height: 0.6),),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],);
                                  }
                              )

                        ]),
                        WidgetsBinding.instance.window.viewInsets.bottom > 0.0?Container():SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: InCallButtons(context, Cubit.isRinging)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  CircleAvatar CallerPhoto(Uint8List? avatar) => CircleAvatar(backgroundImage:MemoryImage(avatar!),radius: 45,);



 final  StopWatchTimer _StopWatchTimer = StopWatchTimer(
   mode: StopWatchMode.countUp,
   presetMillisecond: StopWatchTimer.getMilliSecFromMinute(0), // millisecond => minute.
   // onChange: (value) => ),
   // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
   // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
 );




  final Stream<DocumentSnapshot> CurrentUserStream = FirebaseFirestore.instance.collection('Users').doc(token).snapshots();
  Widget InCallMessages(context) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [

        NativeBridge.get(context).InCallMsg?Container():Padding(
          padding: const EdgeInsets.only(right: 8.0,bottom: 21),
          child: Column(
            children: [
              IconButton(
                onPressed: (){
                NativeBridge.get(context).ActivateInCallMsg();
              },
                icon: Icon(Icons.perm_phone_msg,size: 30,),

              ),
              Text("Call Reason",style: TextStyle(height: 0.8),),
            ],
          ),
        ),

        AnimatedSize(
          alignment: AlignmentDirectional.topStart,
          curve:Curves.easeOut,
          duration: const Duration(seconds: 2),
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: NativeBridge.get(context).InCallMsg?MediaQuery.of(context).size.width-70:0,
            height: 51,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: HexColor("#707070"), width: 2),
              color: HexColor("#D4D4D4"),
            ),
            child: Row(
                children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, top: 5, right: 2),
                child: IconButton(
                  onPressed: (){
                    NativeBridge.get(context).ActivateInCallMsg();
                  },
                  icon: Icon(Icons.perm_phone_msg,size: 30,),

                )
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
                  child: TextField(
                    controller: NativeBridge.get(context).CallReasonController,
                    onSubmitted: (value){
                      NativeBridge.get(context).SendInCallMsg(value);
                      NativeBridge.get(context).CallReasonController.clear();
                      NativeBridge.get(context).proximity();
                    },
                  )),
                  Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.only(topRight: Radius.circular(6),bottomRight:Radius.circular(6)),
                        // shape: BoxShape.circle,
                        color:Colors.black26,
                      ),
                      child: IconButton(

                        highlightColor:Colors.red ,onPressed: (){
                        NativeBridge.get(context).SendInCallMsg(NativeBridge.get(context).CallReasonController.text);
                        NativeBridge.get(context).CallReasonController.clear();
                        NativeBridge.get(context).proximity();
                      }, icon: Transform.rotate(
                          angle:-95,
                          child: Icon(Icons.send_rounded,)),)),
            ]),
          ),
        ),

      ],
    );
  }


  Row CallerID(context) {
    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(NativeBridge.get(context).CallerID.isNotEmpty?NativeBridge.get(context).CallerID[0]["CallerID"].toString():"",
                                style: TextStyle(
                                  fontFamily: "ZenKurenaido-Regular",
                                  color: HexColor("#F5F5F5"),
                                  fontSize: 25,
                                )),
                          ),
                        ],
                      );
  }

  Center CallerPhoneNumber(context) {
    return Center(
                          child: Text(
                              NativeBridge.get(context).PhoneNumberQuery.toString(),
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

  Column InCallButtons(BuildContext context  , isRinging ) {
    return isRinging?Column(
      mainAxisAlignment: MainAxisAlignment.end,
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
                          NativeBridge.get(context).isRinging = false;
                          NativeBridge.get(context).invokeNativeMethod("AcceptCall",null);
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
          height: (MediaQuery.of(context).size.height +  MediaQuery.of(context).padding.bottom) * 0.06,
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
    NativeBridge.get(context).isShowen?InCallDialpad(context, 0 , AppCubit.get(context).dialerController):Column(
      mainAxisAlignment: MainAxisAlignment.start,
          children: [


            NativeBridge.get(context).ExpandeNotes==false?Padding(
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
                              NativeBridge.get(context).invokeNativeMethod("SpeakerToggle",null);
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
            ):Container(),
            NativeBridge.get(context).ExpandeNotes==false?Column(
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
                            NativeBridge.get(context).inCallDialerToggle();
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
                            NativeBridge.get(context)
                                .invokeNativeMethod("RejectCall",null);
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
                  height:(MediaQuery.of(context).size.height +  MediaQuery.of(context).padding.bottom) * 0.04,
                ),
                TextButton(
                  onPressed: (){
                    // Cubit.UpdateCallerID();
                    print(NativeBridge.get(context).contact?.name.toString());
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
            ):Container(),
          ]
        );
  }
}



