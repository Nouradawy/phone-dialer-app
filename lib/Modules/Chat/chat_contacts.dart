import 'package:dialer_app/Components/components.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Models/user_model.dart';
import 'package:dialer_app/Modules/Chat/chat_messeging.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/states.dart';
import 'package:dialer_app/Modules/profile/Profile%20Cubit/profile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class ChatContacts extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    double AppbarSize = MediaQuery
        .of(context)
        .size
        .height * 0.11;
    double ProfilePictureSize = 28;
    double ProfilePictureBackgroundWidth = ProfilePictureSize * 2.60;
    double ProfilePictureBackgroundHight = ProfilePictureSize * 1.7;
    double UserNameFontSize = ProfilePictureBackgroundWidth * 0.15;
    double MsgBoxWidth = MediaQuery
        .of(context)
        .size
        .width - (ProfilePictureBackgroundWidth + 34);
    double MsgBoxHPadding = 6;
    Text Msg = Text("you to focus on jhin and i will take  ",style: TextStyle(
      fontFamily: "Cairo",
      height: 1.2,
      fontWeight: FontWeight.w600,
    ));
    return Scaffold(
      appBar: ChatAppBar(context, AppbarSize),
      body: BlocProvider.value(
        value:ProfileCubit.get(context),
        child:ListView.builder(
            itemCount: ProfileCubit.get(context).ChatContacts.length,
            itemBuilder: (BuildContext context, int index) {
              UserModel contact = ProfileCubit.get(context).ChatContacts[index];
             return Padding(
               padding: const EdgeInsets.only(top:8.0),
               child: ListTile(
                 onTap: (){
                   Navigator.of(context).push(MaterialPageRoute(
                       builder: (BuildContext context) =>
                           ContactChatingScreen(Contact: contact)
                   ));
                 },
                  leading: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2,
                            color: HexColor("#57E3A0"))
                    ),
                    child: CircleAvatar(
                      radius: ProfilePictureSize,
                      backgroundImage: NetworkImage(
                          ProfileCubit.get(context).ChatContacts[index].image.toString()),
                    ),
                  ),
                  title:Text(ProfileCubit.get(context).ChatContacts[index].name.toString()),
                ),
             );
            },
          ),
      ),
    );
  }
}
