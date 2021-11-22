import 'package:dialer_app/Components/contacts_list.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: AppCubit()..GetContacts(),
      child:BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var Cubit = AppCubit.get(context);
          return ContactsList(
            contacts: Cubit.Contacts,
            reloadContacts: () {
              Cubit.GetContacts();
            },
          );
        },
      )
    );
  }
}
