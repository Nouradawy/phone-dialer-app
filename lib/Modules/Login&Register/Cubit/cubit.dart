import 'dart:io';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialer_app/Models/user_model.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/states.dart';
import 'package:dialer_app/Network/Local/cache_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



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


  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login(loginBehavior: LoginBehavior.webOnly);
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).then((value){
      CacheHelper.saveData(key: 'token', value: value.user?.uid);
      token = value.user?.uid;
      saveTokenToDatabase();
      if(value.additionalUserInfo?.isNewUser == true)
      {
        UserModel model = UserModel(
          name: value.user?.displayName,
          email: value.user?.email,
          phone: value.user?.phoneNumber,
          uId: value.user?.uid,
          bio: "Write your bio..",
          cover: "https://image.freepik.com/free-photo/positive-dark-skinned-young-woman-man-bump-fists-agree-be-one-team-look-happily-each-other-celebrates-completed-task-wear-pink-green-clothes-pose-indoor-have-successful-deal_273609-42756.jpg",
          image: value.user?.photoURL,
          isEmailVerified: false,
          IsOnline: true,
          LastSeen: Timestamp.now(),
          // tokens:"tokens",
        );
        FirebaseFirestore.instance.collection("Users").doc(value.user?.uid).set(model.toMap());
      }
      emit(DialerLoginSuccessState(value.user!.uid));
      return value;
    }).catchError((error){

      print(error.toString());
    });
  }
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential).then((value){
      CacheHelper.saveData(key: 'token', value: value.user?.uid);
      token = value.user?.uid;
      saveTokenToDatabase();
      if(value.additionalUserInfo?.isNewUser == true)
      {
        UserModel model = UserModel(
          name: value.user?.displayName,
          email: value.user?.email,
          phone: value.user?.phoneNumber,
          uId: value.user?.uid,
          bio: "Write your bio..",
          cover: "https://image.freepik.com/free-photo/positive-dark-skinned-young-woman-man-bump-fists-agree-be-one-team-look-happily-each-other-celebrates-completed-task-wear-pink-green-clothes-pose-indoor-have-successful-deal_273609-42756.jpg",
          image: value.user?.photoURL,
          isEmailVerified: false,
          IsOnline: true,
          LastSeen: Timestamp.now(),
          // tokens:"tokens",
        );
        FirebaseFirestore.instance.collection("Users").doc(value.user?.uid).set(model.toMap());
      }
      emit(DialerLoginSuccessState(value.user!.uid));
      return value;
    }).catchError((error){

      print(error.toString());
    });
  }
  List<UserInfo>? Providers;
bool FacebookLinked  = false;
bool GoogleLinked = false;

  Future<Future<UserCredential>?> LinkGoogleAccount() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return FirebaseAuth.instance.currentUser?.linkWithCredential(credential).then((value){
      //OnSuccess  =====

    }).catchError((error){
      print(error.toString());
    });
  }
  Future<Future<UserCredential>?> LinkFacebookAccount() async {
    final LoginResult loginResult = await FacebookAuth.instance.login(loginBehavior: LoginBehavior.webOnly);
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.currentUser?.linkWithCredential(facebookAuthCredential).then((value){
      //OnSuccess  =====
    }).catchError((error){
      print(error.toString());
    });
  }
  Future UnlinkFacebookAccount() async {
    return FirebaseAuth.instance.currentUser?.unlink('facebook.com').then((value){
      //OnSuccess  =====

    }).catchError((error){
      print(error.toString());
    });
  }

   void GetProvidersList() {
    Providers = FirebaseAuth.instance.currentUser?.providerData;
    Providers?[0].providerId == "facebook.com"?FacebookLinked = true :FacebookLinked=false;
  print(Providers?[0].providerId.toString());
  print(" facebook linked =  $FacebookLinked : Google = $GoogleLinked");
  }





void ListListner(){
  emit(NewMessageRecived());
}
}