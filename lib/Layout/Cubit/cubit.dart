import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:dialer_app/Models/user_model.dart';
import 'package:dialer_app/Network/Local/cache_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Modules/Contacts/appcontacts.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  double AppbarSize = 0.09;
List<AppContact> Contacts = [];
List<AppContact> FilterdContacts = [];
List<AppContact> DialpadFilterdContacts = [];
List<AppContact> FavoratesContacts = [];

List SearchableCallerIDList = [];
List CallerID = [];

List PhoneCallLogs =[];
List PhoneCallLogsCallerID =[];

bool isSearching = false;
bool contactsLoaded = false;
bool isShowen = false;

  List<UserModel> ChatContacts =[];
  List<UserModel> CurrentUser = [];

Future<void> PermissionHandle() async {
  var status = await Permission.contacts.status;
  if (status.isDenied) {
    // We didn't ask for permission yet or the permission has been denied before but not permanently.
    await [
      Permission.contacts,
      Permission.phone,
      Permission.microphone,
    ].request();
  }

}

  void ThemeSwitcher()
  {

    ThemeSwitch = !ThemeSwitch;
    print("ThemeNow : $ThemeSwitch" );
    CacheHelper.saveData(key: "ThemeSwitch", value: ThemeSwitch);
    emit(ThemeUpdateState());
  }

  void GetChatContacts()async{
    emit(GetChatContactsLoadingState());
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
      emit(GetChatContactsSuccessState());
    }).catchError((error){
      print("GetChatContacts error : "+error.toString());
      emit(GetChatContactsErrorState(error));
    });
  }

void GetCallerID(PhoneNumberQuery,bool? InCall) {
  SearchableCallerIDList.clear();
   Contacts.map((element){
     SearchableCallerIDList.add({
       "CallerID" : element.info?.displayName.toString(),
       "PhoneNumber" :
         element.info?.phones?.map((e) {
          return e.value?.replaceAll(' ', '');
         }),

     });
   }).toList();

   CallerID = PhoneNumberQuery !=null ?SearchableCallerIDList.where((element) {
     String SearchIN = element["PhoneNumber"].toString();
     return SearchIN.contains(PhoneNumberQuery.toString());
   }).toList():[];
InCall ==true?emit(CallerIDSuccess()):null;
}


  Future<void> GetPhoneLog() async {
    (await CallLog.query()).map((element) {
      GetCallerID(element.number,false);
     return PhoneCallLogs.add(
          {
            "PhoneNumber": element.number,
            "ContactName": element.name!=null?element.name:CallerID.isNotEmpty?CallerID[0]["CallerID"].toString():"UNKNOWN",
            "PhoneState": element.callType.toString().replaceAll("CallType.",""),
            "Duration": element.duration,
            "Date":DateTime.fromMillisecondsSinceEpoch(element.timestamp!),
            "AccountID": element.phoneAccountId,
            "SIMname": element.simDisplayName,
      });
    }).toList();

    // PhoneCallLogs.map((element) {
    //   GetCallerID(element["PhoneNumber"]);
    //   element["ContactName"] = CallerID.isNotEmpty?CallerID[0]["CallerID"].toString():"UNKNOWN";
    // }).toList();
  }

  Future<void> GetContacts() async {
    emit(AppgetContactsLoading());
    List colors = [
      Colors.green,
      Colors.indigo,
      Colors.yellow,
      Colors.orange
    ];
    int colorIndex = 0;

    List<AppContact> _contacts = (await ContactsService.getContacts(withThumbnails: false).catchError((error){
      print("Contacts Error : " + error.toString());
    })).map((contact) {
      Color baseColor = colors[colorIndex];
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
      return AppContact(info: contact, color: baseColor , tag:contact.displayName![0].toUpperCase());
    }).toList();
    // final SortedContacts = _contacts..sort((a,b)=> a.info!.givenName!.compareTo(b.info!.givenName!));
      Contacts =_contacts;

      // contactsLoaded = true;
      emit(AppgetContactsSuccess());
  }


  void ShowHide(){
   emit(dailerInputSuccessstate());
  }

  void dialpadShow(){
    isShowen =! isShowen;
    emit(isShowenSuccessState());
  }


  filterContacts(TextEditingController SearchController){
    emit(SearchLoadingState());
    FilterdContacts.clear();
    FilterdContacts.addAll(Contacts);
    FilterdContacts.retainWhere((contact){
      String searchTerm = SearchController.text.toLowerCase();
      String contactName = contact.info!.displayName!.toLowerCase();
      return contactName.contains(searchTerm);
    });
    emit(SearchSuccessState());
  }
List<String> SearchTerm =[];
  List<AppContact> Firstchr = [];
  List<AppContact> secondchr = [];
  List<AppContact> thirdchr = [];

   Future DialpadSearch (TextEditingController dialerController) async{
    emit(SearchLoadingState());
    // if(dialerController.text[0].toString() == "2") {
    //   SearchTerm = ["a", "b", "c"];
    // }
    // if(dialerController.text[dialerController.text.length] == "3") {
    //   SearchTerm = ["d", "e", "f"];
    // }
    // if(dialerController.text[dialerController.text.length] == "4") {
    //   SearchTerm = ["g", "h", "i"];
    // }
    // if(dialerController.text[dialerController.text.length] == "5") {
    //   SearchTerm = ["j", "k", "l"];
    // }
    // if(dialerController.text[dialerController.text.length] == "6")
    //   SearchTerm = ["m","n","o"];
    // if(dialerController.text[dialerController.text.length] == "7")
    //   SearchTerm = ["p","q","r"];
    // if(dialerController.text[dialerController.text.length] == "8")
    //   SearchTerm = ["t","u","v"];
    // if(dialerController.text[dialerController.text.length] == "9")
    //   SearchTerm = ["w","x","y"];

    dialerController.text.isEmpty ?FilterdContacts.clear():null;
    Firstchr.clear();
    secondchr.clear();
    thirdchr.clear();
    FilterdContacts.isEmpty?Firstchr.addAll(Contacts):Firstchr.addAll(FilterdContacts);
    FilterdContacts.isEmpty?secondchr.addAll(Contacts):secondchr.addAll(FilterdContacts);
    FilterdContacts.isEmpty?thirdchr.addAll(Contacts):thirdchr.addAll(FilterdContacts);

    Firstchr.retainWhere((contact){
      String contactName = contact.info!.displayName![dialerController.text.length].toLowerCase();
print(SearchTerm[0]);
      return contactName.contains(SearchTerm[0]);

    });

    secondchr.retainWhere((contact){
      String contactName = contact.info!.displayName![dialerController.text.length].toLowerCase();
      return contactName.contains(SearchTerm[1]);
    });

    thirdchr.retainWhere((contact){
      String contactName = contact.info!.displayName![dialerController.text.length].toLowerCase();
      return contactName.contains(SearchTerm[2]);

    });
    if(FilterdContacts.isEmpty) {
      FilterdContacts.addAll(secondchr);
      FilterdContacts.addAll(Firstchr);
      FilterdContacts.addAll(thirdchr);
    }else {
      FilterdContacts.clear();
      FilterdContacts.addAll(secondchr);
      FilterdContacts.addAll(Firstchr);
      FilterdContacts.addAll(thirdchr);
    }

    emit(SearchSuccessState());
    }

}


