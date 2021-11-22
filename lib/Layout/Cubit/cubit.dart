import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Modules/Contacts/appcontacts.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
List<AppContact> Contacts = [];
// bool contactsLoaded = false;

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
    List<AppContact> _contacts = (await ContactsService.getContacts()).map((contact) {
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

}

