import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Components/constants.dart';
import '../../home.dart';
import '../Contacts/Contacts Cubit/contacts_cubit.dart';
import '../Phone/Cubit/cubit.dart';

class Initial_Screen extends StatefulWidget {
  const Initial_Screen({Key? key}) : super(key: key);

  @override
  State<Initial_Screen> createState() => _Initial_ScreenState();
}

class _Initial_ScreenState extends State<Initial_Screen> {
  @override
  Widget build(BuildContext context) {
    PermisionHandel();
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(),
      body:Center(
        child: Container(
          alignment: Alignment.bottomRight,
          width: MediaQuery.of(context).size.width*0.80,
          height: MediaQuery.of(context).size.height*0.80,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Align(
                  alignment: Alignment.center,
                  child: CircleAvatar()),
              TextButton(onPressed: () {
                setState(() {
                  isGuest = true;
                  Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(create: (context)=>PhoneContactsCubit()..GetRawContacts()),
                          BlocProvider(create: (context)=>PhoneLogsCubit()..getCallLogsInitial(PhoneContactsCubit.get(context).Contacts,true)),

                        ],
                        child: Home())),

                  );
                });
              },
              child: Text("Continue as guest")),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> PermisionHandel() async {
  print(" i am in there");
  if (await Permission.contacts.request().isDenied) {
    Permission.contacts.request();
  // Either the permission was already granted before or the user just granted it.
  }
  if (await Permission.phone.request().isDenied) {
    Permission.phone.request();
  // Either the permission was already granted before or the user just granted it.
  }
  if (await Permission.phone.request().isPermanentlyDenied || await Permission.contacts.request().isPermanentlyDenied) {
    openAppSettings();
    // Either the permission was already granted before or the user just granted it.
  }

}