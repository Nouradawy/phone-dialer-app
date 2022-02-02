
import 'dart:typed_data';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:call_log/call_log.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:hexcolor/hexcolor.dart';

import '../appcontacts.dart';
import 'contacts_states.dart';

class PhoneContactsCubit extends Cubit<PhoneContactStates>{
  PhoneContactsCubit() : super(ContactsInitialState());
  static PhoneContactsCubit get(context) => BlocProvider.of(context);

  List<AppContact> Contacts = [];
  List<AppContact> ContactsNoThumb = [];
  List<AppContact> FavoratesContacts = [];
  List FavoratesContactsID = [];
  List PhoneCallLogs =[];
  List SearchableCallerIDList = [];
  List CallerID = [];
  String? faceImage;
  String? faceProfilelink;


  List BaseColors =[
    HexColor("#515150"),
    HexColor("#FF4B76"),
    HexColor("#2C087A"),
    HexColor("#C6C972"),

  ];
  Color? FavoratesItemColor ;
  int ColorIndex =0;

  void GetShardPrefrancesData(){

    if(FavoratesContactids.isNotEmpty && FavoratesContacts.isEmpty )
    {
      FavoratesContactsID = FavoratesContactids;
      FavoratesContactsID.forEach((id) {
        Contacts.forEach((element) {
          if (id == element.info?.id)
            FavoratesContacts.add(element);
        });
      });
    }
    }


  void FavoratesItemColors(){
    FavoratesItemColor = BaseColors[ColorIndex];
    ColorIndex == BaseColors.length-1?ColorIndex = 0:ColorIndex++;

  }

  Future<Uint8List> ToUint8List(URL) async {
    return (await NetworkAssetBundle(Uri.parse(URL)).load(URL)).buffer.asUint8List();
  }

  Future<void> GetRawContacts() async {
    List colors = [
      Colors.green,
      Colors.indigo,
      Colors.yellow,
      Colors.orange
    ];
    int colorIndex = 0;

    List<AppContact> _contacts = (await FlutterContacts.getContacts(withProperties: true, withPhoto: true , withAccounts: true , withThumbnail: true ).catchError((error){
      print("Contacts Error : " + error.toString());
    })).map((contact) {
      Color baseColor = colors[colorIndex];
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
      return AppContact(info: contact, color: baseColor , tag:contact.displayName[0].toUpperCase());
    }).toList();

    Contacts =_contacts;

    Contacts.forEach((element) {
      element.info!.thumbnail == null?ContactsNoThumb.add(element):null;});


      emit(RawContactsSuccessState());
  }

  void GetCallerID(PhoneNumberQuery) {

    SearchableCallerIDList.clear();
    Contacts.map((element){
      SearchableCallerIDList.add({
        "CallerID" : element.info?.displayName.toString(),
        "PhoneNumber" :
        element.info?.phones.map((e) {
          return e.number.replaceAll(' ', '');
        }),

      });
    }).toList();

    CallerID = PhoneNumberQuery !=null ?
    SearchableCallerIDList.where((element) {
      String SearchIN = element["PhoneNumber"].toString();
      return SearchIN.contains(PhoneNumberQuery.toString());
    }).toList():[];

  }

  // Future<void> GetPhoneLog()  async{
  //     (await CallLog.get())
  //         .map((element) {
  //       element.name == null ? GetCallerID(element.number) : null;
  //       return PhoneCallLogs.add({
  //         "PhoneNumber": element.number,
  //         "ContactName": element.name != null
  //             ? element.name
  //             : CallerID.isNotEmpty
  //             ? CallerID[0]["CallerID"].toString()
  //             : "UNKNOWN",
  //         "PhoneState": element.callType.toString().replaceAll("CallType.", ""),
  //         "Duration": element.duration,
  //         "Date": DateTime.fromMillisecondsSinceEpoch(element.timestamp!),
  //         "AccountID": element.phoneAccountId,
  //         "SIMname": element.simDisplayName,
  //       });
  //     }).toList();
  //
  //   emit(PhoneLogsExtractionSuccessful());
  // }


  bool? isSearching;


  List<AppContact> FilterdContacts = [];
  List<AppContact> DialpadFilterdContacts = [];
  Iterable<CallLogEntry> PhoneLog = <CallLogEntry>[];

  List<String> SearchTerm =[];
  List<AppContact> Firstchr = [];
  List<AppContact> secondchr = [];
  List<AppContact> thirdchr = [];


//This Function Used to SearchAndFilter Contacts Based on there Name [Used at the top searchBar]

  void SearchContacts(TextEditingController SearchController, contacts){
    FilterdContacts.clear();
    FilterdContacts.addAll(contacts);
    FilterdContacts.retainWhere((contact){
      String searchTerm = SearchController.text.toLowerCase();
      String contactName = contact.info!.displayName.toLowerCase();
      return contactName.contains(searchTerm);
    });
    emit(SearchContactsFinished());
  }


 Future DialpadSearch (TextEditingController dialerController) async{
    // if(dialerController.text[0] == "2") {
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
   try
   {
      dialerController.text.isEmpty ? FilterdContacts.clear() : null;
      Firstchr.clear();
      secondchr.clear();
      thirdchr.clear();

      if (FilterdContacts.isEmpty) {
        Firstchr.addAll(Contacts);
        secondchr.addAll(Contacts);
        thirdchr.addAll(Contacts);
      } else {
        Firstchr.addAll(FilterdContacts);
        secondchr.addAll(FilterdContacts);
        thirdchr.addAll(FilterdContacts);
      }

      Firstchr.retainWhere((contact) {
        String contactName = contact.info!.displayName[dialerController.text.length].toLowerCase();
        return contactName.contains(SearchTerm[0]);
      });

      secondchr.retainWhere((contact) {
        String contactName = contact.info!.displayName[dialerController.text.length].toLowerCase();
        return contactName.contains(SearchTerm[1]);
      });

      thirdchr.retainWhere((contact) {
        String contactName = contact.info!.displayName[dialerController.text.length].toLowerCase();
        return contactName.contains(SearchTerm[2]);
      });

      if (FilterdContacts.isEmpty) {
        FilterdContacts.addAll(Firstchr);
        FilterdContacts.addAll(secondchr);
        FilterdContacts.addAll(thirdchr);
      } else {
        FilterdContacts.clear();
        FilterdContacts.addAll(Firstchr);
        FilterdContacts.addAll(secondchr);
        FilterdContacts.addAll(thirdchr);
      }
    } catch(error){
     return print("error ocuured : $error");
   }

    emit(dialPadSearchSuccessState());
  }


}

