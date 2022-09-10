
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
import 'package:flutter_contacts/properties/address.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../appcontacts.dart';
import 'contacts_states.dart';

class PhoneContactsCubit extends Cubit<PhoneContactStates>{
  PhoneContactsCubit() : super(ContactsInitialState());
  static PhoneContactsCubit get(context) => BlocProvider.of(context);
  bool isFabExtended = true;
  int DefaultPhoneAccountIndex = 0;
  List<AppContact> Contacts = [];
  List<AppContact> ContactsNoThumb = [];
  List<AppContact> FavoratesContacts = [];
  List FavoratesContactsID = [];

  List SearchableCallerIDList = [];
  List CallerID = [];
  String? faceImage;
  String? faceProfilelink;
  bool ContactIdExist = true;

  bool DNtoggler=false;
  bool PNtoggler=false;
  List<PhoneLabel> PhoneSideMenu = <PhoneLabel>[PhoneLabel.mobile,PhoneLabel.home,PhoneLabel.work,PhoneLabel.faxWork,PhoneLabel.faxHome,PhoneLabel.pager,PhoneLabel.other,PhoneLabel.custom];
  List<EmailLabel> EmailSideMenu = <EmailLabel>[EmailLabel.home,EmailLabel.work,EmailLabel.other,EmailLabel.custom];
  List<EventLabel> EventSideMenu = <EventLabel>[EventLabel.birthday,EventLabel.anniversary,EventLabel.other,EventLabel.custom];
  List<AddressLabel> AddressSideMenu = <AddressLabel>[AddressLabel.home,AddressLabel.work,AddressLabel.school,AddressLabel.other,AddressLabel.other,AddressLabel.custom];
  // List<Label> RelatedSideMenu = ['Friend','Manager','Assistant','Met through','Client','Brother','Sister','Mother','Father','Sister','Spouse','Child','Custom'];
  List<SocialMediaLabel> ChatSideMenu = <SocialMediaLabel>[SocialMediaLabel.qqchat,SocialMediaLabel.skype,SocialMediaLabel.yahoo,SocialMediaLabel.aim,SocialMediaLabel.icq,SocialMediaLabel.facebook,SocialMediaLabel.discord,SocialMediaLabel.custom];
  List<TextEditingController> PhoneNumberController = [];
  List<PhoneLabel> PhoneSideMenuController = <PhoneLabel>[] ;
  List<TextEditingController> EmailAddressController = <TextEditingController>[];
  List<EmailLabel> EmailSideMenuController=<EmailLabel>[];
  List<TextEditingController> AddressController = [];
  List<AddressLabel> AddressSideMenuController = <AddressLabel>[];

  List<TextEditingController> EventController= [];
  List<EventLabel> EventSideMenuController =<EventLabel>[];

  List<TextEditingController> ChatController = [];
  List<SocialMediaLabel> ChatSideMenuController=<SocialMediaLabel>[];

  int PhoneNumberTextFormCount=0;
  int EmailTextFormCount=0;
  int AddressTextFormCount=0;
  int EventTextFormCount=0;
  int ChatTextFormCount=0;
  bool NoteEditting=false;
  TextEditingController NotesController= TextEditingController();

  void TextFormFieldInitialize(List NumbersInAccount , AppContact contact){

    if(NumbersInAccount.isNotEmpty)
    {
      PhoneNumberTextFormCount = NumbersInAccount.length;
      NumbersInAccount.add({
        "label": PhoneSideMenu.first,
        "number": "",
      });

      for (int i = 0; i <= PhoneNumberTextFormCount; i++) {
        PhoneNumberController.add(TextEditingController());
        PhoneNumberController[i].text = NumbersInAccount[i]['number'];
        PhoneSideMenuController.add(NumbersInAccount[i]["label"]);
      }
    } else {
      PhoneNumberController.add(TextEditingController());
      PhoneSideMenuController.add(PhoneSideMenu.first);
    }
  if(contact.info!.emails.isNotEmpty)
  {
      for (int i = 0; i <= contact.info!.emails.length; i++) {
        EmailAddressController.add(TextEditingController());
        i < contact.info!.emails.length?EmailAddressController[i].text = contact.info!.emails[i].address:null;
        i < contact.info!.emails.length?EmailSideMenuController.add(contact.info!.emails[i].label):null;
      }
    } else { EmailAddressController.add(TextEditingController());
      EmailSideMenuController.add(EmailSideMenu.first);}

  if(contact.info!.addresses.isNotEmpty)
  {
      for (int i = 0; i <= contact.info!.addresses.length; i++) {
        AddressController.add(TextEditingController());
        i < contact.info!.addresses.length?AddressController[i].text = contact.info!.addresses[i].address:null;
        i < contact.info!.addresses.length? AddressSideMenuController.add(contact.info!.addresses[i].label):null;
      }
    } else {
    AddressController.add(TextEditingController());
    AddressSideMenuController.add(AddressSideMenu.first);
  }

  if(contact.info!.socialMedias.isNotEmpty)
  {
      for (int i = 0; i <= contact.info!.socialMedias.length; i++) {
        ChatController.add(TextEditingController());
        i < contact.info!.socialMedias.length? ChatController[i].text = contact.info!.socialMedias[i].userName:null;
        i < contact.info!.socialMedias.length?ChatSideMenuController.add(contact.info!.socialMedias[i].label):null;
      }
    } else {
    ChatController.add(TextEditingController());
    ChatSideMenuController.add(ChatSideMenu.first);
  }


  if(contact.info!.events.isNotEmpty)
  {
    for (int i = 0; i <= (contact.info!.events.length); i++) {
      print(contact.info!.events.length);
        EventController.add(TextEditingController());

        i < contact.info!.events.length?EventController[i].text =DateFormat.yMMMd().format(DateTime(contact.info!.events[i].year!,contact.info!.events[i].month,contact.info!.events[i].day)):null;
        i < contact.info!.events.length?EventSideMenuController.add(contact.info!.events[i].label):null;
      print(EventController.length);
      }
  } else {
    EventController.add(TextEditingController());
    EventSideMenuController.add(EventSideMenu.first);
  }

    emit(TextFormInitialize());
  }


  void PhoneNumberadd(bool? ToAdd ){

  if(ToAdd ==true)
  {
      PhoneNumberTextFormCount++;
      PhoneNumberController.add(TextEditingController());
      PhoneSideMenuController.add(PhoneSideMenu.first);
    } else {
    PhoneNumberTextFormCount--;
    PhoneNumberController.removeLast();
    PhoneSideMenuController.removeLast();
  }
    // NumbersInAccount.add("");
  emit(PhoneNumberAddState());
  // ToAdd =false;
  }
  void EmailAddressAdd(bool? ToAdd ){

  if(ToAdd ==true)
  {
    EmailTextFormCount++;
    EmailAddressController.add(TextEditingController());
    EmailSideMenuController.add(EmailSideMenu.first);
    } else {
    EmailTextFormCount--;
    EmailAddressController.removeLast();
    EmailSideMenuController.removeLast();
  }
    // NumbersInAccount.add("");
  emit(EmailAddressAddSuccessState());
  // ToAdd =false;
  }
  void AddressAdd(bool? ToAdd ){

  if(ToAdd ==true)
  {
    AddressTextFormCount++;
    AddressController.add(TextEditingController());
    AddressSideMenuController.add(AddressSideMenu.first);
    } else {
    AddressTextFormCount--;
    AddressController.removeLast();
    AddressSideMenuController.removeLast();
  }
    // NumbersInAccount.add("");
  emit(AddressAddSuccessState());
  // ToAdd =false;
  }
  void EventAdd(bool? ToAdd ){

  if(ToAdd ==true)
  {
    EventTextFormCount++;
    EventController.add(TextEditingController());
    EventSideMenuController.add(EventSideMenu.first);
    } else {
    EventTextFormCount--;
    EventController.removeLast();

    EventSideMenuController.removeLast();
  }
    // NumbersInAccount.add("");
  emit(EventAddSuccessState());
  // ToAdd =false;
  }
  void ChatUserNameAdd(bool? ToAdd ){

  if(ToAdd ==true)
  {
    ChatTextFormCount++;
    ChatController.add(TextEditingController());
    ChatSideMenuController.add(ChatSideMenu.first);
    } else {
    ChatTextFormCount--;
    ChatController.removeLast();
    ChatSideMenuController.removeLast();
  }
    // NumbersInAccount.add("");
  emit(PhoneNumberAddState());
  // ToAdd =false;
  }

  void AddNote(){
    NoteEditting = !NoteEditting;
    emit(DropDownDisplayName());
  }

  void ContactUpdate(AppContact contact,context){
    contact.info?.phones.clear();
    for(int i=0 ; i<PhoneNumberController.length; i++) {

      PhoneNumberController[i].text.isNotEmpty?contact.info?.phones.add(Phone('${PhoneNumberController[i].text}', label: PhoneSideMenuController[i] )):null;
    }

    contact.info?.emails.clear();
    for(int i=0 ; i<EmailAddressController.length ; i++) {
      EmailAddressController[i].text.isNotEmpty?contact.info?.emails.add(Email(EmailAddressController[i].text , label:EmailSideMenuController[i])):null;

    }
    // //
    contact.info?.addresses.clear();
    for(int i=0 ; i<AddressController.length; i++) {
      AddressController[i].text.isNotEmpty?contact.info?.addresses.add(Address(AddressController[i].text , label: AddressSideMenuController[i])):null;
    }
    // //
    contact.info?.events.clear();
    for(int i=0 ; i<EventController.length ; i++) {
      EventController[i].text.isNotEmpty?contact.info?.events.add(Event(year:DateFormat('yMMMd').parse(EventController[i].text).year,month: DateFormat('yMMMd').parse(EventController[i].text).month, day: DateFormat('yMMMd').parse(EventController[i].text).day)):null;
    }
    // //
    contact.info?.socialMedias.clear();

      for (int i = 0; i < ChatController.length; i++) {
        ChatController[i].text.isNotEmpty? contact.info?.socialMedias.add(SocialMedia(ChatController[i].text, label: ChatSideMenuController[i])) : null;
      }


    contact.info?.update();
    Navigator.pop(context);
    PhoneContactsCubit.get(context).PhoneNumberController.clear();
    PhoneContactsCubit.get(context).PhoneSideMenuController.clear();
    PhoneContactsCubit.get(context).EmailAddressController.clear();
    PhoneContactsCubit.get(context).EmailSideMenuController.clear();
    PhoneContactsCubit.get(context).AddressController.clear();
    PhoneContactsCubit.get(context).AddressSideMenuController.clear();
    PhoneContactsCubit.get(context).ChatController.clear();
    PhoneContactsCubit.get(context).ChatSideMenuController.clear();
    PhoneContactsCubit.get(context).EventController.clear();
    PhoneContactsCubit.get(context).EventSideMenuController.clear();
    emit(ChatAddSuccessState());
  }
  void ContactCancel(AppContact contact,context){
    Navigator.pop(context);
    PhoneContactsCubit.get(context).PhoneNumberController.clear();
    PhoneContactsCubit.get(context).PhoneSideMenuController.clear();
    PhoneContactsCubit.get(context).EmailAddressController.clear();
    PhoneContactsCubit.get(context).EmailSideMenuController.clear();
    PhoneContactsCubit.get(context).AddressController.clear();
    PhoneContactsCubit.get(context).AddressSideMenuController.clear();
    PhoneContactsCubit.get(context).ChatController.clear();
    PhoneContactsCubit.get(context).ChatSideMenuController.clear();
    PhoneContactsCubit.get(context).EventController.clear();
    PhoneContactsCubit.get(context).EventSideMenuController.clear();
    emit(ChatAddSuccessState());
  }

  List BaseColors =[
    HexColor("#515150"),
    HexColor("#FF4B76"),
    HexColor("#2C087A"),
    HexColor("#C6C972"),
  ];
  Color? FavoratesItemColor ;
  int ColorIndex =0;



  void DisplayNameToggle(){
    DNtoggler = !DNtoggler;
    emit(DropDownDisplayName());
  }
  void PhoneticNameToggle(){
    PNtoggler = !PNtoggler;
    emit(DropDownPhonaticName());
  }

  void SideMenuUpdater(){
    emit(SideMenuUpdated());
  }
  // void GetShardPrefrancesData(){
  //
  //   if(FavoratesContactids.isNotEmpty && FavoratesContacts.isEmpty )
  //   {
  //     FavoratesContactsID = FavoratesContactids;
  //     FavoratesContactsID.forEach((id) {
  //       Contacts.forEach((element) {
  //         if (id == element.info?.id)
  //           FavoratesContacts.add(element);
  //       });
  //     });
  //   }
  //   }


  void FavoratesItemColors(){
    FavoratesItemColor = BaseColors[ColorIndex];
    ColorIndex == BaseColors.length-1?ColorIndex = 0:ColorIndex++;

  }

  Future<Uint8List> ToUint8List(URL) async {
    return (await NetworkAssetBundle(Uri.parse(URL)).load(URL)).buffer.asUint8List();
  }

  final List DefaultPhoneAccounts=[];

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

      element.info!.thumbnail == null?ContactsNoThumb.add(element):null;
      if(element.info?.isStarred == true)
        {
          FavoratesContacts.add(element);
        }

      element.info?.accounts.forEach((e) {
        if(e.type.isNotEmpty || e.name.isNotEmpty) {
          DefaultPhoneAccounts.add({
            "AccountType": e.type,
            "AccountName": e.name,
          });
        }
      });

    });
    final ids = DefaultPhoneAccounts.map((e) => e["AccountName"]).toSet();
    DefaultPhoneAccounts.retainWhere((element) => ids.remove(element["AccountName"]));
    Contacts.first.PhoneAccounts = DefaultPhoneAccounts;
    print("Default PhoneAccounts = ${Contacts.first.PhoneAccounts}");
      emit(RawContactsSuccessState());
  }

  void GetCallerID(PhoneNumberQuery) {

    SearchableCallerIDList.clear();
    Contacts.map((element){
      SearchableCallerIDList.add({
        "CallerID" : element.info?.displayName.toString(),
        "PhoneNumber" : element.info?.phones.map((e) {
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




  bool isSearching =false;


  List<AppContact> FilterdContacts = [];
  List<AppContact> DialpadFilterdContacts = [];
  Iterable<CallLogEntry> PhoneLog = <CallLogEntry>[];

  List<String> SearchTerm =[];
  List<AppContact> Firstchr = [];
  List<AppContact> secondchr = [];
  List<AppContact> thirdchr = [];


///This Function Used to SearchAndFilter Contacts Based on there Name [Used at the top searchBar]

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
  bool isShowen = false;

  void dialpadShowcontact(){
    isShowen =! isShowen;

    emit(isShowenSuccessState());
  }
  void Daillerinput(){
    emit(dailerInputSuccessstate());
  }

 Future DialpadSearch (TextEditingController dialerController) async{
    // if(dialerController.value == 2) {
    //   SearchTerm = ["a", "b", "c"];
    // }
    // if(dialerController.value == 3) {
    //   SearchTerm = ["d", "e", "f"];
    // }
    // if(dialerController.value == 4) {
    //   SearchTerm = ['g', 'h', 'i'];
    // }
    // if(dialerController.text == "5") {
    //   SearchTerm = ["j", "k", "l"];
    // }
    // if(dialerController.text == "6")
    //   SearchTerm = ["m","n","o"];
    // if(dialerController.text == "7")
    //   SearchTerm = ["p","q","r"];
    // if(dialerController.text == "8")
    //   SearchTerm = ["t","u","v"];
    // if(dialerController.text == "9")
    //   SearchTerm = ["w","x","y"];
   try
   {
     isSearching = true;
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

List WhatsappContacts =[];
List PhoneAccounts =[];
int SelectedPhoneAccountIndex = 0;
void FilterContactsByAccount(AppContact contact){
  PhoneAccounts.clear();
  WhatsappContacts.clear();
  contact.info?.phones.forEach((element) {
    if(element.AccountType == "com.whatsapp")
      {
        WhatsappContacts.add(element.number);
      }
    else {
        PhoneAccounts.add({
          "AccountName": element.AccountName,
          "AccountType": element.AccountType,
        });
      }
    });
  final ids = PhoneAccounts.map((e) => e["AccountName"]).toSet();
  PhoneAccounts.retainWhere((element) => ids.remove(element["AccountName"]));
  SelectedPhoneAccountIndex = DefaultPhoneAccountIndex;
      print("Final Phone Accounts : $PhoneAccounts");
  print(WhatsappContacts);
}

  Text AccountTitle(AccountType) {
    if(AccountType?.contains("google")==true)
      return Text("Google");
    if(AccountType == "com.whatsapp")
      return Text("Whatsapp");
    if(AccountType == "com.whatsapp.w4b")
      return Text("Whatsapp Business");
    if(AccountType == "org.telegram.messenger")
      return Text("Telegram");
    if(AccountType == "com.oppo.contacts.device")
      return Text("Phone");
    else
      return Text("Other");
  }

  FaIcon AccountIcon(String? AccountType) {
    if(AccountType?.contains("google")==true)
      return FaIcon(FontAwesomeIcons.googlePlusSquare,size:30);
    if(AccountType == "com.whatsapp" ||AccountType == "com.whatsapp.w4b" )
      return FaIcon(FontAwesomeIcons.whatsappSquare,size:30);
    if(AccountType == "org.telegram.messenger" )
      return FaIcon(FontAwesomeIcons.telegram,size:30);
    else
      return FaIcon(FontAwesomeIcons.circleQuestion);
  }
}

