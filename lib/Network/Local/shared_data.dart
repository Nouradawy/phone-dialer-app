import 'dart:convert';

import 'cache_helper.dart';

String? token ;
bool ThemeSwitch =true;
String? UserProfilePic;
String? ContactsLength;
List FavoratesContactids=[];
List fblist = [];


Map<String, dynamic> ContactData = {};
Map ShardData =
{
  "UserProfilePic" : UserProfilePic,
  "ContactsLength" : ContactsLength,

};

void ThemeSharedPref () {
  ThemeSwitch = CacheHelper.getData(key: 'ThemeSwitch')==null?ThemeSwitch:CacheHelper.getData(key: 'ThemeSwitch');

}
void GetShardData()  {
  String SDList = CacheHelper.getData(key: 'ShardData');
  ShardData = json.decode(SDList);
  print(ShardData);

  String CDList = CacheHelper.getData(key: 'ContactData');
  ContactData = json.decode(CDList);
  print(CDList);

  String FavoratesContacts= CacheHelper.getData(key: 'FavList');
  FavoratesContactids = json.decode(FavoratesContacts);





}