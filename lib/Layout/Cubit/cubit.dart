import 'package:bloc/bloc.dart';

import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';

import 'package:dialer_app/Network/Local/cache_helper.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:dialer_app/Themes/light_theme.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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


  Color CustomHomePageBackgroundColor = HexColor("#EAE6F2");
  Color SearchTextColor = SearchIconColor();
  Color TabBarTextColor = ThemeSwitch?HexColor("#EAE6F2"):HexColor("#2A2A2A");
  Color SearchBackground= SearchBackgroundColor();

void SaveCustomTheme(){
  CacheHelper.saveData(key: "CustomHomePageBackgroundColor", value: CustomHomePageBackgroundColor.toString().replaceAll("Color","" ).replaceAll("(", "").replaceAll(")", ""));
}

  // ConstrainedBox HomePageBackgroundColorPicker(){
  //   // Show the color picker in sized box in a raised card.
  //   return ConstrainedBox(
  //     constraints: BoxConstraints(maxHeight: 500),
  //     child: DefaultTabController(
  //       length: 3,
  //       child: Column(
  //         children: [
  //           Text("Choose Your desired section to Customize "),
  //           TabBar(
  //               indicatorColor: HexColor("#F07F5C"),
  //               unselectedLabelColor: Colors.black,
  //               isScrollable: true,
  //               labelStyle: TextStyle(fontSize: 10),
  //               tabs: [
  //
  //             Row(children: [Icon(Icons.flip_to_back ,color:Colors.black),Text("Background Color")],),
  //             Tab(text: 'Search Text Color', icon: FaIcon(FontAwesomeIcons.google ,color:Colors.black)),
  //             Tab(text: 'Search Background Color', icon: FaIcon(FontAwesomeIcons.twitter, color:Colors.black)),
  //           ]),
  //           Container(
  //             width: 300,
  //             height: 400,
  //             child: TabBarView(children: [
  //               SingleChildScrollView(
  //                 child: ColorPicker(
  //                   // enableOpacity: true,
  //                   // Use the screenPickerColor as start color.
  //                   color: CustomHomePageBackgroundColor,
  //                   // Update the screenPickerColor using the callback.
  //                   pickersEnabled: const <ColorPickerType,bool>{
  //                     ColorPickerType.custom: true,
  //                     ColorPickerType.accent: true,
  //                     ColorPickerType.wheel: true,
  //                   },
  //                   onColorChangeEnd: (color) {
  //                     CustomHomePageBackgroundColor = color;
  //                     emit(ColorPickerColorChange());
  //                   },
  //                   width: 30,
  //                   height: 30,
  //                   borderRadius: 22,
  //                   heading: const Text(
  //                     'Select color',
  //                   ),
  //                   subheading: const Text(
  //                     'Select color shade',
  //                   ), onColorChanged: (Color value) {  },
  //                 ),
  //               ),
  //               SingleChildScrollView(
  //                 child: ColorPicker(
  //                   // enableOpacity: true,
  //                   // Use the screenPickerColor as start color.
  //                   color: CustomHomePageBackgroundColor,
  //                   // Update the screenPickerColor using the callback.
  //                   pickersEnabled: const <ColorPickerType,bool>{
  //                     ColorPickerType.custom: true,
  //                     ColorPickerType.accent: true,
  //                     ColorPickerType.wheel: true,
  //                   },
  //                   onColorChangeEnd: (color) {
  //                     CustomHomePageBackgroundColor = color;
  //                     emit(ColorPickerColorChange());
  //                   },
  //                   width: 30,
  //                   height: 30,
  //                   borderRadius: 22,
  //                   heading: const Text(
  //                     'Select color',
  //                   ),
  //                   subheading: const Text(
  //                     'Select color shade',
  //                   ), onColorChanged: (Color value) {  },
  //                 ),
  //               ),
  //               SingleChildScrollView(
  //                 child: ColorPicker(
  //                   // enableOpacity: true,
  //                   // Use the screenPickerColor as start color.
  //                   color: CustomHomePageBackgroundColor,
  //                   // Update the screenPickerColor using the callback.
  //                   pickersEnabled: const <ColorPickerType,bool>{
  //                     ColorPickerType.custom: true,
  //                     ColorPickerType.accent: true,
  //                     ColorPickerType.wheel: true,
  //                   },
  //                   onColorChangeEnd: (color) {
  //                     CustomHomePageBackgroundColor = color;
  //                     emit(ColorPickerColorChange());
  //                   },
  //                   width: 30,
  //                   height: 30,
  //                   borderRadius: 22,
  //                   heading: const Text(
  //                     'Select color',
  //                   ),
  //                   subheading: const Text(
  //                     'Select color shade',
  //                   ), onColorChanged: (Color value) {  },
  //                 ),
  //               ),
  //
  //             ]),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  bool AppBackgroundDropdown = false;
  bool SearchTextColorDropDown = false;
  bool TabBarTextColorDropDown = false;
  bool SearchBackgroundColorDropDown = false;
  ConstrainedBox HomePageBackgroundColorPicker(){
    // Show the color picker in sized box in a raised card.
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 450),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("AppBar Recolor "),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child:InkWell(
                    onTap: (){
                      AppBackgroundDropdown =! AppBackgroundDropdown;
                      emit(PopUpMenuUpdate());
                    },
                    child: Row(children: [Icon(
                      Icons.format_color_fill,
                    ),Text("AppBar Background Color")],))
              ),
            ),
            AnimatedSize(
              curve:Curves.easeIn,
              duration: Duration(seconds: 1),
              child: Container(
                height: AppBackgroundDropdown==false?0:400,
                child: ColorPicker(
                  // enableOpacity: true,
                  // Use the screenPickerColor as start color.
                  color: CustomHomePageBackgroundColor,
                  // Update the screenPickerColor using the callback.
                  pickersEnabled: const <ColorPickerType,bool>{
                    ColorPickerType.custom: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.wheel: true,
                  },
                  onColorChangeEnd: (color) {
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
                  ), onColorChanged: (Color value) {  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child:InkWell(
                      onTap: (){
                        SearchTextColorDropDown =! SearchTextColorDropDown;

                        emit(PopUpMenuUpdate());
                      },
                      child: Row(children: [Icon(
                        Icons.format_size,
                      ),Text("Search Text Color")],))
              ),
            ),
            AnimatedSize(
              curve:Curves.easeIn,
              duration: Duration(seconds: 1),
              child: Container(
                height: SearchTextColorDropDown==false?0:400,
                child: ColorPicker(
                  // enableOpacity: true,
                  // Use the screenPickerColor as start color.
                  color: SearchTextColor,
                  // Update the screenPickerColor using the callback.
                  pickersEnabled: const <ColorPickerType,bool>{
                    ColorPickerType.custom: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.wheel: true,
                  },
                  onColorChangeEnd: (color) {
                    SearchTextColor = color;
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
                  ), onColorChanged: (Color value) {  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child:InkWell(
                      onTap: (){
                        TabBarTextColorDropDown =! TabBarTextColorDropDown;
                        emit(PopUpMenuUpdate());
                      },
                      child: Row(children: [Icon(
                        Icons.smart_button,
                      ),Text("TabBar Text Color")],))
              ),
            ),
            AnimatedSize(
              curve:Curves.easeIn,
              duration: Duration(seconds: 1),
              child: Container(
                height: TabBarTextColorDropDown==false?0:400,
                child: ColorPicker(
                  // enableOpacity: true,
                  // Use the screenPickerColor as start color.
                  color: TabBarTextColor,
                  // Update the screenPickerColor using the callback.
                  pickersEnabled: const <ColorPickerType,bool>{
                    ColorPickerType.custom: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.wheel: true,
                  },
                  onColorChangeEnd: (color) {
                    TabBarTextColor = color;
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
                  ), onColorChanged: (Color value) {  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child:InkWell(
                      onTap: (){
                        SearchBackgroundColorDropDown =! SearchBackgroundColorDropDown;

                        emit(PopUpMenuUpdate());
                      },
                      child: Row(
                        children: [Icon(
                        Icons.flip_to_back,
                      ),Text("Search Background Color")],))
              ),
            ),
            AnimatedSize(
              curve:Curves.easeIn,
              duration: Duration(seconds: 1),
              child: Container(
                height: SearchBackgroundColorDropDown==false?0:400,
                child: ColorPicker(
                  // enableOpacity: true,
                  // Use the screenPickerColor as start color.
                  color: SearchBackground,
                  // Update the screenPickerColor using the callback.
                  pickersEnabled: const <ColorPickerType,bool>{
                    ColorPickerType.custom: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.wheel: true,
                  },
                  onColorChangeEnd: (color) {
                    SearchBackground = color;
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
                  ), onColorChanged: (Color value) {  },
                ),
              ),
            ),
          ],
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


