import 'package:dialer_app/BatteryLevel/Cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'battery_level_read.dart';

class BatteryLevelHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(context) => BatteryLevelRead()..GetBatteryLevel(),
      child: BlocConsumer<BatteryLevelRead , BatteryLevelStates>(
        listener: (context , state) {},
        builder:(context , state) {
          BatteryLevelRead.get(context).GetBatteryLevel();
          return Scaffold(
          appBar: AppBar(
            title:Text("BatteryLevel"),
          ),
          body: Column(
            children: [
              Center(child: Text(BatteryLevelRead.get(context).BatteryLevel.toString())),
            ],
          ),
        );
        },
      ),
    );
  }
}
