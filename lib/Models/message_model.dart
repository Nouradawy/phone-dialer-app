class MessageModel
{
  String? DocID;
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? text;
  bool? Seen;
  bool? iSWriting;


  MessageModel({
    this.DocID,
    this.senderId,
    this.receiverId,
    this.dateTime,
    this.Seen,
    this.iSWriting,
    this.text,
  });

  MessageModel.fromJson(Map<String,dynamic>?json){

    senderId = json!["senderId"];
    receiverId = json["receiverId"];
    dateTime = json["dateTime"];
    text = json["text"];
    Seen = json["Seen"];
    iSWriting = json["iSWriting"];
    DocID = json["DocID"];
  }

  Map<String,dynamic>toMap(){
    return{
      "senderId":senderId,
      "reciverId": receiverId,
      "dateTime": dateTime,
      "text" :text,
      "Seen" : Seen,
      "iSWritting" : iSWriting,
      "DocID" : DocID,
    };
  }

  // Map<String,dynamic>MessageUpdaterMap(){
  //   return{
  //     "Seen" : Seen,
  //     "iSWriting" : iSWriting,
  //   };
  // }

}