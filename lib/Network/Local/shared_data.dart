import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dialer_app/Themes/Cubit/cubit.dart';
import 'package:path_provider/path_provider.dart';

import 'cache_helper.dart';
// var PickedFileShared;
// File? BackGroundImage;
String? DialpadImagePath;
String? token ;
int ActiveTheme = 0;

List Themedata = [];
String? UserProfilePic;
String? ContactsLength;
List FavoratesContactids=[];
List fbList = [];
List ContactNotes = [];
List TagsNotes = [];
String? Notes;


Map<String, dynamic> ContactData = {};
Map ShardData =
{
  "UserProfilePic" : UserProfilePic,
  "ContactsLength" : ContactsLength,

};

Future<void> ThemeSharedPref (context)   async {

  // ThemeSwitch = CacheHelper.getData(key: 'ThemeSwitch')==null?ThemeSwitch:CacheHelper.getData(key: 'ThemeSwitch');

    if(CacheHelper.getData(key:'ThemeList') !=null) {
      String ThemeSavedData = CacheHelper.getData(key: 'ThemeList');
      Themedata = json.decode(ThemeSavedData);

      if(ThemeCubit.get(context).MyThemeData[ActiveTheme]["DialPadBackground"] !="null") {
        final imagePermanent = await SaveImagePermanently(ThemeCubit.get(context).MyThemeData[ActiveTheme]["DialPadBackground"]);
        ThemeCubit.get(context).DialPadBackGroundImagePicker = imagePermanent;
      }
      if(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackground"] !="null") {
        final imagePermanent = await SaveImagePermanently(ThemeCubit.get(context).MyThemeData[ActiveTheme]["InCallBackground"]);
        ThemeCubit.get(context).InCallBackGroundImagePicker  = imagePermanent;
      }
    }

    if(CacheHelper.getData(key: 'currentThemeindex')!=null) ActiveTheme = CacheHelper.getData(key: 'currentThemeindex');


  // print(Themedata[2]);
  // print(ActiveTheme);


  // DialpadImagePath = CacheHelper.getData(key: "DialPadImage");
  // print(" testing dialpad recalling from chachhelper : $DialpadImagePath");

}
void GetShardData()  {
  // String SDList = CacheHelper.getData(key: 'ShardData');
  // ShardData = json.decode(SDList);
  // print(ShardData);
  //
  // String CDList = CacheHelper.getData(key: 'ContactData');
  // ContactData = json.decode(CDList);
  // print(ContactData);

  if(CacheHelper.getData(key: 'fblist')!=null) {
  String FBList = CacheHelper.getData(key: 'fblist');

    fbList = json.decode(FBList);
    print(FBList);
    }
if(CacheHelper.getData(key: "Notes")!=null) {
    String NoteString = CacheHelper.getData(key: "Notes");
    ContactNotes = json.decode(NoteString);
  }
  // String FavoratesContacts= CacheHelper.getData(key: 'FavList');
  // FavoratesContactids = json.decode(FavoratesContacts);





}
Future<File> SaveImagePermanently(String imagePath) async {
  final directory= await getApplicationDocumentsDirectory();

  final image = File("${directory.path}/${Uri.file(imagePath).pathSegments.last}");
  return File(imagePath).copy(image.path);
}
void GetThemeColorData(){

}