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
bool UserAvilableAtMessenger = false;


MessageModel? model;
void sendMessage({
  required String receiverId,
  required String dateTime,
  required String text,
  required String SenderImage,
  required String SenderName,
  required String SenderPhone,
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
            .collection("UnSeenChat")
            .doc(token)
            .collection("messages")
            .doc(value.id)
            .set({
          "text": text,
          "senderId": token,
          "dateTime": dateTime,
          "Senderimage":SenderImage,
          "SenderName" : SenderName,
          "SenderPhone":SenderPhone,
        });

    FirebaseFirestore.instance
        .collection("Users")
        .doc(receiverId)
        .collection("UnSeenChat")
        .doc(token).set({
      "dummy":true,
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



void UnseenMsgesClear({
  required String receiverId,
}) {
  //  FirebaseFirestore.instance
  //     .collection("Users")
  //     .doc(token)
  //     .collection("UnSeenChat")
  //     .doc(receiverId).collection("messages").get().then((snapshot){
  //       snapshot.docs.forEach((element) {
  //         element.reference.delete();
  //       });
  // });
   FirebaseFirestore.instance
       .collection("Users")
       .doc(token)
       .collection("UnSeenChat").doc(receiverId).delete();
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


  
  

}