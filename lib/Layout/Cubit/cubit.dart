import 'package:bloc/bloc.dart';

import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';

import 'package:dialer_app/Network/Local/cache_helper.dart';
import 'package:dialer_app/Themes/light_theme.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
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

  // Material blue.
  Color dialogPickerColor = Colors.red; // Material red.
  Color dialogSelectColor = const Color(0xFFA239CA); // Color for picker using color select dialog.
  bool EditorIsActive = false;



Future<void> PermissionHandle() async {
  var status = await Permission.contacts.status;
  if (status.isDenied) {
    // We didn't ask for permission yet or the permission has been denied before but not permanently.
    await [
      Permission.contacts,
      Permission.phone,
      Permission.microphone,
    ].request();
  }

}

  void ThemeSwitcher()
  {

    ThemeSwitch = !ThemeSwitch;
    print("ThemeNow : $ThemeSwitch" );
    CacheHelper.saveData(key: "ThemeSwitch", value: ThemeSwitch);
    emit(ThemeUpdateState());
  }

  void ShowHide(){
   emit(dailerInputSuccessstate());
  }

  void dialpadShow(){
    isShowen =! isShowen;
    emit(isShowenSuccessState());
  }


  Color CustomHomePageBackgroundColor = ThemeSwitch?HexColor("#EAE6F2"):HexColor("#2A2A2A");
void SaveCustomTheme(){
  CacheHelper.saveData(key: "CustomHomePageBackgroundColor", value: CustomHomePageBackgroundColor.toString().replaceAll("Color","" ).replaceAll("(", "").replaceAll(")", ""));
}

  ConstrainedBox HomePageBackgroundColorPicker(){
    // Show the color picker in sized box in a raised card.
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 350,
      ),
      child: SingleChildScrollView(
        child: ColorPicker(
          // Use the screenPickerColor as start color.
          color: CustomHomePageBackgroundColor,
          // Update the screenPickerColor using the callback.
          onColorChanged: (color) {
            CustomHomePageBackgroundColor = color;
            emit(ColorPickerColorChange());
          },
          width: 30,
          height: 30,
          borderRadius: 22,
          heading: const Text(
            'Select color',
          ),
          subheading: const Text(
            'Select color shade',
          ),
        ),
      ),
    );
  }


  // Define some custom colors for the custom picker segment.
  // The 'guide' color values are from
  // https://material.io/design/color/the-color-system.html#color-theme-creation
  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  // Make a custom ColorSwatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> colorsNameMap =
  <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };
}


