import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel
{
  String? name;
  String? email;
  String? phone;
  String? uId;
  // String? tokens;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified;
  bool? IsOnline;
  Timestamp? LastSeen;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.uId,
    this.image,
    this.cover,
    this.bio,
    this.isEmailVerified,
    this.IsOnline,
    this.LastSeen,
    // this.tokens
  });

  UserModel.fromJson(Map<String,dynamic>?json){
    email = json!['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    // tokens = json["tokens"];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    IsOnline = json['IsOnline'];
    LastSeen = json['LastSeen'];
  }

  Map<String,dynamic>toMap(){
    return{
      "name":name,
      "email": email,
      "phone":phone,
      "uId" : uId,
      "image" : image,
      "cover":cover,
      "bio" : bio,
      "isEmailVerified" : isEmailVerified,
      "IsOnline" : IsOnline,
      "LastSeen" : LastSeen,
      // "tokens" : tokens,
    };
  }
}