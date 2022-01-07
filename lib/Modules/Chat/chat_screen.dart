import 'package:dialer_app/Components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

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
    double MsgBoxWidth = MediaQuery
        .of(context)
        .size
        .width - (ProfilePictureBackgroundWidth + 34);
    double MsgBoxHPadding = 6;
    Text Msg = Text("ok i want you to focus on jhin and i will take  ",style: TextStyle(
      fontFamily: "Cairo",
      height: 1.2,
      fontWeight: FontWeight.w600,
    ));
    return Scaffold(
      appBar: ChatAppBar(context, AppbarSize),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 12.0),
        child: Column(
          children: [
            Row(
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
                                  bottomEnd: Radius.zero,)
                            ),

                            width: ProfilePictureBackgroundWidth,
                            height: ProfilePictureBackgroundHight,),
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 2,
                                      color: HexColor("#57E3A0"))
                              ),
                              child: CircleAvatar(
                                radius: ProfilePictureSize,
                                backgroundImage: NetworkImage(
                                    "https://www.dmarge.com/cdn-cgi/image/width=768,quality=85,fit=scale-down,format=auto/https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg"),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text("Nour Eldin", style: TextStyle(
                              fontFamily: "Quicksand",
                              fontSize: UserNameFontSize,
                            ),),
                            // Text("Mohamed",style: TextStyle(
                            //   fontFamily: "Quicksand",
                            //   fontSize: UserNameFontSize,
                            // ),),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 17.0, left: ProfilePictureBackgroundWidth - 10),
                      child: Column(
                        children: [
                          Container(
                            alignment: AlignmentDirectional.topCenter,
                            width: 2,
                            height: 25,
                            color: HexColor("#707070"),
                          ),
                          SizedBox(height: 30,),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("Last seen", style: TextStyle(
                                fontFamily: "Cairo",
                                fontSize: 8,
                                height: 1
                            ),),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Text("30 Min ago", style: TextStyle(
                                    fontFamily: "Cairo",
                                    fontSize: 10,
                                    height: 1.5
                                ),),
                              ),
                              SizedBox(width: 115,),
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Text("Wednesday at 11:28", style: TextStyle(
                                    fontFamily: "Cairo",
                                    fontSize: 10,
                                    height: 1.5
                                ),),
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
                              padding: EdgeInsets.symmetric(
                                  vertical: MsgBoxHPadding, horizontal: 13),
                              child: Msg
                            ),
                          ),
                        ],),
                    ),
                  ),
                ),
              ],
            ),
            TextButton(onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder:(BuildContext context) => ChatContacts()),
                     );
            }, child: Text("Chat Contacts"))
          ],
        ),
      ),
    );
  }
}
