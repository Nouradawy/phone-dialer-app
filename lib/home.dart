import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Components/components.dart';
import 'Modules/Contacts/contacts_screen.dart';
import 'Layout/Cubit/cubit.dart';
import 'Layout/Cubit/states.dart';
import 'Modules/Contacts/contacts_screen.dart';

class Home extends StatelessWidget {

  var scaffoldkey = GlobalKey<ScaffoldState>();
  bool isShowen = false;


  @override
  Widget build(BuildContext context) {
    var SearchController =TextEditingController();
    return BlocProvider(
      create: (context)=>AppCubit()..GetContacts(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if(SearchController.text.isEmpty){
            AppCubit.get(context).isSearching = false;
          } else{
            AppCubit.get(context).isSearching = true;
            // if(SearchController.text.length < SearchController.text.length)
            //   {
            //     AppCubit.get(context).FilterdContacts.clear();
            //     AppCubit.get(context).FilterdContacts.addAll(AppCubit.get(context).Contacts);
            //   }
          }
        },
        builder: (context, state) {
          var Cubit = AppCubit.get(context);
          double AppbarSize = MediaQuery.of(context).size.height*0.09;



          return
            DefaultTabController(
              length: 2,
              child: Scaffold(

                key: scaffoldkey,
                appBar:MainAppBar(context, AppbarSize , SearchController),

                floatingActionButton: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onPressed: () {
                    Cubit.dialpadShow();
                },
                  child:Image.asset("assets/Images/dialpad.png",scale:1.8),
                ),
                body: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    ContactsScreen(),
                    Material(
                        color: HexColor("#F9F9F9"),
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(30),
                          topEnd: Radius.circular(30),
                        ),
                        elevation: 10,
                        child: Dialpad(context, AppbarSize )),

                  ],
                ),
          ),
            );
        },
      ),
    );
  }





}


