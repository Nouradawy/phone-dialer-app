import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Models/user_model.dart';
import 'package:dialer_app/Models/message_model.dart';
import 'package:dialer_app/Modules/Chat/Cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatAppCubit extends Cubit<ChatAppCubitStates>{
ChatAppCubit() : super(ChatAppCubitInitialState());
static ChatAppCubit get(context) => BlocProvider.of(context);
void sendMessage({
  required String receiverId,
  required String dateTime,
  required String text,
}){
  MessageModel model = MessageModel(
    text:text,
    senderId: token,
    receiverId: receiverId,
    dateTime:dateTime,
  );

  FirebaseFirestore.instance
  .collection("Users")
  .doc(token)
  .collection("chats")
  .doc(receiverId)
  .collection("messages")
  .add(model.toMap())
  .then((value)
  {
    emit(SendMessageSuccessState());
  }

  ).catchError((error){
    emit(SendMessageErrorState());
  });

  FirebaseFirestore.instance
  .collection("Users")
  .doc(receiverId)
  .collection("chats")
  .doc(token)
  .collection("messages")
  .add(model.toMap())
  .then((value)
  {
    emit(SendMessageSuccessState());
  }

  ).catchError((error){
    emit(SendMessageErrorState());
  });
}

List<MessageModel> messages =[];

void GetMessages({
  required String  receiverId,
})
{
  FirebaseFirestore.instance
      .collection("Users")
      .doc(token)
      .collection("chats")
      .doc(receiverId)
      .collection("messages")
  .orderBy("dateTime")
      .snapshots()
      .listen((event)
  {
    messages.clear();
    event.docs.forEach((element){
      messages.add(MessageModel.fromJson(element.data()));
    });
    emit(GetMessageSuccessState());
  });

}
}