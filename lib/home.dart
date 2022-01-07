import 'package:dialer_app/Modules/Login&Register/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/states.dart';
import 'package:dialer_app/Modules/Contacts/contacts_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Components/components.dart';
import 'Components/constants.dart';
import 'Models/user_model.dart';
import 'Modules/Phone/phone_screen.dart';
import 'Layout/Cubit/cubit.dart';
import 'Layout/Cubit/states.dart';
import 'NativeBridge/native_bridge.dart';
import 'NativeBridge/native_states.dart';
import 'Layout/incall_screen.dart';

class Home extends StatelessWidget {

  var scaffoldkey = GlobalKey<ScaffoldState>();
  bool isShowen = false;


  @override
  Widget build(BuildContext context) {
    var searchController =TextEditingController();
    var dialerController =TextEditingController();
    return BlocProvider.value(
      value: AppCubit.get(context)..GetContacts(),
      child: BlocConsumer<NativeBridge,NativeStates>(
        listener:(context , state){
          if(state is PhoneStateRinging)
          {
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) => InCallScreen()),
                  (Route<dynamic>route)=>false,);
          }
        },
        builder: (context ,state)=>BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if(searchController.text.isEmpty || dialerController.text.isEmpty){
              AppCubit.get(context).isSearching = false;
            }

            if(searchController.text.isNotEmpty || dialerController.text.isNotEmpty){
              AppCubit.get(context).isSearching = true;
            }
          },
          builder: (context, state) {
            var Cubit = AppCubit.get(context);
            double AppbarSize = MediaQuery.of(context).size.height*Cubit.AppbarSize;
            return
              DefaultTabController(
                length: 2,
                child: Scaffold(
                  extendBodyBehindAppBar: true,
                  key: scaffoldkey,
                  appBar:MainAppBar(context, AppbarSize , searchController),
                  drawer: AppDrawer(context),
                  drawerDragStartBehavior: DragStartBehavior.start ,
                  floatingActionButton: Cubit.isShowen==false?FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onPressed: () {
                      Cubit.dialpadShow();
                    },
                    child:Image.asset("assets/Images/dialpad.png",scale:1.8),
                  ):null,

                  body: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      TabBarView(
                        children:<Widget> [
                          PhoneScreen(),
                          ContactsScreen(),
                        ],
                      ),
                      Material(
                          color: HexColor("#F9F9F9"),
                          borderRadius: const BorderRadiusDirectional.only(
                            topStart: Radius.circular(30),
                            topEnd: Radius.circular(30),
                          ),
                          elevation: 10,
                          child: Cubit.isShowen?Dialpad(context, AppbarSize , dialerController):null),

                    ],
                  ),
                ),
              );
          },
        ),
      ),
    );
  }







}


