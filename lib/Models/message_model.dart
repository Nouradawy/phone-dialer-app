class MessageModel
{
  String? senderId;
  String? receiverId;
  String? dateTime;
  late String text;


  MessageModel({
    this.senderId,
    this.receiverId,
    this.dateTime,
    required this.text,
  });

  MessageModel.fromJson(Map<String,dynamic>?json){
    senderId = json!["senderId"];
    receiverId = json["receiverId"];
    dateTime = json["dateTime"];
    text = json["text"];
  }

  Map<String,dynamic>toMap(){
    return{
      "senderId":senderId,
      "reciverId": receiverId,
      "dateTime": dateTime,
      "text" :text,
    };
  }
}