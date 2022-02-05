
import 'dart:convert';
import 'dart:typed_data';

import 'package:azlistview/azlistview.dart';
import 'package:dialer_app/Components/constants.dart';

import 'package:dialer_app/Components/contacts_components.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_states.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/Modules/webview/webpage.dart';
import 'package:dialer_app/Network/Local/cache_helper.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context ) {
        var Cubit = PhoneContactsCubit.get(context);
        double AppbarSize = MediaQuery.of(context).padding.top+AppCubit.get(context).AppbarSize-19;
        PhoneContactsCubit.get(context).GetShardPrefrancesData();

    ContactsLength = Cubit.Contacts.length.toString();
        return Padding(
            padding: EdgeInsets.only(top:AppbarSize),
            child: AzListView(
                indexBarMargin:const EdgeInsets.only(top:45),
                indexBarOptions: const IndexBarOptions(
                ),
                data:Cubit.Contacts,
                itemCount:  Cubit.isSearching==true ?Cubit.FilterdContacts.length:Cubit.Contacts.length,
                itemBuilder:(context , index)
                {
                  AppContact contact = Cubit.isSearching==true ?Cubit.FilterdContacts[index]:Cubit.Contacts[index];
                  return Column(
                    children: [
                      index==0?FavoritesContactsGroups(Cubit):Container(),
                      index==0?const Text("Contacts"):Container(),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                           onTap: () {
                             CacheHelper.saveData(key: "fblist", value: json.encode(fbList));
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => ContactDetails(
                                contact,
                                onContactDelete: (AppContact _contact) {
                                  PhoneContactsCubit.get(context).GetRawContacts();
                                  Navigator.of(context).pop();
                                  },
                                onContactUpdate: (AppContact _contact) {
                                  PhoneContactsCubit.get(context).GetRawContacts();
                                  },)
                          ));
                          },
                            title: Text(
                              contact.info!.displayName.toString(), style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1,),
                            subtitle: Text(
                              contact.info!.phones.isNotEmpty ? contact.info!
                                  .phones.elementAt(0).number.toString() : '',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText2,),
                            leading: ContactAvatar(contact, 45),
                            trailing: ContactsTagsNotes(context),
                          ),
                    ],
                  );
                    }
                ),
              );


  }



}




class ContactDetails extends StatelessWidget {
  ContactDetails(this.contact, {required this.onContactUpdate, required this.onContactDelete});

  final AppContact contact;
  final Function(AppContact) onContactUpdate;
  final Function(AppContact) onContactDelete;

  @override
  Widget build(BuildContext context) {
    List<String> actions = <String>[
      'Edit',
      'Delete'
    ];

    return BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
        builder: (context , state) {
          final List NumbersInAccount=[];
          PhoneListBuilder(contact,NumbersInAccount );
          String? IsPrimery;
          contact.info?.phones.forEach((e) {
            if(e.isPrimary ==true){
              IsPrimery =  e.number;
            }
          });
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[100],
              actions: [
                IconButton(onPressed: (){
                  PhoneContactsCubit.get(context).FavoratesItemColors();
                  final ContactsID = PhoneContactsCubit.get(context).FavoratesContactsID;

                        if (ContactsID.contains(contact.info?.id) == true) {
                          ContactsID.remove(contact.info?.id);
                          PhoneContactsCubit.get(context).FavoratesContacts.remove(contact);

                        } else {
                          ContactsID.add(contact.info?.id);
                          PhoneContactsCubit.get(context).FavoratesContacts.add(contact);
                        }

                  CacheHelper.saveData(key: "FavList", value: json.encode(ContactsID));

                      print(PhoneContactsCubit.get(context).FavoratesContactsID.toString());
                }, icon:const Icon(Icons.star)),
              IconButton(icon: FaIcon(FontAwesomeIcons.edit),onPressed: (){},),
              //   PopupMenuButton(
              //   icon: Icon(Icons.ac_unit),
              //   itemBuilder: (BuildContext context) {
              //     return actions.map((String action) {
              //       return PopupMenuItem(
              //         value: action,
              //         child: Text(action),
              //       );
              //     }).toList();
              //   },
              // ),

              ],
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ContactAvatar(contact, 70),
                  SizedBox(width: 10,),
                  Container(
                    width:110,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Text(contact.info!.displayName.toString(),style: TextStyle(color: Colors.black,fontFamily: "Cairo" , fontSize: contact.info!.displayName.length >32?12:15 , fontWeight: FontWeight.w400  ),overflow: TextOverflow.visible, ),

                        ),
//                         Row(
//                         children: [
//                         FaIcon(FontAwesomeIcons.whatsapp ,size: 15,color: Colors.green,),
//                         SizedBox(width: 2,)
// ,                        Text(widget.contact.info!.socialMedias.elementAt(0).toString(),style: TextStyle(color: Colors.black,fontFamily: "Cairo" , fontSize: 8 , fontWeight: FontWeight.w400),),
//                         ],),
                        Row(
                        children: [
                        FaIcon(FontAwesomeIcons.facebookSquare ,size: 15,color: Colors.green,),
                        SizedBox(width: 2,)
,                        Text("Omar",style: TextStyle(color: Colors.black,fontFamily: "Cairo" , fontSize: 8 , fontWeight: FontWeight.w400),),
                        ],),
                        Row(
                        children: [
                        FaIcon(FontAwesomeIcons.twitter ,size: 15,color: Colors.green,),
                        SizedBox(width: 2,)
,                        Text("Omar",style: TextStyle(color: Colors.black,fontFamily: "Cairo" , fontSize: 8 , fontWeight: FontWeight.w400),),
                        ],),
                        SizedBox(height: 8,),

                      ],
                    ),
                  ),

                ],
              ),
              toolbarHeight: MediaQuery.of(context).size.height*0.12,
              // titleSpacing: MediaQuery.of(context).size.width*0.25,
            ),
            body: SafeArea(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: contact.info?.phones.length,
                  itemBuilder: (context,index){

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            AccountIcon(contact.info?.accounts[index].type),
                            Text("${contact.info?.accounts[index].type}"),
                          ],
                        ),
                        index==0?Row(children:[
                          FaIcon(FontAwesomeIcons.phone),
                          Text("${IsPrimery}")]):Container(),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                            itemCount: contact.info?.phones.length,
                            itemBuilder: (context,Index){

                            return contact.info?.phones[Index].accountType == contact.info?.accounts[index].type &&contact.info?.phones[Index].number !=IsPrimery ?ListTile(
                              title:Text("${contact.info?.phones[Index].number}"),
                            ):Container();
                            }),
                      ],
                    );
                  }),
            ),
          );
        }
    );
  }

  FaIcon AccountIcon(String? AccountType) {
    if(AccountType?.contains("google")==true)
    return FaIcon(FontAwesomeIcons.googlePlusSquare);
    if(AccountType?.contains("whatsapp")==true)
    return FaIcon(FontAwesomeIcons.whatsappSquare);
    else
      return FaIcon(FontAwesomeIcons.facebook);
  }

   PhoneListBuilder(AppContact contact , NumbersInAccount) {
   List PhoneList=[];
   return ListView.builder(
       itemCount: contact.info?.accounts.length,
       itemBuilder: (context,index)
       {
         return ListTile(
         title: Text('hi'),
         );
     }
     );

  }


}

class ContactAvatar extends StatelessWidget {
  ContactAvatar(this.contact, this.size);
  final AppContact contact;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle, gradient: getColorGradient(contact.color)),
        child:buildCircleAvatar(contact.info!.thumbnail,contact.info!.displayName[0]));
  }
}
CircleAvatar buildCircleAvatar(Uint8List? avatar, String initials) {
  if(avatar != null && avatar.isNotEmpty){

    return CircleAvatar(backgroundImage:MemoryImage(avatar));
  } else {
    return CircleAvatar(child: Text(initials.toString(),
        style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.transparent,
    );
  }
}

LinearGradient getColorGradient(Color? color) {
  var baseColor = color as dynamic;
  Color color1 = baseColor[800];
  Color color2 = baseColor[400];
  return LinearGradient(colors: [
    color1,
    color2,
  ], begin: Alignment.bottomLeft, end: Alignment.topRight);
}


