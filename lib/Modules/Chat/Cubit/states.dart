abstract class ChatAppCubitStates{}

class ChatAppCubitInitialState extends ChatAppCubitStates{}
class SendMessageSuccessState extends ChatAppCubitStates{}
class SendMessageErrorState extends ChatAppCubitStates{}
class GetMessageSuccessState extends ChatAppCubitStates{}
class GetMessageErrorState extends ChatAppCubitStates{}
class MessageStateUpdatedSuccess extends ChatAppCubitStates{}
class MessageStateUpdatedError extends ChatAppCubitStates{}
class NewMessageRecivedState extends ChatAppCubitStates{}
