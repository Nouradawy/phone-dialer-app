import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Models/user_model.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/states.dart';
import 'package:dialer_app/Network/Local/cache_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';



class LoginCubit extends Cubit<LoginCubitStates>
{
  LoginCubit() : super(DialerLoginInitialState());

  String Textstate ="";
  static LoginCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  IconData? suffixIcon = Icons.visibility;


  void Passon(){
    isPassword =! isPassword;
    suffixIcon = isPassword ?Icons.visibility:Icons.visibility_off;
    emit(DialerIsPasswordState());
  }

  void userLogin({String? email , String? password}){
    emit(DialerLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.toString(),
      password: password.toString(),
    ).then((value){
      CacheHelper.saveData(key: 'token', value: value.user?.uid);
      token=value.user?.uid;
      saveTokenToDatabase();

      emit(DialerLoginSuccessState(value.user!.uid));
    }
    ).catchError((error){
      print(error.toString());
      emit(DialerLoginErrorState(error.toString()));
    });
  }
  Future<void> saveTokenToDatabase() async {
    // Assume user is logged in for this example
    String? DeviceToken = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(token)
        .update({
      'tokens': FieldValue.arrayUnion([DeviceToken]),
    });
  }


  void RegisterUser({String? name , String? email , String? phone , String? password , String? uId}) {
    Textstate = "Pushing your Data to our servers";
    emit(DialerLoadingRegisterUserState(Textstate));
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.toString(), password: password.toString()
    ).then((value){
      Textstate = "Dear $name your Account is Almost Ready, pushing last steps";
      emit(DialerSuccessRegisterUserState(Textstate));
      UserModel model = UserModel(
        name : name,
        email : email,
        phone : phone,
        uId : value.user?.uid,
        bio:"Write your bio..",
        cover:"https://image.freepik.com/free-photo/positive-dark-skinned-young-woman-man-bump-fists-agree-be-one-team-look-happily-each-other-celebrates-completed-task-wear-pink-green-clothes-pose-indoor-have-successful-deal_273609-42756.jpg",
        image:"https://as1.ftcdn.net/v2/jpg/02/68/62/04/1000_F_268620420_raIDjo1HJvtratuDz5z338yZ9QUcr7lZ.jpg",
        isEmailVerified: false,
        IsOnline: true,
        LastSeen: Timestamp.now(),
        // tokens:"tokens",

      );
      FirebaseFirestore.instance.collection("Users").doc(value.user!.uid).set(model.toMap()).then((value){

        Textstate = "Dear $name your Account is now Ready , please wait while we try signing you in";

        emit(DialerSuccessUserCreationState(Textstate));

        userLogin(email: "$email" , password: "$password");
      }).catchError((error){
        print("UserCreation error : " + error.toString());
        emit(DialerErrorUserCreationState());
      });

    }).catchError((error){
      print("Register User error : " + error.toString());
      emit(DialerErrorRegisterUserState());
    });
  }



  File? profileImage;
  File? CoverImage;
  String? ProfileImageURL;
  String? CoverImageURL;

  var picker = ImagePicker();

  Future getProfileImage() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile !=null){
      profileImage = File(pickedFile.path) ;

      uploadProfileImage("ProfileImage", profileImage);
      emit(SocialProfileImagePickedSuccessState());

    }
    else{
      print("no image selected");
      emit(SocialProfileImagePickeedErrorState());
    }
  }

  Future getCoverImage() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile !=null){
      CoverImage = File(pickedFile.path) ;


      uploadCoverImage("CoverImage", CoverImage);

      emit(SocialProfileImagePickedSuccessState());

    }
    else{
      print("no image selected");
      emit(SocialProfileImagePickeedErrorState());
    }
  }

  void uploadProfileImage(path , file)
  {
    firebase_storage.FirebaseStorage.instance.ref().child("user/ProfileImage/${Uri.file(path).pathSegments.last}").putFile(file).then((value) {

      value.ref.getDownloadURL().then((value) {

        print("image Url : " + value.toString());
        ProfileImageURL = value.toString();
        emit(SocialUploadImagePickedSuccessState());
      }).catchError((Error){
        print("Error on getting download link : " + Error.toString());
        emit(SocialUploadImageErrorState());
      });

    }).catchError((Error){
      print("Error on uploading the image : " + Error.toString());
      emit(SocialUploadImageErrorState());
    });
  }
  void uploadCoverImage(path , file)

  {
    firebase_storage.FirebaseStorage.instance.ref().child("user/CoverImage/${Uri.file(path).pathSegments.last}").putFile(file).then((value) {

      value.ref.getDownloadURL().then((value) {

        print("image Url : " + value.toString());
        CoverImageURL = value.toString();
        emit(SocialUploadImagePickedSuccessState());
      }).catchError((Error){
        print("Error on getting download link : " + Error.toString());
        emit(SocialUploadImageErrorState());
      });

    }).catchError((Error){
      print("Error on uploading the image : " + Error.toString());
      emit(SocialUploadImageErrorState());
    });
  }

  void updateUser({String? name , String? bio}){

    emit(SocialUpdateUserLoadingState());
    UserModel model = UserModel(
      name : name,
      bio : bio,
      uId: token,
      image: ProfileImageURL.toString(),
      cover:CoverImageURL.toString(),

    );
    //TODO:Fix Profile Updater impleminting it with new Cubit or useing streambuilder
    // print(CurrentUser[0].image.toString());
    // CurrentUser[0].image = ProfileImageURL;
    // CurrentUser[0].cover = CoverImageURL;

    FirebaseFirestore.instance.collection("Users").doc(token).update(model.toMap()).then(
            (value) {

          emit(SocialUpdateUserSuccessState());
        }).catchError((error){
      print("Error on update : " + error.toString());

      emit(SocialUpdateUserErrorState(error.toString()));
    });
  }
  // bool?NewMessage ;
  //  Future<bool?> NewMessageDetection (Userdata , index) async{
  //    await FirebaseFirestore.instance.collection("Users").doc(token).collection("chats").doc(Userdata.docs[index].data().uId).get().then((element){element.data()?.forEach((key, value) {
  //     if(key == "NewMessage")
  //     {
  //       if(value ==true)
  //         {
  //           NewMessage = true;
  //         } else {
  //         NewMessage =false;
  //       }
  //     }
  //   });
  //
  //   });
  //    print("value here :" + NewMessage.toString());
  //    print("Index value : " +index.toString());
  //    // emit(NewMessageRecived());
  //    return NewMessage;
  // }
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

      });
    });

  }

void ListListner(){
  emit(NewMessageRecived());
}
}