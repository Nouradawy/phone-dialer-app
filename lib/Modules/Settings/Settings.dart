import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

class Settings_Screen extends StatefulWidget {
  const Settings_Screen({Key? key}) : super(key: key);

  @override
  State<Settings_Screen> createState() => _Settings_ScreenState();
}

class _Settings_ScreenState extends State<Settings_Screen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Settings",style: TextStyle(color: Colors.black),),
      ),
      body: ListView.builder(
        itemCount: PhoneContactsCubit.get(context).Contacts.first.PhoneAccounts?.length,
        itemBuilder: (context,index)=>ListTile(
          title: PhoneContactsCubit.get(context).AccountTitle(PhoneContactsCubit.get(context).Contacts.first.PhoneAccounts?[index]["AccountType"]),
          subtitle: Text(PhoneContactsCubit.get(context).Contacts.first.PhoneAccounts?[index]["AccountName"]),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio(
                  value: index,
                  groupValue: PhoneContactsCubit.get(context).DefaultPhoneAccountIndex,
                  onChanged: (value){
                    setState((){
                      PhoneContactsCubit.get(context).DefaultPhoneAccountIndex = value.hashCode;
                    });
                  }),
              PhoneContactsCubit.get(context).AccountIcon(PhoneContactsCubit.get(context).Contacts.first.PhoneAccounts?[index]["AccountType"]),
            ],
          ),
        ),
      ),
    );
  }
}
