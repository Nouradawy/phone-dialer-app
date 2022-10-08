import 'package:bloc/bloc.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:dialer_app/Network/Local/cache_helper.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';



class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  double AppbarSize = 0.09;

  var dialerController =TextEditingController();
  var searchController =TextEditingController();

List PhoneCallLogsCallerID =[];

bool isSearching = false;
bool contactsLoaded = false;
bool isShowen = false;
bool NewTheme = false;




  void SaveActiveTheme()
  {
    // ThemeSwitch = !ThemeSwitch;
    // print("ThemeNow : $ThemeSwitch" );
    CacheHelper.saveData(key: "currentThemeindex", value: ActiveTheme);

    emit(ThemeUpdateState());
  }


  void NewThemeMenu()
  {
    // ThemeSwitch = !ThemeSwitch;
    // print("ThemeNow : $ThemeSwitch" );
    NewTheme = !NewTheme;
    print("ThemeNow : $NewTheme" );
    emit(ThemeUpdateState());
  }
  void ShowHide(){
   emit(dailerInputSuccessstate());
  }

  void dialpadShow(){
    isShowen =! isShowen;

    emit(isShowenSuccessState());
  }



}


