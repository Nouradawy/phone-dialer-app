import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Models/user_model.dart';
import 'package:dialer_app/Models/message_model.dart';
import 'package:dialer_app/Modules/Chat/Cubit/states.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatAppCubit extends Cubit<ChatAppCubitStates>{
ChatAppCubit() : super(ChatAppCubitInitialState());
static ChatAppCubit get(context) => BlocProvider.of(context);
var MsgBox = TextEditingController();
List<MessageModel> messages =[];
bool NewMessage = false;


MessageModel? model;
void sendMessage({
  required String receiverId,
  required String dateTime,
  required String text,
}){
  model = MessageModel(
    text:text,
    senderId: token,
    receiverId: receiverId,
    dateTime:dateTime,
    Seen: false,
    iSWriting: false,
  );

  NewMessage = !NewMessage;
  print('NewMessage : ' + NewMessage.toString());

  FirebaseFirestore.instance
  .collection("Users")
  .doc(token)
  .collection("chats")
  .doc(receiverId)
  .collection("messages")
  .add(model!.toMap())
  .then((value)
  {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(token)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .doc(value.id).update({"DocID": value.id});

    FirebaseFirestore.instance
        .collection("Users")
        .doc(receiverId)
        .collection("chats")
        .doc(token)
        .collection("messages")
        .doc(value.id).set({
      "text":text,
      "senderId": token,
      "receiverId": receiverId,
      "dateTime":dateTime,
      "Seen": false,

      "DocID": value.id,
    });

    FirebaseFirestore.instance
        .collection("Users")
        .doc(receiverId)
        .set({
      "NewMessage": !NewMessage,

    },
      SetOptions(merge: true),
    );


    print(value.id.toString());
    emit(SendMessageSuccessState());
  }

  ).catchError((error){
    emit(SendMessageErrorState());
  });

}





void MessageStateUpdater({
    required String receiverId,
    required String DocID,
  }) {

  FirebaseFirestore.instance.collection("Users")
      .doc(token)
      .collection("chats")
      .doc(receiverId)
      .collection("messages")
      .doc(DocID)
      .update({
    "Seen": true,
    "iSWriting": MsgBox.text.isNotEmpty ? true : false,
  })
      .then((value)
  {

  }).catchError((Error) {
    print("while updateing MessageState and Error havebeen ocured : " +
        Error.toString());
  });
}

void UserWrittingDetection({
  required String receiverId,
}){
  FirebaseFirestore.instance
      .collection("Users")
      .doc(token)
      .collection("chats")
      .doc(receiverId)
      .set({
    "iSWriting":MsgBox.text.isEmpty?false:true,

  },
    SetOptions(merge: true),
  );
}

  List ListUnSeenMsg=[];
  List ListUnSeentokens=[];
  List UnseenTokens =[];
  List ListUnseenMsgs =[];


  void ListCount() async {


    await FirebaseFirestore.instance.collection("Users").get().then((value)  {


      value.docs.forEach((Element)
      async {

        if (Element.data()['uId'] != token) {
          await FirebaseFirestore.instance.collection("Users").doc(token).collection("chats").doc(Element.data()['uId']).collection("messages").get().then((value) {
            /// for each unseen msg from only one person it will grow the list +1
            for (var element in value.docs) {
              if (element.data()['Seen'] == false) {

                ListUnSeenMsg.add({
                  "Name":Element.data()["name"],
                  "image":Element.data()["image"],
                  "token":Element.id,
                  "text":element.data()["text"]});
                ListUnSeentokens.add(Element.id);
              }
            }
          });

          // NewMessageCount == true ? ListSize.add() : null;

        }


        // print("List at ListCount : " + ListUnSeenMsg.toString());
        // print("Listof unseentokens" + UnseenTokens.toString());
        // emit(NewMessageRecivedState());
      });

    });

  }

  int Count=0;

  void ScreenUpdate(){
    ListUnseenMsgs.clear();
    UnseenTokens = ListUnSeentokens.toSet().toList();
    print("item count from screen updating : " + ListUnSeenMsg.toString());
    UnseenTokens.forEach((e) {
          ListUnseenMsgs.add({
            "token": e,
            "text": ListUnSeenMsg.map((element) =>e == element["token"]?element["text"]:null).toList(),
            "Name": ListUnSeenMsg.map((element) =>e == element["token"]?element["Name"]:null).toList(),
            "image": ListUnSeenMsg.map((element) =>e == element["token"]?element["image"]:null).toList(),
            "Length":"",
          });
      });

    for(var i=0 ; i<ListUnseenMsgs.length ; i++) {
      ListUnseenMsgs[i]["text"].removeWhere((element) => element == null);
      ListUnseenMsgs[i]["Name"].removeWhere((element) => element == null);
      ListUnseenMsgs[i]["image"].removeWhere((element) => element == null);
      ListUnseenMsgs[i]["text"].forEach((e){
        Count++;
      });

      ListUnseenMsgs[i]["Length"] = Count.toString();
      ListUnseenMsgs[i]["Name"] = ListUnseenMsgs[i]["Name"][0];
      ListUnseenMsgs[i]["image"] = ListUnseenMsgs[i]["image"][0];
      Count=0;
    }
    print("Newlist after removing nulls from list : ${ListUnseenMsgs}");
    ListUnSeenMsg.clear();
    ListUnSeentokens.clear();
    UnseenTokens.clear();
    emit(NewMessageRecivedState());

  }

}