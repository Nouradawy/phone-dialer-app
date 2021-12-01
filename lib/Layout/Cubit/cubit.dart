import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../Modules/Contacts/appcontacts.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
List<AppContact> Contacts = [];
List<AppContact> FilterdContacts = [];
bool isSearching = false;
bool contactsLoaded = false;
bool isShowen = false;

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
}

