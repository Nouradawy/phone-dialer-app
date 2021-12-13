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
List<AppContact> FavoratesContacts = [];

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

// List <Widget> Screens=
// [
//
// ];


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
      Contacts = _contacts;

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

AddorRemoveFavorates(index){

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
}

