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

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.uId,
    this.image,
    this.cover,
    this.bio,
    this.isEmailVerified,
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
      // "tokens" : tokens,
    };
  }
}