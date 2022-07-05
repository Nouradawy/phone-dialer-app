import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:dialer_app/Components/components.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Models/message_model.dart';
import 'package:dialer_app/Models/user_model.dart';
import 'package:dialer_app/Modules/Chat/Cubit/states.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/states.dart';
import 'package:dialer_app/Modules/profile/Profile%20Cubit/profile_cubit.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import 'Cubit/cubit.dart';
import 'chat_contacts.dart';

class ChatScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    double AppbarSize = MediaQuery.of(context).size.height * 0.11;
    double ProfilePictureSize = 31;
    double ProfilePictureBackgroundWidth = ProfilePictureSize * 2.90;
    double ProfilePictureBackgroundHight = ProfilePictureSize * 2.5;
    double UserNameFontSize = ProfilePictureBackgroundWidth * 0.12;
    double MsgBoxWidth = MediaQuery.of(context).size.width - (ProfilePictureBackgroundWidth + 34);

    double MsgBoxHPadding = 6;
    // Text Msg = Text("i want you to focus on jhin and i will take  ",style: TextStyle(
    //   fontFamily: "Cairo",
    //   height: 1.2,
    //   fontWeight: FontWeight.w600,
    // ));
    final userModel = FirebaseFirestore.instance.collection("Users").doc(token).withConverter<UserModel>(
        fromFirestore:(snapshots , _)=> UserModel.fromJson(snapshots.data()),
        toFirestore: (UserModel , _) =>UserModel.toMap()
          );
          return Scaffold(
                floatingActionButton: FloatingActionButton.extended(

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder:(BuildContext context) => ChatContacts()),
                      );
                    },
                    label:
                    Row(children: [
                      Icon(Icons.add),
                      Text("New Chat"),
                    ],)
                ),
                appBar: ChatAppBar(context, AppbarSize),
                body: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 12.0),
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: ProfileCubit.get(context)..GetChatContacts),
                    ],
                    child:StreamBuilder<DocumentSnapshot<UserModel>>(
                        stream: userModel.snapshots(),
                        builder:(context , UserModelsnapshot)
                        {
                          final Userdata = UserModelsnapshot.requireData;
                          // if(Userdata["NewMessage"] ==true)
                          // {
                          //
                          //   // FirebaseFirestore.instance.collection("Users").doc(token).set({"NewMessage":false,},
                          //   //   SetOptions(merge: true),);
                          // }
                          ChatAppCubit.get(context).ListCount();
                          ChatAppCubit.get(context).ScreenUpdate();
                          if (UserModelsnapshot.hasError) {
                            return Center(
                              child: Text(UserModelsnapshot.error.toString()),
                            );
                          }

                          if (!UserModelsnapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (ChatAppCubit.get(context).ListUnseenMsgs.isEmpty) {
                            return const Center(child: CircularProgressIndicator());
                          }


                          return BlocBuilder<ChatAppCubit,ChatAppCubitStates>(
                            builder:(context,state)=> ListView.separated(
                                itemCount:ChatAppCubit.get(context).ListUnseenMsgs.length,
                                separatorBuilder: (context,state)=>SizedBox(height: 2,),
                                itemBuilder:(context , index) {
                                  //ToDo: add list filtering


                                    // final messagesRef = FirebaseFirestore.instance.collection("Users").doc(token).collection("chats").doc(Userdata.docs[index].data().uId !=token?Userdata.docs[index].data().uId:Userdata.docs[index+1].data().uId ).collection("messages").withConverter<MessageModel>(fromFirestore: (snapshots, _) => MessageModel.fromJson(snapshots.data()), toFirestore: (model, _) => ChatAppCubit.get(context).model!.toMap());
                                    //
                                    //   return StreamBuilder<QuerySnapshot<MessageModel>>(
                                    //     stream: messagesRef.snapshots(),
                                    //           builder:(context , snapshot) {
                                    //
                                    //
                                    //             final data = snapshot.requireData;
                                    //             // return NewMessegesChatList(ProfilePictureSize, ProfilePictureBackgroundWidth, ProfilePictureBackgroundHight, Userdata, index, UserNameFontSize, messagesRef, MsgBoxWidth, MsgBoxHPadding, data);
                                    //             ///Return new Mesg. on recived if the user didn't see it yet
                                    //             // if(data.docs[index].data().Seen == false && data.docs[index].data().text!.isNotEmpty && data.docs[index].data().receiverId == token ) {

                                          return NewMessegesChatList(context,ProfilePictureSize, ProfilePictureBackgroundWidth, ProfilePictureBackgroundHight,index, UserNameFontSize, MsgBoxWidth, MsgBoxHPadding);
                                        // } else return Container();
                                              }));
                                },
                              ),
                          )
                      ),
                  );

  }

  Row NewMessegesChatList(context,double ProfilePictureSize, double ProfilePictureBackgroundWidth, double ProfilePictureBackgroundHight, int index, double UserNameFontSize, double MsgBoxWidth, double MsgBoxHPadding ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Transform.translate(
                  offset: Offset(0, ProfilePictureSize * 0.50),
                  child: Container(
                    decoration: BoxDecoration(
                        color: HexColor("#E5E5E5").withOpacity(0.60),
                        borderRadius: const BorderRadiusDirectional.only(
                          topStart: Radius.circular(6),
                          bottomStart: Radius.circular(6),
                          topEnd: Radius.zero,
                          bottomEnd: Radius.zero,
                        )),
                    width: ProfilePictureBackgroundWidth,
                    height: ProfilePictureBackgroundHight,
                  ),
                ),

                //Consum
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: HexColor("#57E3A0"))),
                      child: CircleAvatar(
                        radius: ProfilePictureSize,
                        backgroundImage: NetworkImage(ChatAppCubit.get(context).ListUnseenMsgs[index]["image"]),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      ChatAppCubit.get(context).ListUnseenMsgs[index]["Name"],
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: UserNameFontSize,
                      ),
                    ),
                    // Text("Mohamed",style: TextStyle(
                    //   fontFamily: "Quicksand",
                    //   fontSize: UserNameFontSize,
                    // ),),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 17.0, left: ProfilePictureBackgroundWidth - 10),
              child: Column(
                children: [
                  Container(
                    alignment: AlignmentDirectional.topCenter,
                    width: 2,
                    height: 25,
                    color: HexColor("#707070"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 20,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor("#5545AA").withOpacity(0.30),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Container(
            child: Transform.translate(
              offset: Offset(-10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 3.0),
                    child: Text(
                      "Last seen",
                      style: TextStyle(fontFamily: "Cairo", fontSize: 8, height: 1),
                    ),
                  ),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 3.0),
                        child: Text(
                          "30 Min ago",
                          style: TextStyle(fontFamily: "Cairo", fontSize: 10, height: 1.5),
                        ),
                      ),
                      SizedBox(
                        width: 115,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 3.0),
                        child: Text(
                          "Wednesday at 11:28",
                          style: TextStyle(fontFamily: "Cairo", fontSize: 10, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 255,
                    alignment: AlignmentDirectional.centerEnd,
                    child: Container(
                      width: 70,
                      height: 1,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    color: HexColor("#E1F4FF").withOpacity(0.52),
                    width: MsgBoxWidth,
                    height: ProfilePictureBackgroundHight - 26.5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: MsgBoxHPadding, horizontal: 14),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 40,
                        ),
                        child: ListView.builder(
                          itemCount: int.parse(ChatAppCubit.get(context).ListUnseenMsgs[index]["Length"]),
                          itemBuilder: (context,i){
                            return Text(ChatAppCubit.get(context).ListUnseenMsgs[index]["text"][i],style: const TextStyle(
                              fontFamily: "Cairo",
                              height: 1.1,
                              fontWeight: FontWeight.w600,
                            ));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
