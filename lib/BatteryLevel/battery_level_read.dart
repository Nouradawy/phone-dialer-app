
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Cubit/states.dart';


class BatteryLevelRead extends Cubit<BatteryLevelStates> {
  BatteryLevelRead() : super(BatteryLevelInitialState());

  static BatteryLevelRead get(context) => BlocProvider.of(context);

  static const platform = MethodChannel("ReadBatteryMethod");

  String BatteryLevel = "unknown battery level.";



  Future<void> GetBatteryLevel() async {
    emit(BatteryLevelLoadingState());
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod("GetBatteryLevel").then(
              (value) async {
                int newValue = value;
                await newValue!=value?newValue = value:null;
                batteryLevel = '$newValue %';
                emit(BatteryLevelUpdateState());
                return newValue;
              }
      );
      batteryLevel = '$result %';
      if(batteryLevel !=BatteryLevel) emit(BatteryLevelUpdateState());
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: ${e.message}";
    }
    BatteryLevel = batteryLevel;
    emit(BatteryLevelSuccessState());
  }
}

