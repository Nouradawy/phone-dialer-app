import 'package:azlistview/azlistview.dart';
import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';

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
List<_AZItem> Azitem =[];


bool isSearching = false;
bool contactsLoaded = false;
bool isShowen = false;

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


  Future<void> GetContacts() async {
    emit(AppgetContactsLoading());
    List colors = [
      Colors.green,
      Colors.indigo,
      Colors.yellow,
      Colors.orange
    ];
    int colorIndex = 0;

    List<AppContact> _contacts = (await ContactsService.getContacts().catchError((error){
      print("Contacts Error : " + error.toString());
    })).map((contact) {
      Color baseColor = colors[colorIndex];
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
      return new AppContact(info: contact, color: baseColor);
    }).toList();
    // final SortedContacts = _contacts..sort((a,b)=> a.info!.givenName!.compareTo(b.info!.givenName!));
      Contacts =_contacts;
    GetAZData();
      // contactsLoaded = true;
      emit(AppgetContactsSuccess());
  }
  Future<void> GetAZData() async {
    Azitem = (await ContactsService.getContacts().catchError((error){
      print("Contacts Error : " + error.toString());
    })).map((contact) {
      return new _AZItem(title: contact.givenName, tag: contact.givenName![0].toUpperCase());
    }).toList();

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
String SearchTerm ="";
List<String> SearchTermlist=[];
  int Searchindex = 0;

   Future DialpadSearch () async{
    emit(SearchLoadingState());
    FilterdContacts.clear();
    DialpadFilterdContacts.clear();
    DialpadFilterdContacts.addAll(Contacts);


    DialpadFilterdContacts.retainWhere((contact){
      String contactName = contact.info!.displayName!.toLowerCase();
      return contactName.contains(SearchTerm);
    });

    if(DialpadFilterdContacts.isNotEmpty)
      {

        FilterdContacts.addAll(DialpadFilterdContacts);

      } else {
      SearchTerm =  SearchTerm.substring(0,SearchTerm.length - 3);
      print("searchTerm Bug Remove = "+SearchTerm.toString());
      SearchTerm = SearchTerm.toString() + SearchTermlist[Searchindex].toString();
      print("searchTerm Fix ="+SearchTerm.toString());
      Searchindex++;
      Searchindex>=3?Searchindex=0:Searchindex;
      DialpadSearch();
    }
    emit(SearchSuccessState());
    }

}


class _AZItem extends ISuspensionBean{

  final String? title;
  final String tag;
  _AZItem({
    required this.title,
    required this.tag,
});

  @override
  String getSuspensionTag() => tag;
}

