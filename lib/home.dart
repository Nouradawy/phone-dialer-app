import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Components/components.dart';
import 'Layout/Cubit/cubit.dart';
import 'Layout/Cubit/states.dart';
import 'Modules/Contacts/contacts_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          // var Cubit = AppCubit.get(context);
          double AppbarSize = MediaQuery.of(context).size.height*0.09;
          return
            DefaultTabController(
              length: 2,
              child: Scaffold(
                // backgroundColor: HexColor("#FAFAFA"),
                appBar:MyAppBar(context, AppbarSize),
                body: SafeArea(
                child: ContactsScreen(),
              ),
          ),
            );
        },
      ),
    );
  }





  // CircleAvatar buildCircleAvatar(Uint8List? avatar, String initials) {
  //   if(avatar != null && avatar.length > 0){
  //     return CircleAvatar(backgroundImage:MemoryImage(avatar));
  //   } else {
  //     return CircleAvatar(child: Text(initials.toString()));
  //   }
  // }
}


