import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:dialer_app/Network/Local/cache_helper.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:dialer_app/Themes/Cubit/states.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../theme_config.dart';

class ThemeCubit extends Cubit<ThemeStates>{
  ThemeCubit() : super(ThemeInitialStates());
  static ThemeCubit get(context) => BlocProvider.of(context);

  // Material blue.
  bool DeleteTheme = false;
  Color dialogPickerColor = Colors.red; // Material red.
  Color dialogSelectColor = const Color(0xFFA239CA); // Color for picker using color select dialog.
  bool ThemeEditorIsActive = false;
  int BottomNavIndex=0;



  Color CustomHomePageBackgroundColor =HexColor("#EAE6F2");
  Color SearchTextColor = SearchIconColor();
  Color TabBarTextColor = HexColor("#EAE6F2");
  Color SearchBackground = HexColor("#FFFFFF").withOpacity(0.52);
  Color UnSelectedTabBarColor = HexColor("#FFFFFF").withOpacity(0.52);
  Color TabBarIndicatorColor = HexColor("#FFFFFF").withOpacity(0.52);

  Color PhoneLogDiallerNameColor = HexColor("#292929");
  Color PhoneLogPhoneNumberColor = HexColor("#8E8E8E");
  Color AppBackGroundColor = Colors.transparent;


bool ApplyThemeChanges = false;
  bool AppBackgroundDropdown = false;
  bool SearchTextColorDropDown = false;
  bool TabBarTextColorDropDown = false;
  bool SearchBackgroundColorDropDown = false;
  bool UnSelectedTabBarColorDropDown = false;
  bool TabBarIndicatorColorDropDown = false;
  bool PhoneLogDiallerNameColorDropdown = false;
  bool PhoneLogPhoneNumberColorDropdown = false;
  bool AppBackGroundColorDropdown = false;
  bool MultipleThemeEdit = false;

  double InCallBackgroundHeight=400;
  double InCallBackgroundVerticalPading = 0;
  double InCallBackgroundOpacity = 1;
  Color InCallBackgroundColor = HexColor("#2C087A");
  Color CallerIDcolor = HexColor("#F5F5F5");
  Color CallerIDPhoneNumbercolor = HexColor("#C8C8C8");
  Color InCallPhoneStateColor = Colors.white;
  double CallerIDfontSize = 25;
  double CallerIDPhoneNumberfontSize = 25;
  double InCallPhoneStateSize = 13;

  int CurrentThemeEditIndex =0;

  void SaveThemeList()
  {
    // ThemeSwitch = !ThemeSwitch;
    // print("ThemeNow : $ThemeSwitch" );
    CacheHelper.saveData(key: "currentThemeindex", value: ActiveTheme);
    CacheHelper.saveData(key: "ThemeList", value: json.encode(MyThemeData));
    DialPadBackGroundImagePicker = null;
    emit(ThemeUpdateState());
  }

  void ThemeEditorChangeindex()
  {
    emit(ThemeUpdateState());
  }

  void ThemedDeleteSelection()
  {
    DeleteTheme = !DeleteTheme;
    CacheHelper.saveData(key: "ThemeList", value: json.encode(MyThemeData));
    emit(DeleteThemeChangeSuccess());
  }

  void ThemeApplyChanges()
  {
    ApplyThemeChanges= !ApplyThemeChanges;

    emit(ThemeApplyChangesSuccess());
  }




  File? DialPadBackGroundImagePicker;
  File? InCallBackGroundImagePicker;
  var picker = ImagePicker();
  var DialPadBackgroundFilePicker;
  var InCallBackgroundFilePicker;

  Future BackGroundImagePicker() async
  {

    DialPadBackgroundFilePicker = await picker.pickImage(source: ImageSource.gallery);

      if(DialPadBackgroundFilePicker !=null ) {

        final imagePermanent = await SaveImagePermanently(DialPadBackgroundFilePicker.path);
        DialPadBackGroundImagePicker = imagePermanent;
        //TODO:Spleting Uploading the image from Profile image Picker Due to the image will be Uploaded without User Concent

        emit(BackGroundImagePickedSuccess());
      } else{
      print("Faild to pick imag");
      emit(BackGroundImagePickedError());
    }
  }


  Future<File> SaveImagePermanently(String imagePath) async {
    final directory= await getApplicationDocumentsDirectory();

    final image = File("${directory.path}/${Uri.file(imagePath).pathSegments.last}");
    return File(imagePath).copy(image.path);
  }

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
                        Icons.web_asset,
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
                  color:CustomHomePageBackgroundColor,
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
                        Icons.search,
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
                        UnSelectedTabBarColorDropDown  =! UnSelectedTabBarColorDropDown ;

                        emit(PopUpMenuUpdate());
                      },
                      child: Row(
                        children: [Icon(
                          Icons.tab_unselected),
                        Text("TabBar UnSelected Color")],))
              ),
            ),
            AnimatedSize(
              curve:Curves.easeIn,
              duration: Duration(seconds: 1),
              child: Container(
                height: UnSelectedTabBarColorDropDown==false?0:400,
                child: ColorPicker(
                  // enableOpacity: true,
                  // Use the screenPickerColor as start color.
                  color: UnSelectedTabBarColor,
                  // Update the screenPickerColor using the callback.
                  pickersEnabled: const <ColorPickerType,bool>{
                    ColorPickerType.custom: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.wheel: true,
                  },
                  onColorChangeEnd: (color) {
                    UnSelectedTabBarColor = color;
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
                        TabBarIndicatorColorDropDown =! TabBarIndicatorColorDropDown;

                        emit(PopUpMenuUpdate());
                      },
                      child: Row(
                        children: [Icon(
                          Icons.format_underlined,
                        ),Text("TabBar Indicator Color")],))
              ),
            ),
            AnimatedSize(
              curve:Curves.easeIn,
              duration: Duration(seconds: 1),
              child: Container(
                height: TabBarIndicatorColorDropDown==false?0:400,
                child: ColorPicker(
                  // enableOpacity: true,
                  // Use the screenPickerColor as start color.
                  color: TabBarIndicatorColor,
                  // Update the screenPickerColor using the callback.
                  pickersEnabled: const <ColorPickerType,bool>{
                    ColorPickerType.custom: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.wheel: true,
                  },
                  onColorChangeEnd: (color) {
                    TabBarIndicatorColor  = color;
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

  ConstrainedBox PhoneLogColorPicker(){
    // Show the color picker in sized box in a raised card.
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 450),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.only(top:8.0, left:8 , bottom: 8),
                child: Text("Phone Log Customization "),
              ),
            ),
            Stack(
              children: [
                Container(width:double.infinity , height: 80,color:AppBackGroundColor),
                Padding(
                  padding: const EdgeInsets.only(top:5.0, left:8),
                  child: Row(

                      children: [
                        CircleAvatar(radius: 35,backgroundColor: HexColor("#032A37").withOpacity(0.35),),
                        Padding(
                          padding: const EdgeInsets.only(top:2.0, left:7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:4.0, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration
                                    (
                                    borderRadius: BorderRadius.circular(2),
                                    color:PhoneLogDiallerNameColor.withOpacity(0.52),
                                  ),
                                  width:120 , height: 8,

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:4.0, bottom: 5),
                                child: Container(
                                  decoration: BoxDecoration
                                    (
                                    borderRadius: BorderRadius.circular(2),
                                    color:PhoneLogPhoneNumberColor.withOpacity(0.52),
                                  ),
                                  width:60 , height: 8,

                                ),
                              ),
                            ],
                          ),
                        ),


                      ]
                  ),
                ),

              ],
            ),

            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child:InkWell(
                      onTap: (){
                        PhoneLogDiallerNameColorDropdown =! PhoneLogDiallerNameColorDropdown;
                        emit(PopUpMenuUpdate());
                      },
                      child: Row(children: [Icon(
                        Icons.person,
                      ),Text("Conatct Name Color")],))
              ),
            ),
            AnimatedSize(
              curve:Curves.easeIn,
              duration: Duration(seconds: 1),
              child: Container(
                height: PhoneLogDiallerNameColorDropdown==false?0:400,
                child: ColorPicker(
                  // enableOpacity: true,
                  // Use the screenPickerColor as start color.
                  color: PhoneLogDiallerNameColor,
                  // Update the screenPickerColor using the callback.
                  pickersEnabled: const <ColorPickerType,bool>{
                    ColorPickerType.custom: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.wheel: true,
                  },
                  onColorChangeEnd: (color) {
                    PhoneLogDiallerNameColor = color;
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
                        PhoneLogPhoneNumberColorDropdown =! PhoneLogPhoneNumberColorDropdown;

                        emit(PopUpMenuUpdate());
                      },
                      child: Row(children: [Icon(
                        Icons.tag,
                      ),Text("Phone Number Color")],))
              ),
            ),
            AnimatedSize(
              curve:Curves.easeIn,
              duration: Duration(seconds: 1),
              child: Container(
                height: PhoneLogPhoneNumberColorDropdown==false?0:400,
                child: ColorPicker(
                  // enableOpacity: true,
                  // Use the screenPickerColor as start color.
                  color: PhoneLogPhoneNumberColor,
                  // Update the screenPickerColor using the callback.
                  pickersEnabled: const <ColorPickerType,bool>{
                    ColorPickerType.custom: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.wheel: true,
                  },
                  onColorChangeEnd: (color) {
                    PhoneLogPhoneNumberColor = color;
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
                        AppBackGroundColorDropdown =! AppBackGroundColorDropdown;

                        emit(PopUpMenuUpdate());
                      },
                      child: Row(children: [Icon(
                        Icons.wallpaper,
                      ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("AppBackGround"),
                            // SizedBox(width: 10,),
                            Text("Note: Affect both Logs and Contacts background",style: TextStyle(color: Colors.red),),
                          ],
                        ),

                      ],
                      ))
              ),
            ),
            AnimatedSize(
              curve:Curves.easeIn,
              duration: Duration(seconds: 1),
              child: Container(
                height: AppBackGroundColorDropdown==false?0:400,
                child: ColorPicker(
                  // enableOpacity: true,
                  // Use the screenPickerColor as start color.
                  color: AppBackGroundColor,
                  // Update the screenPickerColor using the callback.
                  pickersEnabled: const <ColorPickerType,bool>{
                    ColorPickerType.custom: true,
                    ColorPickerType.accent: true,
                    ColorPickerType.wheel: true,
                  },
                  onColorChangeEnd: (color) {
                    AppBackGroundColor = color;
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


  //Define some custom colors for the custom picker segment.
  //The 'guide' color values are from
  //https://material.io/design/color/the-color-system.html#color-theme-creation
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

  List LiveThemeEditting = [];
  List DefaultThemeValues = [];
  TextEditingController ThemeName = TextEditingController();
  List<TextEditingController> ThemeNameController =[];


  void addNewTheme() {
    MyThemeData .add({
      "name": ThemeName.text,
      "AppBarBackgroundColor": '#${CustomHomePageBackgroundColor.toString().replaceAll("Color", "").substring(5).replaceAll(")", "").toUpperCase()}',
      "SearchTextColor": '#${SearchTextColor.toString().replaceAll("Color", "").substring(5).replaceAll(")", "").toUpperCase()}',
      "SearchBackgroundColor" : '#${SearchBackground.toString().replaceAll("Color", "").substring(5).replaceAll(")", "").toUpperCase()}',
      "TabBarColor": '#${TabBarTextColor.toString().replaceAll("Color", "").substring(5).replaceAll(")", "").toUpperCase()}',
      "UnSelectedTabBarColor" : '#${UnSelectedTabBarColor.toString().replaceAll("Color", "").substring(5).replaceAll(")", "").toUpperCase()}',
      "TabBarIndicatorColor" : "#${TabBarIndicatorColor.toString().replaceAll("Color", "").substring(5).replaceAll(")", "").toUpperCase()}",
      "PhoneLogDiallerColor" : "#${PhoneLogDiallerNameColor.toString().replaceAll("Color", "").substring(5).replaceAll(")", "").toUpperCase()}",
      "PhoneLogPhoneNumberColor" :'#${PhoneLogPhoneNumberColor.toString().replaceAll("Color", "").substring(5).replaceAll(")", "").toUpperCase()}',
      "AppBackGroundColor" : '#${AppBackGroundColor.toString().replaceAll("Color", "").substring(5).replaceAll(")", "").toUpperCase()}',
      "InCallBackgroundHeight": InCallBackgroundHeight.toString(),
      "InCallBackgroundVerticalPadding" : InCallBackgroundVerticalPading.toString(),
      "InCallBackgroundOpacity" : InCallBackgroundOpacity.toString(),
      "InCallBackgroundColor" : '#${InCallBackgroundColor.toString().replaceAll("Color", "").substring(5).replaceAll(")", "").toUpperCase()}',
      "CallerIDcolor":'#${CallerIDcolor.toString().replaceAll("Color", "").substring(5).replaceAll(")", "").toUpperCase()}',
      "CallerIDPhoneNumbercolor":'#${CallerIDPhoneNumbercolor.toString().replaceAll("Color", "").substring(5).replaceAll(")", "").toUpperCase()}',
      "InCallPhoneStateColor":'#${InCallPhoneStateColor.toString().replaceAll("Color", "").substring(5).replaceAll(")", "").toUpperCase()}',
      "CallerIDdfontSize": CallerIDfontSize.toString(),
      "CallerIDPhoneNumberfontSize":CallerIDPhoneNumberfontSize.toString(),
      "InCallPhoneStateSize":InCallPhoneStateSize.toString(),
      "DialPadBackground":DialPadBackgroundFilePicker!=null?DialPadBackgroundFilePicker.path:"null",
      "InCallBackground":InCallBackgroundFilePicker!=null?InCallBackgroundFilePicker.path:"null",
      "InCallBackgroundHeight" : InCallBackgroundHeight.toString(),
      "InCallBackgroundVerticalPading" : InCallBackgroundVerticalPading.toString(),
      "InCallBackgroundOpacity" :InCallBackgroundOpacity.toString(),
    });
  }
  void ThemeEditData() {
    MyThemeData[CurrentThemeEditIndex]=({
      "name": MyThemeData[CurrentThemeEditIndex]["name"],
      "AppBarBackgroundColor":
          '#${
            CustomHomePageBackgroundColor.toString()
                .replaceAll("Color", "")
                .substring(5)
                .replaceAll(")", "")
                .toUpperCase()
          }',
      "SearchTextColor": '#${
        SearchTextColor.toString()
            .replaceAll("Color", "")
            .substring(5)
            .replaceAll(")", "")
            .toUpperCase()}',
      "SearchBackgroundColor" : '#${
            SearchBackground.toString()
                .replaceAll("Color", "")
                .substring(5)
                .replaceAll(")", "")
                .toUpperCase()
          }',
      "TabBarColor": '#${
            TabBarTextColor.toString()
                .replaceAll("Color", "")
                .substring(5)
                .replaceAll(")", "")
                .toUpperCase()
          }',
      "UnSelectedTabBarColor" : '#${
            UnSelectedTabBarColor.toString()
                .replaceAll("Color", "")
                .substring(5)
                .replaceAll(")", "")
                .toUpperCase()
          }',
      "TabBarIndicatorColor" : "#${TabBarIndicatorColor.toString()
          .replaceAll("Color", "")
          .substring(5)
          .replaceAll(")", "")
          .toUpperCase()}",
      "PhoneLogDiallerColor" : "#${
        PhoneLogDiallerNameColor.toString()
            .replaceAll("Color", "")
            .substring(5)
            .replaceAll(")", "")
            .toUpperCase()
      }",
      "PhoneLogPhoneNumberColor" :'#${PhoneLogPhoneNumberColor.toString()
          .replaceAll("Color", "")
          .substring(5)
          .replaceAll(")", "")
          .toUpperCase()}',
      "AppBackGroundColor" : '#${
            AppBackGroundColor.toString()
                .replaceAll("Color", "")
                .substring(5)
                .replaceAll(")", "")
                .toUpperCase()}',
      "InCallBackgroundHeight": InCallBackgroundHeight.toString(),
      "InCallBackgroundVerticalPadding" : InCallBackgroundVerticalPading.toString(),
      "InCallBackgroundOpacity" : InCallBackgroundOpacity.toString(),
      "InCallBackgroundColor" : '#${InCallBackgroundColor.toString()
          .replaceAll("Color", "")
          .substring(5)
          .replaceAll(")", "")
          .toUpperCase()}',
      "CallerIDcolor":'#${CallerIDcolor.toString()
          .replaceAll("Color", "")
          .substring(5)
          .replaceAll(")", "")
          .toUpperCase()}',
      "CallerIDPhoneNumbercolor":'#${CallerIDPhoneNumbercolor.toString()
          .replaceAll("Color", "")
          .substring(5)
          .replaceAll(")", "")
          .toUpperCase()}',
      "InCallPhoneStateColor":'#${InCallPhoneStateColor.toString()
          .replaceAll("Color", "")
          .substring(5)
          .replaceAll(")", "")
          .toUpperCase()}',
      "CallerIDdfontSize": CallerIDfontSize.toString(),
      "CallerIDPhoneNumberfontSize":CallerIDPhoneNumberfontSize.toString(),
      "InCallPhoneStateSize":InCallPhoneStateSize.toString(),
      "DialPadBackground":DialPadBackgroundFilePicker!=null?DialPadBackgroundFilePicker.path:"null",
      "InCallBackground":InCallBackgroundFilePicker!=null?InCallBackgroundFilePicker.path:"null",
      "InCallBackgroundHeight" : InCallBackgroundHeight.toString(),
      "InCallBackgroundVerticalPading" : InCallBackgroundVerticalPading.toString(),
      "InCallBackgroundOpacity" :InCallBackgroundOpacity.toString(),
    });
  }


  void defaultThemevalues() {
    DefaultThemeValues.add({
      "name" : ThemeName.text,
      "AppBarBackgroundColor" : CustomHomePageBackgroundColor.toString(),
      "SearchTextColor" : SearchTextColor.toString(),
      "TabBarColor" :TabBarTextColor.toString(),

    });
  }

  void LoadThemeData(){
    MyThemeData = Themedata;
  }

  List MyThemeData =[ {
    "name" : 'LightTheme',
    "AppBarBackgroundColor" : '#EAE6F2',
    "SearchTextColor" : '#FFFFFF',
    "SearchBackgroundColor" : '#FFFFFF',
    "TabBarColor" : '#00B5EE',
    "UnSelectedTabBarColor" : '#A5A5A5',
    "TabBarIndicatorColor" : '#00B5EE',
    "PhoneLogDiallerColor" : '#292929',
    "PhoneLogPhoneNumberColor" : '#8E8E8E',
    "AppBackGroundColor" :'#FAFAFA',
    "InCallBackgroundHeight": "400",
    "InCallBackgroundVerticalPadding" : "0",
    "InCallBackgroundOpacity" : "1",
    "InCallBackgroundColor" : "#2C087A",
    "CallerIDcolor":"#F5F5F5",
    "CallerIDPhoneNumbercolor":"#C8C8C8",
    "InCallPhoneStateColor":'#FFFFFF',
    "CallerIDdfontSize": "25",
    "CallerIDPhoneNumberfontSize":"25",
    "InCallPhoneStateSize":"13",
    "DialPadBackground":"null",
    "InCallBackground":"null",
    "InCallBackgroundHeight":"400",
    "InCallBackgroundVerticalPading":"0",
    "InCallBackgroundOpacity":"1"
  },
    {
      "name" : 'DarkTheme',
      "AppBarBackgroundColor" : '#2A2A2A',
      "SearchTextColor" : '#2D4E80',
      "SearchBackgroundColor" : '#2D4E80',
      "TabBarColor" : '#00B5EE',
      "UnSelectedTabBarColor" : '#E1E1E1',
      "TabBarIndicatorColor" : '#00B5EE',
      "PhoneLogDiallerColor" : '#292929',
      "PhoneLogPhoneNumberColor" : '#8E8E8E',
      "AppBackGroundColor" :'#121212',
      "InCallBackgroundHeight": "400",
      "InCallBackgroundVerticalPadding" : "0",
      "InCallBackgroundOpacity" : "1",
      "InCallBackgroundColor" : "#2C087A",
      "CallerIDcolor":"#F5F5F5",
      "CallerIDPhoneNumbercolor":"#C8C8C8",
      "InCallPhoneStateColor":'#FFFFFF',
      "CallerIDdfontSize": "25",
      "CallerIDPhoneNumberfontSize":"25",
      "InCallPhoneStateSize":"13",
      "DialPadBackground":"null",
      "InCallBackground":"null",
      "InCallBackgroundHeight":"400",
      "InCallBackgroundVerticalPading":"0",
      "InCallBackgroundOpacity":"1"
    }

  ];

}