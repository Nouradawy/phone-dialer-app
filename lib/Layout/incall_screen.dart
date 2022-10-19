
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:action_slider/action_slider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialer_app/Components/components.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Phone/Cubit/cubit.dart';
import 'package:dialer_app/NativeBridge/native_bridge.dart';
import 'package:dialer_app/NativeBridge/native_states.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:dialer_app/Themes/Cubit/cubit.dart';
import 'package:dialer_app/Themes/Cubit/states.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../Components/constants.dart';
import '../Modules/profile/Profile Cubit/profile_cubit.dart';
import '../Network/Local/cache_helper.dart';
import '../Notifications/notifications_controller.dart';
import '../Themes/theme_config.dart';
import '../home.dart';
import 'Cubit/cubit.dart';


class InCallScreen extends StatelessWidget {
  ReceivedAction? receivedAction;

  @override
  Widget build(BuildContext context) {
    var Cubit = NativeBridge.get(context);
    var themeCubit = ThemeCubit.get(context);
    return BlocProvider.value(
      ///CallerAPPID Uses Info from FireBase Added if null option in case the current user Logged in as a Guest or no connection to the internet
      value:NativeBridge.get(context)..listenSensor()..CallerAppID(ProfileCubit.get(context).CurrentUser.isNotEmpty?ProfileCubit.get(context).CurrentUser.first.phone.toString():null)..CheckInternetConnection(),
      child: BlocConsumer<NativeBridge, NativeStates>(
          listener: (context, state) {
            if(state is PhoneStateHolding)
              {


              }

            if(state is PhoneStateRinging ){
              // Cubit.CheckInternetConnection();
              Cubit.isRinging = true;
              ///TODO:Re-enable this for signed in users
              // Cubit.InternetisConnected==true?Cubit.OnRecivedCallingSession(ProfileCubit.get(context).CurrentUser[0].phone.toString()):null;
                NativeBridge.get(context).GetCallerID(PhoneContactsCubit.get(context).Contacts);
                NativeBridge.get(context).Calls.add({
                  "PhoneNumber" : NativeBridge.get(context).PhoneNumberQuery,
                  "DisplayName" : NativeBridge.get(context).CallerID.isNotEmpty?NativeBridge.get(context).CallerID[0]["CallerID"]:"",
                  "Avatar" : null,
                  "PhoneState" : "Ringing",
                  "CallerAppID" : null,
                });
              Cubit.GetContactByID();
                // NativeBridge.get(context).Calls.removeAt(NativeBridge.get(context).CurrentCallIndex==1?0:1);
              Cubit.CurrentCallIndex=NativeBridge.get(context).Calls.length-1;

              Cubit.CallDuration.add(StopWatchTimer(
                mode: StopWatchMode.countUp,
                presetMillisecond: StopWatchTimer.getMilliSecFromMinute(0),
                // millisecond => minute.
                // onChange: (value) => ),
                // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
                // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
              ));

            }

            if(state is PhoneStateActive ){

              NativeBridge.get(context).isRinging = false;
              NativeBridge.get(context).MergedOrRinging=false;
              Cubit.Calls[Cubit.CurrentCallIndex]["PhoneState"]="Active";
              Cubit.OnConference==true?Cubit.ConferenceTimer.onExecute.add(StopWatchExecute.start):Cubit.CallDuration[ Cubit.CurrentCallIndex].onExecute.add(StopWatchExecute.start);
              Cubit.isStopWatchStart = true;
              print("Calls from ActiveState : " + Cubit.Calls.toString());
              // AppCubit.get(context).GetCallerID(Cubit.PhoneNumberQuery,true);

            }
            if(state is PhoneStateDisconnected && NativeBridge.get(context).MergedOrRinging==false) {
              // Cubit.isStopWatchStart =false;
              // _StopWatchTimer.onExecute.add(StopWatchExecute.reset);
              // NativeBridge.get(context).contact=null;



              if (Cubit.Calls.length > 1  || Cubit.ConferenceCalls.isNotEmpty) {
                if (Cubit.OnConference == true) {
                  Cubit.ConferenceCalls.clear();
                  Cubit.OnConference = false;
                  Cubit.ConferenceTimer.onExecute.add(StopWatchExecute.reset);
                } else {
                  if (Cubit.ConferenceCalls.isNotEmpty) {
                    Cubit.OnConference = true;
                  }
                  isGuest==false?Cubit.ClearCallingSession(ProfileCubit.get(context).CurrentUser[0].phone.toString()):null;
                  Cubit.CurrentCallIndex = Cubit.CurrentCallIndex == 0 ? 1 : 0;
                  Cubit.Calls.removeAt(Cubit.CurrentCallIndex == 0 ? 1 : 0);
                  Cubit.CallDuration.removeAt(Cubit.CurrentCallIndex == 0 ? 1 : 0);


                }
              } else {
                PhoneLogsCubit.get(context).PhoneRange = true;
                NativeBridge.get(context).streamSubscription.cancel();
                ///TODO:Re-enable this for signed in users
                isGuest==false?Cubit.ClearCallingSession(ProfileCubit.get(context).CurrentUser[0].phone.toString()):null;

                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) => Home()),
                      (Route<dynamic> route) => false,
                );
              }
            }

          },
          builder: (context, state) {
            if(isRejected==true)
              {
                Cubit.MergedOrRinging = false;
                Cubit.invokeNativeMethod("RejectCall", null);
                isRejected=false;
              }
              if(ThemeCubit.get(context).ThemeEditorIsActive==true)
                {
                  Cubit.isRinging=false;
                }
            if(NativeBridge.get(context).Calls.length==2)
            {
              AddMerge = true;
              HoldSwap =true;
            }
            if(NativeBridge.get(context).Calls.length==1){

              if(NativeBridge.get(context).ConferenceCalls.isNotEmpty){
                AddMerge = true;
                HoldSwap =true;

              } else
              {
                HoldSwap =false;
                AddMerge = false;
              }
            }
            if(NativeBridge.get(context).Calls.isEmpty && NativeBridge.get(context).OnConference == true)
            {
              HoldSwap =false;
              AddMerge = false;
            }
            return Scaffold(
              resizeToAvoidBottomInset: false,

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
                    BackgroundImage(context,themeCubit),
                    Opacity(
                      opacity: Cubit.BackGroundCustomize==false?1:0.5,
                      child: SafeArea(
                        child: Stack(
                          alignment: themeCubit.InCallButtonReColorActive?AlignmentDirectional.topCenter:AlignmentDirectional.bottomEnd,
                          children: [

                            OnHoldBanner(Cubit ,context),
                            Cubit.isRinging==true?Align(
                              alignment: AlignmentDirectional.center,
                              child: Transform.translate(
                                  offset: Offset(0,MediaQuery.of(context).size.height*0.15),
                                  child: Text("Swap up to answer")),
                            ):Container(),
                            Cubit.isRinging==true?Align(
                              alignment: AlignmentDirectional.center,
                              child: Transform.translate(
                                  offset: Offset(0,MediaQuery.of(context).size.height*0.44),
                                  child: Text("Swap down to decline")),
                            ):Container(),
                            SingleChildScrollView(child: InCallButtons(context, Cubit.isRinging ,Cubit,themeCubit)),
                            ///Avatar and callReson,Notes Section hide when Recolor is active
                            themeCubit.InCallButtonReColorActive==false?Cubit.ConferenceManage==false?Column(
                              // mainAxisSize: MainAxisSize.max,
                                children: [
                            SizedBox(
                                    height: (MediaQuery.of(context).padding.top + MediaQuery.of(context).size.height)*0.11,
                                  ),

                                  ContactAvatar(Cubit,themeCubit),
                                  const SizedBox(height: 8),
                                  CallStatesText(),
                                  CallerID(context,Cubit,themeCubit),
                                  Cubit.OnConference==true?Container():CallerPhoneNumber(context,Cubit,themeCubit),
                                  NativeBridge.get(context).isStopWatchStart == true?ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 50
                                    ),
                                    child: StreamBuilder<int>(
                                      stream: Cubit.OnConference==true?Cubit.ConferenceTimer.rawTime:Cubit.CallDuration[Cubit.CurrentCallIndex].rawTime,
                                      builder: (context,snap) {
                                        if(snap.hasError)
                                          {
                                            return Text("something wrong");
                                          }
                                          final value =snap.data;
                                          bool? Hours;
                                          bool? Minutes;

                                          if (StopWatchTimer.getRawHours(value!=null?value:0) <= 1)
                                          {
                                            Hours = false;
                                          } else Hours=true;
                                          var displayTime = StopWatchTimer.getDisplayTime(value!=null?value:0,hours:Hours,minute: true, milliSecond: false);
                                          return Cubit.isRinging == false?Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Cubit.Calls[Cubit.CurrentCallIndex]["PhoneState"]=="Calling"?Text("${Cubit.Calls[Cubit.CurrentCallIndex]["PhoneState"]} ", style: TextStyle(height: 0.8),):Text(""),
                                              Cubit.Calls[Cubit.CurrentCallIndex]["PhoneState"]=="Calling"?Lottie.asset("assets/Loader_v4.json",width: 50):Text(""),
                                              Cubit.Calls[Cubit.CurrentCallIndex]["PhoneState"]=="Active"?Transform.translate(
                                                  offset:Offset(0, -2),
                                                  child: Icon(Icons.phone,color:HexColor("#36FF72").withOpacity(0.80), size: 17 )):Text(""),
                                              Cubit.Calls[Cubit.CurrentCallIndex]["PhoneState"]=="Active"?Text(" $displayTime" , style: TextStyle(height: 0.8 , color: HexColor("#36FF72").withOpacity(0.80) , fontSize: 15 , fontFamily: "Cairo" , fontWeight: FontWeight.w600)):Text(""),
                                            ],
                                          ):Text("");

                                        },
                                    ),
                                  ):Container(), //

                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.01,
                              ),
                                  isGuest==false?CallResonBar(Cubit):Container(),






                                  Padding(
                                    padding:  EdgeInsets.only(right: NativeBridge.get(context).InCallMsg||NativeBridge.get(context).ExpandeNotes?0:19),
                                    child: Row(
                                      mainAxisAlignment: NativeBridge.get(context).InCallMsg?MainAxisAlignment.center:MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [

                                        themeCubit.ThemeEditorIsActive==true?InCallMessages(context,Cubit):Cubit.ExpandeNotes==false && Cubit.Calls[Cubit.CurrentCallIndex]["CallerAppID"]!=null?InCallMessages(context,Cubit):Container(),
                                        Cubit.ExpandeNotes==false?Cubit.InCallMsg?Container():Cubit.contact!=null?Container(width: 1,height: 30,color: Colors.white,):Container():Container(),
                                        Cubit.InCallMsg?Container():Cubit.contact!=null?ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight: Cubit.ExpandeNotes?MediaQuery.of(context).size.height*0.43:77,
                                            // maxHeight: Cubit.ExpandeNotes?MediaQuery.of(context).size.height*0.43:77,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              IconButton(onPressed: (){
                                                //TODO: implement in call NOTE
                                                Cubit.NotesToggle();
                                              }, icon: Icon(Icons.note),iconSize: 28,color: HexColor("#E4E4E4"),),
                                              Text("Notes",style: TextStyle(height: 0.6),),

                                              Cubit.ExpandeNotes?IconButton(onPressed: (){
                                                //TODO: implement in call NOTES

                                                Cubit.AddNewNote();
                                              }, icon: Icon(Icons.note_add),iconSize: 28,color: HexColor("#E4E4E4"),):Container(),
                                              Cubit.ExpandeNotes?Text("Add",style: TextStyle(height: 0.6),):Container(),
                                            ],
                                          ),
                                        ):Container(),

                                        themeCubit.ThemeEditorIsActive==true?ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight: Cubit.ExpandeNotes?MediaQuery.of(context).size.height*0.43:77,
                                            // maxHeight: Cubit.ExpandeNotes?MediaQuery.of(context).size.height*0.43:77,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              IconButton(onPressed: (){
                                                //TODO: implement in call NOTE
                                                Cubit.NotesToggle();
                                              }, icon: Icon(Icons.note),iconSize: 28,color: HexColor("#E4E4E4"),),
                                              Text("Notes",style: TextStyle(height: 0.6),),

                                              Cubit.ExpandeNotes?IconButton(onPressed: (){
                                                //TODO: implement in call NOTES

                                                Cubit.AddNewNote();
                                              }, icon: Icon(Icons.note_add),iconSize: 28,color: HexColor("#E4E4E4"),):Container(),
                                              Cubit.ExpandeNotes?Text("Add",style: TextStyle(height: 0.6),):Container(),
                                            ],
                                          ),
                                        ):Container(),

                                        Cubit.InCallMsg?Container():Cubit.contact!=null?AnimatedSize(
                                            curve:Curves.easeIn,
                                            duration: Duration(seconds: 1),
                                            child: Container(
                                                width: Cubit.ExpandeNotes?MediaQuery.of(context).size.width*0.83:0,height: Cubit.ExpandeNotes?MediaQuery.of(context).size.height*0.43:0,color:Colors.white.withOpacity(0.50) ,
                                                child:Cubit.NewNote?Padding(
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
                                                              Cubit.contact?.Notes?.add(PhoneContactsCubit.get(context).NotesController.text.trim());

                                                              ContactNotes.forEach((element) {
                                                                if(element["id"] == Cubit.CallerID[0]["id"]){

                                                                  element["Notes"]=Cubit.contact?.Notes.toString();
                                                                }
                                                              });
                                                              CacheHelper.saveData(key: "Notes", value: json.encode(ContactNotes));
                                                              Cubit.AddNewNote();
                                                            }, icon: Icon(Icons.task_alt),iconSize: 28,color: HexColor("#E4E4E4"),),

                                                        ],)
                                                    ],
                                                  ),
                                                ):Container(child:
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:Cubit.contact?.Notes?.length ,
                                                    itemBuilder: (context,index) {
                                                      return ListTile(
                                                        title:Text(Cubit.contact!.Notes!.elementAt(index).toString()),
                                                      );
                                                    }),
                                                ))):Container(),
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

                            ]):Container(
                              alignment: AlignmentDirectional.centerStart,
                              width: double.infinity,child: Column(children: [
                              SizedBox(
                                height: (MediaQuery.of(context).padding.top + MediaQuery.of(context).size.height)*0.15,
                              ),
                              Text("Edit Conference Name : Conferance 1"),

                              TextButton(onPressed: (){}, child: Text("close"))
                            ],),):Container(),

                          ],
                        ),
                      ),
                    ),
                    ///Widget only used to absorb taping over incall buttons
                    Cubit.BackGroundCustomize==true?AbsorbPointer(child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),):Container(),
                    Cubit.BackGroundCustomize==true?GestureDetector(
                      onScaleStart: (details){
                        BackgroundImageH=ThemeCubit.get(context).InCallBackgroundHeight>500?500:ThemeCubit.get(context).InCallBackgroundHeight;
                      },
                      onScaleEnd: (d){
                        BackgroundImageH = ThemeCubit.get(context).InCallBackgroundHeight>500?500:ThemeCubit.get(context).InCallBackgroundHeight;
                      },
                      onScaleUpdate: (details){

                        print("vertical scale :${details.localFocalPoint.dx}");
                        print("rotation :${details.rotation}");
                        // print("padding :${details.scale}");
                        if(details.pointerCount==2){
                          ThemeCubit.get(context).InCallBackgroundHeight=BackgroundImageH*(details.verticalScale);
                          themeCubit.InCallBackgroundRotate = details.rotation;
                        }

                        themeCubit.InCallBackgroundVerticalPading = details.localFocalPoint.dy-BackgroundImageH/2;
                        themeCubit.InCallBackgroundOffsetdx = details.localFocalPoint.dx-MediaQuery.of(context).size.width/2;

                        NativeBridge.get(context).UpdateScreen();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,color: Colors.transparent,
                        child:Column(
                            children: [
                              SafeArea(
                                  child: Align(
                                    alignment: AlignmentDirectional.topEnd,
                                    child: defaultButton(
                                      onPressed: (){
                                        NativeBridge.get(context).BackGroundCustomize =!NativeBridge.get(context).BackGroundCustomize;
                                        NativeBridge.get(context).UpdateScreen();
                                      },
                                      Title: "Apply",
                                      width: 70,
                                      background: Colors.blue,
                                    ),
                                  )),
                            ]),
                      ),
                    ):Container(),

                  ],
                ),
              ),
            );
          }),
    );
  }
double BackgroundImageH=0;

  Column InCallButtons(BuildContext context  , isRinging ,NativeBridge Cubit , ThemeCubit themeCubit) {
    double Screenhight =MediaQuery.of(context).size.height +  MediaQuery.of(context).padding.bottom;
    return isRinging?Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onVerticalDragEnd: (value){
                  if(GesterLocation<=20 && GesterLocation>=-20)
                  {
                    GesterCancel=true;
                    GesterLocation=0;
                  }
                  else{
                    GesterCancel=false;
                  }
                  if(GesterLocation>=70)
                  {
                    Cubit.MergedOrRinging=true;
                    Cubit.isRinging = false;
                    if(Cubit.Calls.length==1)
                    {
                      Cubit.invokeNativeMethod("AcceptCall",null);
                    }
                    if(Cubit.ConferenceCalls.isNotEmpty && Cubit.Calls.length==2)
                    {

                      if(Cubit.OnConference==true)
                      {

                        Cubit.invokeNativeMethod("AcceptCall",null);
                        Cubit.Calls.removeWhere((element) => element["PhoneState"]=="OnHold");
                        Cubit.ConferenceCalls.forEach((element)=> element["PhoneState"]="OnHold");
                        Cubit.OnConference = false;


                      } else{

                        Cubit.invokeNativeMethod("AcceptCall",null);
                        Cubit.ConferenceCalls=[];
                        Cubit.Calls[0]["PhoneState"] = "OnHold";

                      }

                    }
                    if(Cubit.Calls.length==3 && Cubit.OnConference==false)
                    {
                      Cubit.invokeNativeMethod("AcceptCall",null);
                      Cubit.Calls.removeWhere((element) => element["PhoneState"]=="OnHold");
                      Cubit.Calls[Cubit.CurrentCallIndex]["PhoneState"] = "OnHold";
                    }
                  }
                  if(GesterLocation<=-60)
                  {
                    Cubit.MergedOrRinging=false;
                    Cubit.isRinging = false;
                    Cubit.invokeNativeMethod("RejectCall",null);

                  }
                  print(GesterCancel);
                  Cubit.UpdateScreen();
                },

                onVerticalDragStart: (value){
                  GesterCancel=false;
                  GesterStart = value.localPosition.dy;
                  print("Start : $GesterStart");
                  Cubit.UpdateScreen();
                },
                onVerticalDragUpdate: (value){
                  GesterLocation = value.localPosition.dy*-1+GesterStart;
                  print(" Current location : ${GesterLocation}");
                  print((Screenhight * 0.07+GesterLocation));
                  Cubit.UpdateScreen();
                },
                child:ShaderMask(
                  shaderCallback:(bounds)=>RadialGradient(
                    center: Alignment.bottomLeft,
                    radius: AnswerCallColorFeedback(),
                    colors: [

                      HexColor("#2AD181"),
                      HexColor("#0695FF"),
                      HexColor("#FC5757"),
                    ],
                    tileMode: TileMode.clamp,
                  ).createShader(bounds),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 37,
                    child: Transform.rotate(
                        angle: 0.3+((GesterLocation*-1/30)<=-0.3?-0.3:(GesterLocation*-1/30)>=2.04?2.04:(GesterLocation*-1/30)),
                        child: Icon(Icons.phone_rounded)),
                  ),
                )
            ),
          ],
        ),
        SizedBox(
          /*MediaQuery:Above answer and decline buttons Adjust for Diff. Screens*/
          height: GesterCancel==true?Screenhight * 0.15:(Screenhight * 0.15+ GesterLocation) >=220?220:(Screenhight * 0.15+ GesterLocation) <=25?25:(Screenhight * 0.15+GesterLocation),
        ),
        // TextButton(
        //   onPressed: (){
        //     // Cubit.UpdateCallerID();
        //   },
        //   child: Text(
        //     "Swipe up to Send message",
        //     style: TextStyle(
        //       color: HexColor("#B1B1B1").withOpacity(0.70),
        //       fontFamily: "Cairo",
        //       fontSize: 12,
        //     ),
        //   ),
        // ),
        // Container(
        //     width: 120,
        //     height: 1,
        //     color: HexColor("#B4B4B4").withOpacity(0.49)),
      ],
    ):
    Cubit.isShowen?InCallDialpad(context, 0 , AppCubit.get(context).dialerController):Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          themeCubit.InCallButtonReColorActive?SizedBox(height: 40):Container(),
          Cubit.ExpandeNotes==false?Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    Container(
                      child: IconButton(onPressed: (){
                        if(themeCubit.ThemeEditorIsActive==true)
                        {
                          themeCubit.InCallButtonReColorActive =! themeCubit.InCallButtonReColorActive;
                          showModalBottomSheet(
                              isDismissible: false,
                              barrierColor: Colors.transparent,
                              context: context,
                              shape:const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(17),
                                    topLeft: Radius.circular(17)
                                ),
                              ),
                              isScrollControlled: true,
                              builder: (context)
                              {
                                return Container(
                                  height: MediaQuery.of(context).size.height*0.45,
                                  child: DefaultTabController(
                                      length: 2,
                                      child: BlocBuilder<ThemeCubit,ThemeStates>(
                                          builder: (context,state) {
                                            final TabController tabController = DefaultTabController.of(context)!;
                                            tabController.addListener(() {
                                              if (tabController.indexIsChanging) {
                                                print(tabController.index.toString());
                                                themeCubit.ThemeUpdating();
                                              }
                                            });
                                            return Column(
                                              children: [
                                                Container(
                                                  height: 55,
                                                  child: Material(
                                                      color:Colors.deepPurple,
                                                      child:TabBar(
                                                        controller: tabController,
                                                        labelColor: Colors.black,
                                                        labelStyle: const TextStyle(
                                                          fontFamily: "Cairo",
                                                          fontSize: 12,

                                                        ),
                                                        unselectedLabelColor: Colors.white70,
                                                        tabs:[
                                                          Container(
                                                              alignment: AlignmentDirectional.center,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(7),
                                                                color: tabController.index==0?Colors.white:Colors.transparent,
                                                              ),

                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: const [
                                                                  Icon(Icons.toggle_off_outlined),
                                                                  Text("disabled"),
                                                                ],)),
                                                          Container(
                                                              alignment: AlignmentDirectional.center,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(7),
                                                                color: tabController.index==1?Colors.white:Colors.transparent,
                                                              ),

                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: const [
                                                                  Icon(Icons.toggle_on_outlined),
                                                                  Text("enabled"),
                                                                ],)),

                                                        ],)
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  height:  MediaQuery.of(context).size.height*0.33,
                                                  child: TabBarView(
                                                      children: [
                                                        SizedBox(
                                                          width: double.infinity,
                                                          height: MediaQuery.of(context).size.height*0.4,
                                                          child: ColorPicker(
                                                            wheelDiameter: 130,
                                                            wheelSquarePadding: 5,
                                                            wheelSquareBorderRadius:15,
                                                            wheelWidth: 13,
                                                            // enableOpacity: true,
                                                            // Use the screenPickerColor as start color.
                                                            color: themeCubit.InCallButtonsNotactiveColor,
                                                            // Update the screenPickerColor using the callback.
                                                            pickersEnabled: const <ColorPickerType,bool>{
                                                              ColorPickerType.custom: true,
                                                              ColorPickerType.accent: true,
                                                              ColorPickerType.wheel: true,
                                                            },
                                                            onColorChangeEnd: (color) {
                                                              themeCubit.InCallButtonsNotactiveColor = color;
                                                              NativeBridge.get(context).UpdateScreen();
                                                            },
                                                            width: 25,
                                                            height: 25,
                                                            borderRadius: 5,

                                                            subheading: const Align(
                                                              alignment: AlignmentDirectional.centerStart,
                                                              child: Text(
                                                                'shades',
                                                              ),
                                                            ), onColorChanged: (Color value) {  },
                                                          ),

                                                        ),
                                                        SizedBox(
                                                          width: double.infinity,
                                                          height: MediaQuery.of(context).size.height*0.4,
                                                          child: ColorPicker(
                                                            wheelDiameter: 130,
                                                            wheelSquarePadding: 5,
                                                            wheelSquareBorderRadius:15,
                                                            wheelWidth: 13,
                                                            // enableOpacity: true,
                                                            // Use the screenPickerColor as start color.
                                                            color: themeCubit.InCallButtonsActiveColor,
                                                            // Update the screenPickerColor using the callback.
                                                            pickersEnabled: const <ColorPickerType,bool>{
                                                              ColorPickerType.custom: true,
                                                              ColorPickerType.accent: true,
                                                              ColorPickerType.wheel: true,
                                                            },
                                                            onColorChangeEnd: (color) {
                                                              themeCubit.InCallButtonsActiveColor = color;
                                                              NativeBridge.get(context).UpdateScreen();
                                                            },
                                                            width: 25,
                                                            height: 25,
                                                            borderRadius: 5,

                                                            subheading: const Align(
                                                              alignment: AlignmentDirectional.centerStart,
                                                              child: Text(
                                                                'shades',
                                                              ),
                                                            ), onColorChanged: (Color value) {  },
                                                          ),

                                                        ),

                                                      ]),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8.0),
                                                  child: Align(
                                                      alignment: AlignmentDirectional.bottomEnd,
                                                      child: defaultButton(onPressed: (){
                                                        themeCubit.InCallButtonReColorActive = false;
                                                        Navigator.pop(context);
                                                        Cubit.UpdateScreen();
                                                      }, Title: "Apply",background: Colors.deepPurple,width: 80)),
                                                ),
                                              ],
                                            );
                                          }
                                      )),
                                );
                              });
                          Cubit.UpdateScreen();
                        }
                        else
                        {
                          Cubit.invokeNativeMethod("SpeakerToggle", null);
                        }
                      }, icon: Icon(Icons.volume_up_rounded),iconSize: 40,color: ActiveButton(context),),
                    ),
                    Text("Speaker"),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      child: IconButton(onPressed: (){
                        if(themeCubit.ThemeEditorIsActive==true)
                        {
                          themeCubit.InCallButtonReColorActive =! themeCubit.InCallButtonReColorActive;
                          showModalBottomSheet(
                              isDismissible: false,
                              barrierColor: Colors.transparent,
                              context: context,
                              shape:const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(17),
                                    topLeft: Radius.circular(17)
                                ),
                              ),
                              isScrollControlled: true,
                              builder: (context)
                              {
                                return Container(
                                  height: MediaQuery.of(context).size.height*0.45,
                                  child: DefaultTabController(
                                      length: 2,
                                      child: BlocBuilder<ThemeCubit,ThemeStates>(
                                          builder: (context,state) {
                                            final TabController tabController = DefaultTabController.of(context)!;
                                            tabController.addListener(() {
                                              if (tabController.indexIsChanging) {
                                                print(tabController.index.toString());
                                                themeCubit.ThemeUpdating();
                                              }
                                            });
                                            return Column(
                                              children: [
                                                Container(
                                                  height: 55,
                                                  child: Material(
                                                      color:Colors.deepPurple,
                                                      child:TabBar(
                                                        controller: tabController,
                                                        labelColor: Colors.black,
                                                        labelStyle: const TextStyle(
                                                          fontFamily: "Cairo",
                                                          fontSize: 12,

                                                        ),
                                                        unselectedLabelColor: Colors.white70,
                                                        tabs:[
                                                          Container(
                                                              alignment: AlignmentDirectional.center,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(7),
                                                                color: tabController.index==0?Colors.white:Colors.transparent,
                                                              ),

                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: const [
                                                                  Icon(Icons.toggle_off_outlined),
                                                                  Text("disabled"),
                                                                ],)),
                                                          Container(
                                                              alignment: AlignmentDirectional.center,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(7),
                                                                color: tabController.index==1?Colors.white:Colors.transparent,
                                                              ),

                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: const [
                                                                  Icon(Icons.toggle_on_outlined),
                                                                  Text("enabled"),
                                                                ],)),

                                                        ],)
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  height:  MediaQuery.of(context).size.height*0.33,
                                                  child: TabBarView(
                                                      children: [
                                                        SizedBox(
                                                          width: double.infinity,
                                                          height: MediaQuery.of(context).size.height*0.4,
                                                          child: ColorPicker(
                                                            wheelDiameter: 130,
                                                            wheelSquarePadding: 5,
                                                            wheelSquareBorderRadius:15,
                                                            wheelWidth: 13,
                                                            // enableOpacity: true,
                                                            // Use the screenPickerColor as start color.
                                                            color: themeCubit.InCallButtonsNotactiveColor,
                                                            // Update the screenPickerColor using the callback.
                                                            pickersEnabled: const <ColorPickerType,bool>{
                                                              ColorPickerType.custom: true,
                                                              ColorPickerType.accent: true,
                                                              ColorPickerType.wheel: true,
                                                            },
                                                            onColorChangeEnd: (color) {
                                                              themeCubit.InCallButtonsNotactiveColor = color;
                                                              NativeBridge.get(context).UpdateScreen();
                                                            },
                                                            width: 25,
                                                            height: 25,
                                                            borderRadius: 5,

                                                            subheading: const Align(
                                                              alignment: AlignmentDirectional.centerStart,
                                                              child: Text(
                                                                'shades',
                                                              ),
                                                            ), onColorChanged: (Color value) {  },
                                                          ),

                                                        ),
                                                        SizedBox(
                                                          width: double.infinity,
                                                          height: MediaQuery.of(context).size.height*0.4,
                                                          child: ColorPicker(
                                                            wheelDiameter: 130,
                                                            wheelSquarePadding: 5,
                                                            wheelSquareBorderRadius:15,
                                                            wheelWidth: 13,
                                                            // enableOpacity: true,
                                                            // Use the screenPickerColor as start color.
                                                            color: themeCubit.InCallButtonsActiveColor,
                                                            // Update the screenPickerColor using the callback.
                                                            pickersEnabled: const <ColorPickerType,bool>{
                                                              ColorPickerType.custom: true,
                                                              ColorPickerType.accent: true,
                                                              ColorPickerType.wheel: true,
                                                            },
                                                            onColorChangeEnd: (color) {
                                                              themeCubit.InCallButtonsActiveColor = color;
                                                              NativeBridge.get(context).UpdateScreen();
                                                            },
                                                            width: 25,
                                                            height: 25,
                                                            borderRadius: 5,

                                                            subheading: const Align(
                                                              alignment: AlignmentDirectional.centerStart,
                                                              child: Text(
                                                                'shades',
                                                              ),
                                                            ), onColorChanged: (Color value) {  },
                                                          ),

                                                        ),

                                                      ]),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8.0),
                                                  child: Align(
                                                      alignment: AlignmentDirectional.bottomEnd,
                                                      child: defaultButton(onPressed: (){
                                                        themeCubit.InCallButtonReColorActive = false;
                                                        Navigator.pop(context);
                                                        Cubit.UpdateScreen();
                                                      }, Title: "Apply",background: Colors.deepPurple,width: 80)),
                                                ),
                                              ],
                                            );
                                          }
                                      )),
                                );
                              });
                          Cubit.UpdateScreen();
                        }
                        else
                        {
                          Cubit.invokeNativeMethod("MicToggle", null);
                          Cubit.isMuted = !Cubit.isMuted;
                        }
                      }, icon: Icon(Cubit.isMuted ==false?Icons.mic:Icons.mic_off),iconSize: 40,color: ActiveButton(context),),
                    ),
                    Text(Cubit.isMuted ==false?"Mute":"Un mute",),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      child: IconButton(onPressed: (){
                        if(themeCubit.ThemeEditorIsActive==true)
                        {
                          themeCubit.InCallButtonReColorActive =! themeCubit.InCallButtonReColorActive;
                          showModalBottomSheet(
                              isDismissible: false,
                              barrierColor: Colors.transparent,
                              context: context,
                              shape:const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(17),
                                    topLeft: Radius.circular(17)
                                ),
                              ),
                              isScrollControlled: true,
                              builder: (context)
                              {
                                return Container(
                                  height: MediaQuery.of(context).size.height*0.45,
                                  child: DefaultTabController(
                                      length: 2,
                                      child: BlocBuilder<ThemeCubit,ThemeStates>(
                                          builder: (context,state) {
                                            final TabController tabController = DefaultTabController.of(context)!;
                                            tabController.addListener(() {
                                              if (tabController.indexIsChanging) {
                                                print(tabController.index.toString());
                                                themeCubit.ThemeUpdating();
                                              }
                                            });
                                            return Column(
                                              children: [
                                                Container(
                                                  height: 55,
                                                  child: Material(
                                                      color:Colors.deepPurple,
                                                      child:TabBar(
                                                        controller: tabController,
                                                        labelColor: Colors.black,
                                                        labelStyle: const TextStyle(
                                                          fontFamily: "Cairo",
                                                          fontSize: 12,

                                                        ),
                                                        unselectedLabelColor: Colors.white70,
                                                        tabs:[
                                                          Container(
                                                              alignment: AlignmentDirectional.center,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(7),
                                                                color: tabController.index==0?Colors.white:Colors.transparent,
                                                              ),

                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: const [
                                                                  Icon(Icons.toggle_off_outlined),
                                                                  Text("disabled"),
                                                                ],)),
                                                          Container(
                                                              alignment: AlignmentDirectional.center,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(7),
                                                                color: tabController.index==1?Colors.white:Colors.transparent,
                                                              ),

                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: const [
                                                                  Icon(Icons.toggle_on_outlined),
                                                                  Text("enabled"),
                                                                ],)),

                                                        ],)
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  height:  MediaQuery.of(context).size.height*0.33,
                                                  child: TabBarView(
                                                      children: [
                                                        SizedBox(
                                                          width: double.infinity,
                                                          height: MediaQuery.of(context).size.height*0.4,
                                                          child: ColorPicker(
                                                            wheelDiameter: 130,
                                                            wheelSquarePadding: 5,
                                                            wheelSquareBorderRadius:15,
                                                            wheelWidth: 13,
                                                            // enableOpacity: true,
                                                            // Use the screenPickerColor as start color.
                                                            color: themeCubit.InCallButtonsNotactiveColor,
                                                            // Update the screenPickerColor using the callback.
                                                            pickersEnabled: const <ColorPickerType,bool>{
                                                              ColorPickerType.custom: true,
                                                              ColorPickerType.accent: true,
                                                              ColorPickerType.wheel: true,
                                                            },
                                                            onColorChangeEnd: (color) {
                                                              themeCubit.InCallButtonsNotactiveColor = color;
                                                              NativeBridge.get(context).UpdateScreen();
                                                            },
                                                            width: 25,
                                                            height: 25,
                                                            borderRadius: 5,

                                                            subheading: const Align(
                                                              alignment: AlignmentDirectional.centerStart,
                                                              child: Text(
                                                                'shades',
                                                              ),
                                                            ), onColorChanged: (Color value) {  },
                                                          ),

                                                        ),
                                                        SizedBox(
                                                          width: double.infinity,
                                                          height: MediaQuery.of(context).size.height*0.4,
                                                          child: ColorPicker(
                                                            wheelDiameter: 130,
                                                            wheelSquarePadding: 5,
                                                            wheelSquareBorderRadius:15,
                                                            wheelWidth: 13,
                                                            // enableOpacity: true,
                                                            // Use the screenPickerColor as start color.
                                                            color: themeCubit.InCallButtonsActiveColor,
                                                            // Update the screenPickerColor using the callback.
                                                            pickersEnabled: const <ColorPickerType,bool>{
                                                              ColorPickerType.custom: true,
                                                              ColorPickerType.accent: true,
                                                              ColorPickerType.wheel: true,
                                                            },
                                                            onColorChangeEnd: (color) {
                                                              themeCubit.InCallButtonsActiveColor = color;
                                                              NativeBridge.get(context).UpdateScreen();
                                                            },
                                                            width: 25,
                                                            height: 25,
                                                            borderRadius: 5,

                                                            subheading: const Align(
                                                              alignment: AlignmentDirectional.centerStart,
                                                              child: Text(
                                                                'shades',
                                                              ),
                                                            ), onColorChanged: (Color value) {  },
                                                          ),

                                                        ),

                                                      ]),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8.0),
                                                  child: Align(
                                                      alignment: AlignmentDirectional.bottomEnd,
                                                      child: defaultButton(onPressed: (){
                                                        themeCubit.InCallButtonReColorActive = false;
                                                        Navigator.pop(context);
                                                        Cubit.UpdateScreen();
                                                      }, Title: "Apply",background: Colors.deepPurple,width: 80)),
                                                ),
                                              ],
                                            );
                                          }
                                      )),
                                );
                              });
                          Cubit.UpdateScreen();
                        }
                        else
                        {
                          if (Cubit.Calls.length == 2) {
                            Cubit.Calls[Cubit.CurrentCallIndex]["PhoneState"] = "OnHold";
                            Cubit.CurrentCallIndex = Cubit.CurrentCallIndex == 1 ? 0 : 1;
                            Cubit.Calls[Cubit.CurrentCallIndex]["PhoneState"] = "Active";
                            Cubit.invokeNativeMethod("HoldToggle");
                          }
                          if (Cubit.Calls.isEmpty) {
                            Cubit.invokeNativeMethod("HoldToggle");
                            Cubit.ConferenceCalls.forEach((element) {
                              element["PhoneState"] = element["PhoneState"] == "OnHold" ? "Active" : "OnHold";
                            });
                          }

                          if (Cubit.Calls.length == 1) {
                            if (Cubit.ConferenceCalls.isNotEmpty) {
                              if (Cubit.OnConference == true) {
                                Cubit.invokeNativeMethod("Swapconference");
                                Cubit.ConferenceCalls.forEach((element) => element["PhoneState"] = "OnHold");
                                Cubit.Calls[0]["PhoneState"] = "Active";
                              } else {
                                Cubit.invokeNativeMethod("HoldToggle");
                                Cubit.ConferenceCalls.forEach((element) => element["PhoneState"] = "Active");
                                Cubit.Calls[0]["PhoneState"] = "OnHold";
                              }
                              Cubit.OnConference = !Cubit.OnConference!;
                              Cubit.CurrentCallIndex = 0;
                              ////swap conferance here
                            } else {
                              Cubit.invokeNativeMethod("HoldToggle");
                              Cubit.isHold = !Cubit.isHold;
                              Cubit.Calls[0]["PhoneState"] = Cubit.Calls[0]["PhoneState"] == "OnHold" ? "Active" : "OnHold";
                            }
                          }
                        }
                      }, icon: Icon(Cubit.isHold == false?HoldSwap==true?Icons.swap_calls:Icons.pause:Icons.motion_photos_pause_outlined),iconSize: 37,color: ActiveButton(context),),
                    ),
                    Text(Cubit.isHold == false?HoldSwap==true?"Swap":"Hold":"Unhold",),
                  ],
                ),


              ],
            ),
          ):Container(),
          Cubit.ExpandeNotes==false?Column(
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
                          if(themeCubit.ThemeEditorIsActive==true)
                          {
                            themeCubit.InCallButtonReColorActive =! themeCubit.InCallButtonReColorActive;
                            showModalBottomSheet(
                                isDismissible: false,
                                barrierColor: Colors.transparent,
                                context: context,
                                shape:const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(17),
                                      topLeft: Radius.circular(17)
                                  ),
                                ),
                                isScrollControlled: true,
                                builder: (context)
                                {
                                  return Container(
                                    height: MediaQuery.of(context).size.height*0.45,
                                    child: DefaultTabController(
                                        length: 2,
                                        child: BlocBuilder<ThemeCubit,ThemeStates>(
                                            builder: (context,state) {
                                              final TabController tabController = DefaultTabController.of(context)!;
                                              tabController.addListener(() {
                                                if (tabController.indexIsChanging) {
                                                  print(tabController.index.toString());
                                                  themeCubit.ThemeUpdating();
                                                }
                                              });
                                              return Column(
                                                children: [
                                                  Container(
                                                    height: 55,
                                                    child: Material(
                                                        color:Colors.deepPurple,
                                                        child:TabBar(
                                                          controller: tabController,
                                                          labelColor: Colors.black,
                                                          labelStyle: const TextStyle(
                                                            fontFamily: "Cairo",
                                                            fontSize: 12,

                                                          ),
                                                          unselectedLabelColor: Colors.white70,
                                                          tabs:[
                                                            Container(
                                                                alignment: AlignmentDirectional.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  color: tabController.index==0?Colors.white:Colors.transparent,
                                                                ),

                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: const [
                                                                    Icon(Icons.toggle_off_outlined),
                                                                    Text("disabled"),
                                                                  ],)),
                                                            Container(
                                                                alignment: AlignmentDirectional.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  color: tabController.index==1?Colors.white:Colors.transparent,
                                                                ),

                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: const [
                                                                    Icon(Icons.toggle_on_outlined),
                                                                    Text("enabled"),
                                                                  ],)),

                                                          ],)
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    height:  MediaQuery.of(context).size.height*0.33,
                                                    child: TabBarView(
                                                        children: [
                                                          SizedBox(
                                                            width: double.infinity,
                                                            height: MediaQuery.of(context).size.height*0.4,
                                                            child: ColorPicker(
                                                              wheelDiameter: 130,
                                                              wheelSquarePadding: 5,
                                                              wheelSquareBorderRadius:15,
                                                              wheelWidth: 13,
                                                              // enableOpacity: true,
                                                              // Use the screenPickerColor as start color.
                                                              color: themeCubit.InCallButtonsNotactiveColor,
                                                              // Update the screenPickerColor using the callback.
                                                              pickersEnabled: const <ColorPickerType,bool>{
                                                                ColorPickerType.custom: true,
                                                                ColorPickerType.accent: true,
                                                                ColorPickerType.wheel: true,
                                                              },
                                                              onColorChangeEnd: (color) {
                                                                themeCubit.InCallButtonsNotactiveColor = color;
                                                                NativeBridge.get(context).UpdateScreen();
                                                              },
                                                              width: 25,
                                                              height: 25,
                                                              borderRadius: 5,

                                                              subheading: const Align(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                child: Text(
                                                                  'shades',
                                                                ),
                                                              ), onColorChanged: (Color value) {  },
                                                            ),

                                                          ),
                                                          SizedBox(
                                                            width: double.infinity,
                                                            height: MediaQuery.of(context).size.height*0.4,
                                                            child: ColorPicker(
                                                              wheelDiameter: 130,
                                                              wheelSquarePadding: 5,
                                                              wheelSquareBorderRadius:15,
                                                              wheelWidth: 13,
                                                              // enableOpacity: true,
                                                              // Use the screenPickerColor as start color.
                                                              color: themeCubit.InCallButtonsActiveColor,
                                                              // Update the screenPickerColor using the callback.
                                                              pickersEnabled: const <ColorPickerType,bool>{
                                                                ColorPickerType.custom: true,
                                                                ColorPickerType.accent: true,
                                                                ColorPickerType.wheel: true,
                                                              },
                                                              onColorChangeEnd: (color) {
                                                                themeCubit.InCallButtonsActiveColor = color;
                                                                NativeBridge.get(context).UpdateScreen();
                                                              },
                                                              width: 25,
                                                              height: 25,
                                                              borderRadius: 5,

                                                              subheading: const Align(
                                                                alignment: AlignmentDirectional.centerStart,
                                                                child: Text(
                                                                  'shades',
                                                                ),
                                                              ), onColorChanged: (Color value) {  },
                                                            ),

                                                          ),

                                                        ]),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: Align(
                                                        alignment: AlignmentDirectional.bottomEnd,
                                                        child: defaultButton(onPressed: (){
                                                          themeCubit.InCallButtonReColorActive = false;
                                                          Navigator.pop(context);
                                                          Cubit.UpdateScreen();
                                                        }, Title: "Apply",background: Colors.deepPurple,width: 80)),
                                                  ),
                                                ],
                                              );
                                            }
                                        )),
                                  );
                                });
                            Cubit.UpdateScreen();
                          }
                          else
                          {
                            Cubit.inCallDialerToggle();
                          }
                        },
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical:15.0, horizontal: MediaQuery.of(context).size.width*0.05),
                            child: Image.asset("assets/Images/dialpad.png",scale: 1.4,color: ActiveButton(context),),
                          ),
                        ),
                      ),
                      Text("Keypad",),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        child: InkWell(
                          splashColor: Colors.red,
                          onTap: (){
                            //TODO: Setup Confrence calls
                          },
                          child: IconButton(onPressed: (){
                            if(themeCubit.ThemeEditorIsActive==true)
                            {
                              themeCubit.InCallButtonReColorActive =! themeCubit.InCallButtonReColorActive;
                              showModalBottomSheet(
                                isDismissible: false,
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  shape:const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(17),
                                        topLeft: Radius.circular(17)
                                    ),
                                  ),
                                  isScrollControlled: true,
                                  builder: (context)
                                  {
                                    return Container(
                                      height: MediaQuery.of(context).size.height*0.45,
                                      child: DefaultTabController(
                                          length: 2,
                                          child: BlocBuilder<ThemeCubit,ThemeStates>(
                                              builder: (context,state) {
                                                final TabController tabController = DefaultTabController.of(context)!;
                                                tabController.addListener(() {
                                                  if (tabController.indexIsChanging) {
                                                    print(tabController.index.toString());
                                                    themeCubit.ThemeUpdating();
                                                  }
                                                });
                                                return Column(
                                                  children: [
                                                    Container(
                                                      height: 55,
                                                      child: Material(
                                                          color:Colors.deepPurple,
                                                          child:TabBar(
                                                            controller: tabController,
                                                            labelColor: Colors.black,
                                                            labelStyle: const TextStyle(
                                                              fontFamily: "Cairo",
                                                              fontSize: 12,

                                                            ),
                                                            unselectedLabelColor: Colors.white70,
                                                            tabs:[
                                                              Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(7),
                                                                    color: tabController.index==0?Colors.white:Colors.transparent,
                                                                  ),

                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: const [
                                                                      Icon(Icons.toggle_off_outlined),
                                                                      Text("disabled"),
                                                                    ],)),
                                                              Container(
                                                                  alignment: AlignmentDirectional.center,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(7),
                                                                    color: tabController.index==1?Colors.white:Colors.transparent,
                                                                  ),

                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: const [
                                                                      Icon(Icons.toggle_on_outlined),
                                                                      Text("enabled"),
                                                                    ],)),

                                                            ],)
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height:  MediaQuery.of(context).size.height*0.33,
                                                      child: TabBarView(
                                                          children: [
                                                            SizedBox(
                                                              width: double.infinity,
                                                              height: MediaQuery.of(context).size.height*0.4,
                                                              child: ColorPicker(
                                                                wheelDiameter: 130,
                                                                wheelSquarePadding: 5,
                                                                wheelSquareBorderRadius:15,
                                                                wheelWidth: 13,
                                                                // enableOpacity: true,
                                                                // Use the screenPickerColor as start color.
                                                                color: themeCubit.InCallButtonsNotactiveColor,
                                                                // Update the screenPickerColor using the callback.
                                                                pickersEnabled: const <ColorPickerType,bool>{
                                                                  ColorPickerType.custom: true,
                                                                  ColorPickerType.accent: true,
                                                                  ColorPickerType.wheel: true,
                                                                },
                                                                onColorChangeEnd: (color) {
                                                                  themeCubit.InCallButtonsNotactiveColor = color;
                                                                  NativeBridge.get(context).UpdateScreen();
                                                                },
                                                                width: 25,
                                                                height: 25,
                                                                borderRadius: 5,

                                                                subheading: const Align(
                                                                  alignment: AlignmentDirectional.centerStart,
                                                                  child: Text(
                                                                    'shades',
                                                                  ),
                                                                ), onColorChanged: (Color value) {  },
                                                              ),

                                                            ),
                                                            SizedBox(
                                                              width: double.infinity,
                                                              height: MediaQuery.of(context).size.height*0.4,
                                                              child: ColorPicker(
                                                                wheelDiameter: 130,
                                                                wheelSquarePadding: 5,
                                                                wheelSquareBorderRadius:15,
                                                                wheelWidth: 13,
                                                                // enableOpacity: true,
                                                                // Use the screenPickerColor as start color.
                                                                color: themeCubit.InCallButtonsActiveColor,
                                                                // Update the screenPickerColor using the callback.
                                                                pickersEnabled: const <ColorPickerType,bool>{
                                                                  ColorPickerType.custom: true,
                                                                  ColorPickerType.accent: true,
                                                                  ColorPickerType.wheel: true,
                                                                },
                                                                onColorChangeEnd: (color) {
                                                                  themeCubit.InCallButtonsActiveColor = color;
                                                                  NativeBridge.get(context).UpdateScreen();
                                                                },
                                                                width: 25,
                                                                height: 25,
                                                                borderRadius: 5,

                                                                subheading: const Align(
                                                                  alignment: AlignmentDirectional.centerStart,
                                                                  child: Text(
                                                                    'shades',
                                                                  ),
                                                                ), onColorChanged: (Color value) {  },
                                                              ),

                                                            ),

                                                          ]),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 8.0),
                                                      child: Align(
                                                          alignment: AlignmentDirectional.bottomEnd,
                                                          child: defaultButton(onPressed: (){
                                                            themeCubit.InCallButtonReColorActive = false;
                                                            Navigator.pop(context);
                                                            Cubit.UpdateScreen();
                                                          }, Title: "Apply",background: Colors.deepPurple,width: 80)),
                                                    ),
                                                  ],
                                                );
                                              }
                                          )),
                                    );
                                  });
                              Cubit.UpdateScreen();
                            }
                            else
                            {
                              if(Cubit.Calls.length==2)
                              {
                                AddMerge = true;
                              }
                              if(Cubit.Calls.length==2 && AddMerge ==true)
                              {
                                Cubit.invokeNativeMethod("conference").then((value)
                                {
                                  if(Cubit.OnConference ==true){
                                    Cubit.ConferenceCalls = Cubit.Calls;
                                    Cubit.Calls.clear();
                                    Cubit.CallDuration.clear();
                                    Cubit.ConferenceTimer.onExecute.add(StopWatchExecute.start);
                                    Cubit.isStopWatchStart = false;
                                    AddMerge = false;
                                  }
                                });
                              }
                              if(Cubit.Calls.length==1){
                                if(Cubit.ConferenceCalls.isNotEmpty){
                                  if(Cubit.OnConference ==false)
                                  {
                                    Cubit.invokeNativeMethod("HoldToggle");
                                  }
                                  Cubit.invokeNativeMethod("Mergconference");
                                  Cubit.ConferenceCalls.add(Cubit.Calls[0]);
                                  Cubit.OnConference=true;
                                  Cubit.Calls.clear();

                                } else
                                {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext context) => Home()));
                                }
                              }
                              if(Cubit.Calls.isEmpty && Cubit.OnConference == true)
                              {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context) => Home()));
                              }
                            }
                          }, icon: Icon(AddMerge == true?Icons.call_merge:Icons.add_call),iconSize: 37,color: ActiveButton(context),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:5.0),
                        child: Text(AddMerge == true?"Merge":"Add",),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        splashColor: Colors.blue,
                        onTap:(){
                          if(themeCubit.ThemeEditorIsActive==true)
                          {

                          }
                          else
                          {
                            Cubit.MergedOrRinging = false;
                            Cubit.invokeNativeMethod("RejectCall", null);
                          }
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
                height:(MediaQuery.of(context).size.height +  MediaQuery.of(context).padding.bottom) <=667? (MediaQuery.of(context).size.height +  MediaQuery.of(context).padding.bottom)* 0.04:(MediaQuery.of(context).size.height +  MediaQuery.of(context).padding.bottom)* 0.09,
              ),
              themeCubit.ThemeEditorIsActive==true?GestureDetector(
                onPanUpdate: (details){
                  if(details.delta.dy.isNegative ==true)
                  {

                    NativeBridge.get(context).BackGroundCustomize =!NativeBridge.get(context).BackGroundCustomize;
                    NativeBridge.get(context).UpdateScreen();
                    showModalBottomSheet(
                        barrierColor: Colors.transparent,
                        context: context,
                        shape:const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(17),
                              topLeft: Radius.circular(17)
                          ),
                        ),
                        isScrollControlled: true,
                        builder: (context)
                        {
                          return Container(
                            height: 100,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Load Background Image file"),
                                IconButton(onPressed: ()async{
                                  ThemeCubit.get(context).InCallBackgroundFilePicker = await ImagePicker().pickImage(source: ImageSource.gallery);
                                  if(ThemeCubit.get(context).InCallBackgroundFilePicker !=null ) {
                                    final imagePermanent = await SaveImagePermanently(ThemeCubit.get(context).InCallBackgroundFilePicker.path);

                                    ThemeCubit.get(context).InCallBackGroundImagePicker = imagePermanent;
                                    NativeBridge.get(context).UpdateScreen();

                                    //TODO:Spleting Uploading the image from Profile image Picker Due to the image will be Uploaded without User Concent

                                  }
                                }, icon: Icon(Icons.download_for_offline_rounded)),
                              ],),

                          );
                        });
                  }
                },
                child: Text(
                  "Swipe up for Background Customization",
                  style: TextStyle(
                    color: HexColor("#B1B1B1").withOpacity(0.70),
                    fontFamily: "Cairo",
                    fontSize: 12,
                  ),
                ),
              ):Container(),
              themeCubit.ThemeEditorIsActive==true?Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                    width: 120,
                    height: 1,
                    color: HexColor("#B4B4B4").withOpacity(0.49)),
              ):Container(),
            ],
          ):Container(),
        ]
    );
  }

  StreamBuilder<DocumentSnapshot<Object?>> CallResonBar(Cubit) {
    return StreamBuilder<DocumentSnapshot>(
                                stream: CurrentUserStream,
                                builder: (context,snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Text("Loading");
                                  }
                                  final data = snapshot..requireData;

                                  return data.data!["InCallMessage"]!= ""?Row(
                                    children: [
                                      Expanded(child: Column(children: [Text("CALL REASON"),Text(data.data?["InCallMessage"],style: TextStyle(fontSize: 15,color: Colors.white),),],)),
                                    ],
                                  ):Container(height: MediaQuery.of(context).size.height*0.02,);
                                }
                            );
  }

  Widget BackgroundImage(BuildContext context,ThemeCubit themeCubit) {

    if(themeCubit.ThemeEditorIsActive==true)
    {
      return ThemeCubit.get(context).InCallBackGroundImagePicker !=null?Transform.rotate(
        angle: themeCubit.InCallBackgroundRotate,
        origin: Offset(10,themeCubit.InCallBackgroundVerticalPading/2),
        child: Transform.translate(
          offset: Offset(themeCubit.InCallBackgroundOffsetdx,ThemeCubit.get(context).InCallBackgroundVerticalPading),
          child: Container(

            height: ThemeCubit.get(context).InCallBackgroundHeight,
            decoration:  BoxDecoration(
              image: DecorationImage(
                image: ImageSwap(ThemeCubit.get(context).InCallBackGroundImagePicker),
                fit: BoxFit.cover,
                opacity: ThemeCubit.get(context).InCallBackgroundOpacity,
              ),
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
      );
    }
    else
    {
      return ThemeCubit.get(context).InCallBackGroundImagePicker !=null?Transform.rotate(
        angle: double.parse(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackgroundRotate"]),
        origin: Offset(10,double.parse(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackgroundVerticalPading"])/2),
        child: Transform.translate(
          offset: Offset(double.parse(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackgroundOffsetdx"]),double.parse(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackgroundVerticalPading"])),
          child: Container(
            height: double.parse(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackgroundHeight"]),
            decoration:  BoxDecoration(
              image: DecorationImage(
                image: ImageSwap(ThemeCubit.get(context).InCallBackGroundImagePicker),
                fit: BoxFit.cover,
                opacity: double.parse(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackgroundOpacity"]),
              ),
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
      );
    }
  }

  Stack ContactAvatar(NativeBridge Cubit , ThemeCubit themeCubit) {
    if(Cubit.OnConference ==true && themeCubit.ThemeEditorIsActive==false){
     return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                color: Colors.white,
                width: 90,
                child: TextButton(
                  onPressed: (){},
                  child: Row(children: [Icon(Icons.manage_accounts),SizedBox(width: 5,) , Text("Mange")]),
                ),
              ),
            ),
            Container(
              child: CircleAvatar(
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
            Icon(
              Icons.groups,
              color: HexColor("#D1D1D1"),
              size: 50,
            ),
            OnlineStates(),
          ]);
    }
    if(Cubit.OnConference ==false && themeCubit.ThemeEditorIsActive==false)
    {
     return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              child: Cubit.Calls[Cubit.CurrentCallIndex]["Avatar"]!= null?CallerPhoto(Cubit.Calls[Cubit.CurrentCallIndex]["Avatar"]):
              CircleAvatar(
                backgroundColor: HexColor("#545454"),
                radius: 45,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color:
    Cubit.Calls[Cubit.CurrentCallIndex]["PhoneState"] =="Active"?HexColor("#36FF72").withOpacity(0.70):HexColor("#F8F8F8").withOpacity(0.69),
                ),
              ),
            ),
            Cubit.Calls[Cubit.CurrentCallIndex]["Avatar"]!= null?Container():Icon(
              Icons.person,
              color: HexColor("#D1D1D1"),
              size: 50,
            ),
          ]);
    }
    else
    {
      return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: HexColor("#F8F8F8").withOpacity(0.69),
                ),
              ),
              child:
              CircleAvatar(
                backgroundColor: HexColor("#545454"),
                radius: 45,
              ),
            ),
            Icon(
              Icons.person,
              color: HexColor("#D1D1D1"),
              size: 50,
            ),
          ]);
    }

  }

  CircleAvatar CallerPhoto(Uint8List avatar) => CircleAvatar(backgroundImage:MemoryImage(avatar),radius: 45,);








  final Stream<DocumentSnapshot> CurrentUserStream = FirebaseFirestore.instance.collection('Users').doc(token).snapshots();
  Widget InCallMessages(context,Cubit) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [

        Cubit.InCallMsg?Container():Padding(
          padding: const EdgeInsets.only(right: 8.0,bottom: 21),
          child: Column(
            children: [
              IconButton(
                onPressed: (){
                Cubit.ActivateInCallMsg();
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
            width: Cubit.InCallMsg?MediaQuery.of(context).size.width-70:0,
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
                    Cubit.ActivateInCallMsg();
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
                    controller: Cubit.CallReasonController,
                    onSubmitted: (value){
                      Cubit.SendInCallMsg(value);
                      Cubit.CallReasonController.clear();
                      Cubit.UpdateScreen();
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
                        Cubit.SendInCallMsg(Cubit.CallReasonController.text);
                        Cubit.CallReasonController.clear();
                        Cubit.UpdateScreen();
                      }, icon: Transform.rotate(
                          angle:-95,
                          child: Icon(Icons.send_rounded,)),)),
            ]),
          ),
        ),

      ],
    );
  }


  Row CallerID(context,Cubit , ThemeCubit themeCubit) {
    if(Cubit.OnConference ==false && themeCubit.ThemeEditorIsActive==false){
      return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(Cubit.Calls[Cubit.CurrentCallIndex]["DisplayName"]!=null?Cubit.Calls[Cubit.CurrentCallIndex]["DisplayName"].toString().toUpperCase():"",
              style: TextStyle(
                fontFamily: "ZenKurenaido-Regular",
                color: HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["CallerIDcolor"]).withOpacity(0.80),
                fontSize: 25,
              )),
        ),
      ],
    );
    }
    if(Cubit.OnConference ==true && themeCubit.ThemeEditorIsActive==false)
    {
      return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text("Conferance 1",
              style: TextStyle(
                fontFamily: "ZenKurenaido-Regular",
                color: HexColor("#F5F5F5"),
                fontSize: 25,
              )),
        ),
      ],
    );
    }
    else
    {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: InkWell(
              onTap: (){
                showModalBottomSheet(
                    barrierColor: Colors.transparent,
                    context: context,
                    shape:const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(17),
                          topLeft: Radius.circular(17)
                      ),
                    ),
                    isScrollControlled: true,
                    builder: (context)
                    {
                      return Container(
                        height: MediaQuery.of(context).size.height*0.45,
                        child: DefaultTabController(
                            length: 2,
                            child: BlocBuilder<ThemeCubit,ThemeStates>(
                                builder: (context,state) {
                                  final TabController tabController = DefaultTabController.of(context)!;
                                  tabController.addListener(() {
                                    if (tabController.indexIsChanging) {
                                      print(tabController.index.toString());
                                      themeCubit.ThemeUpdating();
                                    }
                                  });
                                  return SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height*0.4,
                                    child: ColorPicker(
                                      wheelDiameter: 130,
                                      wheelSquarePadding: 5,
                                      wheelSquareBorderRadius:15,
                                      wheelWidth: 13,
                                      // enableOpacity: true,
                                      // Use the screenPickerColor as start color.
                                      color: themeCubit.CallerIDcolor,
                                      // Update the screenPickerColor using the callback.
                                      pickersEnabled: const <ColorPickerType,bool>{
                                        ColorPickerType.custom: true,
                                        ColorPickerType.accent: true,
                                        ColorPickerType.wheel: true,
                                      },
                                      onColorChangeEnd: (color) {
                                        themeCubit.CallerIDcolor = color;
                                        NativeBridge.get(context).UpdateScreen();
                                      },
                                      width: 25,
                                      height: 25,
                                      borderRadius: 5,

                                      subheading: const Align(
                                        alignment: AlignmentDirectional.centerStart,
                                        child: Text(
                                          'shades',
                                        ),
                                      ), onColorChanged: (Color value) {  },
                                    ),

                                  );
                                }
                            )),
                      );
                    });
                Cubit.UpdateScreen();
              },
              child: Text("Dialer Name",
                  style: TextStyle(
                    fontFamily: "ZenKurenaido-Regular",
                    color: themeCubit.CallerIDcolor,
                    fontSize: 25,
                  )),
            ),
          ),
        ],
      );
    }

  }

  Center CallerPhoneNumber(context,Cubit,ThemeCubit themeCubit) {
    if(themeCubit.ThemeEditorIsActive==false) {
      return Center(
          child: Text(
              Cubit.Calls[Cubit.CurrentCallIndex]["PhoneNumber"].toString(),
              style: TextStyle(
                fontFamily: "Cairo",
                fontWeight: FontWeight.w300,
                color:HexColor(ThemeCubit.get(context).MyThemeData[ActiveTheme]["CallerIDPhoneNumbercolor"]),
                fontSize: 25,
                letterSpacing: -1,
                height: 1.6,
              )));
    }
    else
      {
        return Center(
            child: InkWell(
              onTap: (){
                showModalBottomSheet(
                    barrierColor: Colors.transparent,
                    context: context,
                    shape:const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(17),
                          topLeft: Radius.circular(17)
                      ),
                    ),
                    isScrollControlled: true,
                    builder: (context)
                    {
                      return Container(
                        height: MediaQuery.of(context).size.height*0.45,
                        child: DefaultTabController(
                            length: 2,
                            child: BlocBuilder<ThemeCubit,ThemeStates>(
                                builder: (context,state) {
                                  final TabController tabController = DefaultTabController.of(context)!;
                                  tabController.addListener(() {
                                    if (tabController.indexIsChanging) {
                                      print(tabController.index.toString());
                                      themeCubit.ThemeUpdating();
                                    }
                                  });
                                  return SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height*0.4,
                                    child: ColorPicker(
                                      wheelDiameter: 130,
                                      wheelSquarePadding: 5,
                                      wheelSquareBorderRadius:15,
                                      wheelWidth: 13,
                                      // enableOpacity: true,
                                      // Use the screenPickerColor as start color.
                                      color: themeCubit.CallerIDPhoneNumbercolor,
                                      // Update the screenPickerColor using the callback.
                                      pickersEnabled: const <ColorPickerType,bool>{
                                        ColorPickerType.custom: true,
                                        ColorPickerType.accent: true,
                                        ColorPickerType.wheel: true,
                                      },
                                      onColorChangeEnd: (color) {
                                        themeCubit.CallerIDPhoneNumbercolor = color;
                                        NativeBridge.get(context).UpdateScreen();
                                      },
                                      width: 25,
                                      height: 25,
                                      borderRadius: 5,

                                      subheading: const Align(
                                        alignment: AlignmentDirectional.centerStart,
                                        child: Text(
                                          'shades',
                                        ),
                                      ), onColorChanged: (Color value) {  },
                                    ),

                                  );
                                }
                            )),
                      );
                    });
                Cubit.UpdateScreen();
              },
              child: Text(
                  "0122889444566",
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.w300,
                    color: themeCubit.CallerIDPhoneNumbercolor,
                    fontSize: 25,
                    letterSpacing: -1,
                    height: 1.6,
                  )),
            ));
      }
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
  double GesterLocation =0;
  double GesterStart =0;
  bool GesterCancel =false;

  double AnswerCallColorFeedback (){
    if(GesterLocation>=10 && GesterLocation.sign.isNegative ==false)
      {
        return 10;
     }
    if(GesterLocation<=-1 && GesterLocation.sign.isNegative==true)
      {
        return 0;
      }
    return 1.66+GesterLocation;
  }


}
Widget OnHoldBanner(Cubit ,context){
  return Cubit.Calls.length==2?Padding(
    padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top),
    child: Align(
        alignment: AlignmentDirectional.topStart,
        child: Container(width: double.infinity,height: MediaQuery.of(context).size.height*0.08,color: Colors.black26,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(Cubit.Calls[Cubit.CurrentCallIndex==1?0:1]["PhoneNumber"]), Row(
              children: [
                Icon(Icons.pause),
                Text("onHold"),
              ],
            )],),)),
  ):Container();
}
bool? HoldSwap ;
bool? AddMerge ;


