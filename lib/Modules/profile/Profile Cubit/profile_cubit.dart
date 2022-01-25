import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Models/user_model.dart';
import 'package:dialer_app/Modules/profile/Profile%20Cubit/profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class ProfileCubit extends Cubit<ProfileStates>{
ProfileCubit() : super (ProfileStatesInitial());
static ProfileCubit get(context) => BlocProvider.of(context);

List<UserModel> ChatContacts =[];
List<UserModel> CurrentUser = [];


  File? profileImage;
  File? CoverImage;
  String? ProfileImageURL;
  String? CoverImageURL;

  var picker = ImagePicker();

  Future ProfileImagePicker() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile !=null){
      profileImage = File(pickedFile.path) ;

      //TODO:Spleting Uploading the image from Profile image Picker Due to the image will be Uploaded without User Concent
      uploadProfileImage("ProfileImage", profileImage);
      emit(ProfileImagePickedSuccess());

    }
    else{
      print("no image selected");
      emit(ProfileImagePickedError());
    }
  }

  Future CoverImagePicker() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile !=null){
      CoverImage = File(pickedFile.path) ;


      uploadCoverImage("CoverImage", CoverImage);

      emit(CoverImagePickedSuccess());

    }
    else{
      print("no image selected");
      emit(CoverImagePickedError());
    }
  }

  void uploadProfileImage(path , file)
  {
    firebase_storage.FirebaseStorage.instance.ref().child("user/ProfileImage/${Uri.file(path).pathSegments.last}").putFile(file).then((value) {

      value.ref.getDownloadURL().then((value) {

        print("image Url : " + value.toString());
        ProfileImageURL = value.toString();
        emit(UploadProfileImageSuccess());
      }).catchError((Error){
        print("Error on getting download link : " + Error.toString());
        emit(UploadProfileImageError());
      });

    }).catchError((Error){
      print("Error on uploading the image : " + Error.toString());
      emit(UploadProfileImageError());
    });
  }
  void uploadCoverImage(path , file)

  {
    firebase_storage.FirebaseStorage.instance.ref().child("user/CoverImage/${Uri.file(path).pathSegments.last}").putFile(file).then((value) {

      value.ref.getDownloadURL().then((value) {

        print("image Url : " + value.toString());
        CoverImageURL = value.toString();
        emit(UploadCoverImageSuccess());
      }).catchError((Error){
        print("Error on getting download link : " + Error.toString());
        emit(UploadCoverImageError());
      });

    }).catchError((Error){
      print("Error on uploading the image : " + Error.toString());
      emit(UploadCoverImageError());
    });
  }

  void updateUser({String? name , String? bio}){
    emit(UpdateUserInfoLoading());
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

          emit(UpdateUserInfoSuccess());
        }).catchError((error){
      print("Error on update : " + error.toString());

      emit(UpdateUserInfoError());
    });
  }


void GetChatContacts()async{
  ChatContacts.clear();
  await FirebaseFirestore.instance.collection("Users").get().then((value){
    value.docs.forEach((element)
    {
      if(element.data()['uId'] != token) {
        ChatContacts.add(UserModel.fromJson(element.data()));
      } else {
        CurrentUser.clear();
        CurrentUser.add(UserModel.fromJson(element.data()));
      }
    }

    );
    emit(ExtractCurrrentUserInfoSuccess());
  }).catchError((error){
    print("GetChatContacts error : "+error.toString());
    emit(ExtractCurrrentUserInfoError());
  });
}



}