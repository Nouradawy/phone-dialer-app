import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Models/user_model.dart';
import 'package:dialer_app/Models/message_model.dart';
import 'package:dialer_app/Modules/Chat/Cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatAppCubit extends Cubit<ChatAppCubitStates>{
ChatAppCubit() : super(ChatAppCubitInitialState());
static ChatAppCubit get(context) => BlocProvider.of(context);
var MsgBox = TextEditingController();
List<MessageModel> messages =[];


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
      "iSWriting": false,
      "DocID": value.id,
    });

      FirebaseFirestore.instance
          .collection("Users")
          .doc(token)
          .collection("chats")
          .doc(receiverId)
          .set({
        "NewMessage":true,

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



// void GetMessages({
//   required String  receiverId,
// })
// {
//   FirebaseFirestore.instance
//       .collection("Users")
//       .doc(token)
//       .collection("chats")
//       .doc(receiverId)
//       .collection("messages")
//   .orderBy("dateTime")
//       .snapshots()
//       .listen((event)
//   {
//     event.docChanges.map((e) => e.doc.data().)
//         print("event changes = isnot empty");
//         messages.clear();
//       event.docs.forEach((element){
//         messages.add(
//             MessageModel.fromJson(element.data())
//         );
//       });
//         emit(GetMessageSuccessState());
//
//     // emit(GetMessageSuccessState());
//   });
//
// }

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
    FirebaseFirestore.instance
      .collection("Users")
      .doc(token)
      .collection("chats")
      .doc(receiverId)
      .set({
    "NewMessage":false,
    },
      SetOptions(merge: true),);
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

  int ListSize=0;
  Future<void> ListCount() async {
    ListSize =  0;
    await FirebaseFirestore.instance.collection("Users").get().then((value)  {

      value.docs.forEach((element)
      async {
        if (element.data()['uId'] != token) {
          bool? NewMessageCount;
          await FirebaseFirestore.instance.collection("Users").doc(token).collection("chats").doc(element
              .data()
          ['uId']
              .toString()).collection("messages").get().then((value) {
            for (var element in value.docs) {
              if (element.data()['Seen'] == false) {
                NewMessageCount = true;
              } else {
                NewMessageCount == true? NewMessageCount=true:NewMessageCount=false;
              }
            }
          });

          NewMessageCount == true ? ListSize++ : null;

        }
        print("item count : " + ListSize.toString());
        emit(NewMessageRecivedState());
      });
    });

  }

}