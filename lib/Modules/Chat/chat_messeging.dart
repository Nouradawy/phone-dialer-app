import 'package:dialer_app/Components/components.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Models/user_model.dart';
import 'package:dialer_app/Modules/Chat/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Chat/Cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class ContactChatingScreen extends StatelessWidget {
  UserModel  Contact;
  ContactChatingScreen({required this.Contact});

var MsgBox = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double AppbarSize = MediaQuery
        .of(context)
        .size
        .height * 0.11;
    return BlocProvider(
      create: (context)=>ChatAppCubit(),
      child: BlocConsumer<ChatAppCubit,ChatAppCubitStates>(
        listener:(context,states){},
        builder:(context,states) {
          ChatAppCubit.get(context).GetMessages(receiverId: Contact.uId.toString());
          return Scaffold(
          appBar:ChatMessagesAppBar(context,AppbarSize,Contact),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [

              Expanded(
                child: ListView.separated(
                  itemCount:ChatAppCubit.get(context).messages.length,
                    separatorBuilder: (context,state)=>SizedBox(height: 2,),
                    itemBuilder:(context,index) {
                    String UserMsg = ChatAppCubit.get(context).messages[index].text;
                    var message = ChatAppCubit.get(context).messages[index];
                    if(token == message.senderId) {
                          return UserMsgBubbleChat(context , UserMsg);
                        } else {
                      return ContactMsgBubbleChat(context , UserMsg);
                    }
                      }),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 20),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Nour is typing ...")),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width:MediaQuery.of(context).size.width-20,
                  decoration: BoxDecoration(
                    border:Border.all(width:1,color:Colors.grey),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: MsgBox,
                          keyboardType:TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:EdgeInsets.symmetric(horizontal: 20),
                            hintText: "Type here",
                          ),
                        ),
                      ),
                      IconButton(onPressed: (){}, icon: Icon(Icons.mic),),
                      Transform.translate(
                        offset: Offset(3,0),
                        child: Container(
                            decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                              color:Colors.blue,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left:3.0),
                              child: IconButton(highlightColor:Colors.red ,onPressed: (){
                                ChatAppCubit.get(context).sendMessage(
                                    receiverId: Contact.uId!,
                                    dateTime: DateTime.now().toString(),
                                    text: MsgBox.text);
                              }, icon: Transform.rotate(
                                  angle:-95,
                                  child: Icon(Icons.send_rounded,color: Colors.white,)),),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        },
      ),
    );
  }

  Row ContactMsgBubbleChat(BuildContext context , String UserMsg ) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  Stack(
                    alignment:AlignmentDirectional.bottomEnd,
                    children: [
                  Transform.translate(
                    offset: Offset(11,7.1),
                    child: Transform.rotate(
                        angle:90,
                        child: Icon(Icons.eject,color: HexColor("#EEEEEE"),)),
                  ),
                      Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: 40,
                              maxWidth: MediaQuery.of(context).size.width-40),
                          child: Container(
                            child:Padding(
                              padding: const EdgeInsets.only(top:1.0,right: 25,left:5),
                              child: Text(UserMsg,style: TextStyle(
                                fontFamily: "Cairo",
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),),
                            ),
                            decoration: BoxDecoration(
                                color:HexColor("#EEEEEE"),
                                borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Wed at 11:28",style: TextStyle(height: 1.2,fontSize: 8),),
                        ),
                      ],
                    ),


            ],
      ),
                  Transform.translate(
                    offset:Offset(7,-3),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage: NetworkImage(Contact.image.toString()),
                      backgroundColor: Colors.black,),
                  ),
                ],
              ),
    ),
          ],
        );
  }

  Align UserMsgBubbleChat(BuildContext context , String UserMsg) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Stack(
          alignment:AlignmentDirectional.bottomStart,
          children: [
            Transform.translate(
              offset: Offset(-11,6),
              child: Transform.rotate(
                  angle:-90,
                  child: Icon(Icons.eject)),
            ),
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: 40,
                      maxWidth: MediaQuery.of(context).size.width-40),
                  child: Container(
                    child:Padding(
                      padding: const EdgeInsets.only(top:1.0,right: 8,left:15),
                      child: Text(UserMsg,style: TextStyle(
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),),
                    ),
                    decoration: BoxDecoration(
                      color:HexColor("#E1F4FF"),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Wed at 11:28",style: TextStyle(height: 1.2,fontSize: 8),),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }
}
