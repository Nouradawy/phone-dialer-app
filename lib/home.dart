import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Constants/constants.dart';
import 'Constants/contacts-list.dart';
import 'Cubit/cubit.dart';
import 'Cubit/states.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var Cubit = AppCubit.get(context);


        return Scaffold(
          appBar: AppBar(
            title:Text("Contacts"),
            actions: [
              BatteryLevelRead(),
            ],
          ),
          body: Column(
            children: [
              Cubit.contactsLoaded == true
                  ? // if the contacts have not been loaded yet
                  ContactsList(
                    contacts: Cubit.Contacts,
                      reloadContacts: () {
                        Cubit.GetContacts();
                      },
                    )
                  : Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }

  CircleAvatar buildCircleAvatar(Uint8List? avatar, String initials) {
    if(avatar != null && avatar.length > 0){
      return CircleAvatar(backgroundImage:MemoryImage(avatar));
    } else {
      return CircleAvatar(child: Text(initials.toString()));
    }
  }
}


class BatteryLevelRead extends StatefulWidget {
  const BatteryLevelRead({Key? key}) : super(key: key);
  @override
  _BatteryLevelReadState createState() => _BatteryLevelReadState();
}

class _BatteryLevelReadState extends State<BatteryLevelRead> {
  static const platform = MethodChannel("ReadBatteryMethod");

  String BatteryLevel = "unknown battery level.";


  Future<void> GetBatteryLevel() async{
    String batteryLevel;
    try{

      final int result = await platform.invokeMethod("GetBatteryLevel");
      batteryLevel = 'Battery level at $result % .';

    } on PlatformException catch (e){
      batteryLevel = "Failed to get battery level: ${e.message}";

    }
    setState(() {
      BatteryLevel = batteryLevel;
    });


  }


  @override
  Widget build(BuildContext context) {
    GetBatteryLevel();
    return Text(BatteryLevel);
  }
}