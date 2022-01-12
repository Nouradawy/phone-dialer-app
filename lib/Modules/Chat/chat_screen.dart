import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:dialer_app/Components/components.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Models/message_model.dart';
import 'package:dialer_app/Models/user_model.dart';
import 'package:dialer_app/Modules/Chat/Cubit/states.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import 'Cubit/cubit.dart';
import 'chat_contacts.dart';

class ChatScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    double AppbarSize = MediaQuery
        .of(context)
        .size
        .height * 0.11;
    double ProfilePictureSize = 31;
    double ProfilePictureBackgroundWidth = ProfilePictureSize * 2.60;
    double ProfilePictureBackgroundHight = ProfilePictureSize * 2.5;
    double UserNameFontSize = ProfilePictureBackgroundWidth * 0.15;
    double MsgBoxWidth = MediaQuery.of(context).size
        .width - (ProfilePictureBackgroundWidth + 34);

    double MsgBoxHPadding = 6;
    // Text Msg = Text("i want you to focus on jhin and i will take  ",style: TextStyle(
    //   fontFamily: "Cairo",
    //   height: 1.2,
    //   fontWeight: FontWeight.w600,
    // ));
    return BlocProvider.value(
      value:LoginCubit()..ListCount(),
      child: BlocConsumer<LoginCubit,LoginCubitStates>(
        listener: (loginContext ,loginState){
          // if(LoginCubit.get(context).ListSize !=LoginCubit.get(context).ListSize)
          //   {
          //     LoginCubit.get(context).ListListner();
          //   }
        },
        builder:(loginContext ,loginState) {

          final userModel = FirebaseFirestore.instance.collection("Users").withConverter<UserModel>(
              fromFirestore:(snapshots , _)=> UserModel.fromJson(snapshots.data()),
              toFirestore: (UserModel , _) =>UserModel.toMap()
          );
          return BlocProvider(
            create: (context) => ChatAppCubit(),
            child: BlocConsumer<ChatAppCubit,ChatAppCubitStates>(
              listener: (context , ChatState){
              },
              builder:(context , ChatState)=> Scaffold(
                floatingActionButton: FloatingActionButton.extended(

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onPressed: () {
                      Navigator.push(loginContext,
                        MaterialPageRoute(builder:(BuildContext context) => ChatContacts()),
                      );
                    },
                    label:
                    Row(children: [
                      Icon(Icons.add),
                      Text("New Chat"),
                    ],)
                ),
                appBar: ChatAppBar(loginContext, AppbarSize),
                body: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 12.0),
                  child: StreamBuilder<QuerySnapshot<UserModel>>(
                    stream: userModel.snapshots(),
                    builder:(context , UserModelsnapshot)
                    {
                      if (UserModelsnapshot.hasError ) {
                        return Center(
                          child: Text(UserModelsnapshot.error.toString()),
                        );
                      }

                      if (!UserModelsnapshot.hasData ) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final Userdata = UserModelsnapshot.requireData;

                      return ListView.separated(
                          itemCount:LoginCubit.get(context).ListSize,
                          separatorBuilder: (context,state)=>SizedBox(height: 2,),
                          itemBuilder:(context , index) {
                            //ToDo: add list filtering

                              final messagesRef = FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(token)
                                  .collection("chats")
                                  .doc(Userdata.docs[index].data().uId.toString() !=token?Userdata.docs[index].data().uId.toString():Userdata.docs[index+1].data().uId.toString() )
                                  .collection("messages")
                                  .withConverter<MessageModel>(fromFirestore: (snapshots, _) => MessageModel.fromJson(snapshots.data()), toFirestore: (model, _) => ChatAppCubit.get(context).model!.toMap());



                                return StreamBuilder<QuerySnapshot<MessageModel>>(
                                  stream: messagesRef.snapshots(),
                                        builder:(context , snapshot) {

                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text(UserModelsnapshot.error.toString()),
                                            );
                                          }

                                          if (!snapshot.hasData) {
                                            return const Center(child: CircularProgressIndicator());
                                          }

                                          final data = snapshot.requireData;
                                          // return NewMessegesChatList(ProfilePictureSize, ProfilePictureBackgroundWidth, ProfilePictureBackgroundHight, Userdata, index, UserNameFontSize, messagesRef, MsgBoxWidth, MsgBoxHPadding, data);
                                          if(data.docs[index].data().Seen == false && data.docs[index].data().text!.isNotEmpty && data.docs[index].data().receiverId == token ) {

                                    return NewMessegesChatList(ProfilePictureSize, ProfilePictureBackgroundWidth, ProfilePictureBackgroundHight, Userdata, index, UserNameFontSize, messagesRef, MsgBoxWidth, MsgBoxHPadding, data);
                                  } else return Container();
                                        });
                          },
                        );

                    },
                  ),

                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Row NewMessegesChatList(double ProfilePictureSize, double ProfilePictureBackgroundWidth, double ProfilePictureBackgroundHight, QuerySnapshot<UserModel> Userdata, int index, double UserNameFontSize, CollectionReference<MessageModel> messagesRef, double MsgBoxWidth, double MsgBoxHPadding ,data) {
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
                        backgroundImage: NetworkImage(Userdata.docs[index].data().uId.toString() !=token ?Userdata.docs[index].data().image.toString():Userdata.docs[index+1].data().image.toString() ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      Userdata.docs[index].data().uId.toString() !=token ?Userdata.docs[index].data().name.toString():Userdata.docs[index+1].data().name.toString(),
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
                    height: 30,
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
                      padding: EdgeInsets.symmetric(vertical: MsgBoxHPadding, horizontal: 13),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 40,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            data.docs[0].data().Seen == false && data.docs[0].data().text!.isNotEmpty && data.docs[0].data().receiverId == token
                                ? Text(data.docs[0].data().text.toString(),
                                    style: const TextStyle(
                                      fontFamily: "Cairo",
                                      height: 1.1,
                                      fontWeight: FontWeight.w600,
                                    ))
                                : Container(),
                            data.docs[1].data().Seen == false && data.docs[1].data().text!.isNotEmpty && data.docs[1].data().receiverId == token
                                ? Text(data.docs[1].data().text.toString(),
                                    style: const TextStyle(
                                      fontFamily: "Cairo",
                                      height: 1.1,
                                      fontWeight: FontWeight.w600,
                                    ))
                                : Container(),
                            data.docs[2].data().Seen == false && data.docs[2].data().text!.isNotEmpty && data.docs[2].data().receiverId == token
                                ? Text(data.docs[2].data().text.toString(),
                                    style: const TextStyle(
                                      fontFamily: "Cairo",
                                      height: 1.1,
                                      fontWeight: FontWeight.w600,
                                    ))
                                : Container(),
                          ],
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
