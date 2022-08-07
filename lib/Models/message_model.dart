class MessageModel
{
  String? DocID;
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? text;
  bool? Seen;
  bool? iSWriting;
  String? Senderimage;
  String? SenderName;
  String? SenderPhone;


  MessageModel({
    this.DocID,
    this.senderId,
    this.receiverId,
    this.dateTime,
    this.Seen,
    this.iSWriting,
    this.text,
    this.SenderName,
    this.Senderimage,
    this.SenderPhone,
  });

  MessageModel.fromJson(Map<String,dynamic>?json){

    senderId = json!["senderId"];
    receiverId = json["receiverId"];
    dateTime = json["dateTime"];
    text = json["text"];
    Seen = json["Seen"];
    iSWriting = json["iSWriting"];
    DocID = json["DocID"];
    Senderimage = json["Senderimage"];
    SenderName = json["SenderName"];
    SenderPhone = json["SenderPhone"];

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
      "Senderimage" : Senderimage,
      "SenderName" : SenderName,
      "SenderPhone" : SenderPhone,
    };
  }

  // Map<String,dynamic>MessageUpdaterMap(){
  //   return{
  //     "Seen" : Seen,
  //     "iSWriting" : iSWriting,
  //   };
  // }

}