
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
import 'package:flutter_bloc/flutter_bloc.dart';
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


class ContactDetails extends StatefulWidget {
  ContactDetails(this.contact, {required this.onContactUpdate, required this.onContactDelete});

  final AppContact contact;
  final Function(AppContact) onContactUpdate;
  final Function(AppContact) onContactDelete;
  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {

  @override
  Widget build(BuildContext context) {
    List<String> actions = <String>[
      'Edit',
      'Delete'
    ];

    return BlocConsumer<PhoneContactsCubit,PhoneContactStates>(
        listener: (context , state){},
        builder: (context , state) {


          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[100],
              actions: [
                IconButton(onPressed: (){
                  PhoneContactsCubit.get(context).FavoratesItemColors();
                  final ContactsID = PhoneContactsCubit.get(context).FavoratesContactsID;

                        if (ContactsID.contains(widget.contact.info?.id) == true) {
                          ContactsID.remove(widget.contact.info?.id);
                          PhoneContactsCubit.get(context).FavoratesContacts.remove(widget.contact);

                        } else {
                          ContactsID.add(widget.contact.info?.id);
                          PhoneContactsCubit.get(context).FavoratesContacts.add(widget.contact);
                        }

                  CacheHelper.saveData(key: "FavList", value: json.encode(ContactsID));

                      print(PhoneContactsCubit.get(context).FavoratesContactsID.toString());
                }, icon:const Icon(Icons.star)),
              //   PopupMenuButton(
              //   onSelected: onAction,
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
                  ContactAvatar(widget.contact, 70),
                  SizedBox(width: 10,),
                  Container(
                    width:110,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Text(widget.contact.info!.displayName.toString(),style: TextStyle(color: Colors.black,fontFamily: "Cairo" , fontSize: widget.contact.info!.displayName.length >32?12:15 , fontWeight: FontWeight.w400  ),overflow: TextOverflow.visible, ),

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
              child: Column(
                children: <Widget>[

                  Expanded(
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      ListTile(
                        title: const Text("Name"),
                        trailing: Text(widget.contact.info!.name.first ),
                      ),
                      ListTile(
                        title: const Text("Family name"),
                        trailing: Text(widget.contact.info!.name.last),
                      ),
                     widget.contact.info!.accounts.length>1? Row(children: [
                        Text(widget.contact.info!.accounts[1].name.toString()),
                      ],):Container() ,
                      Column(
                        children: <Widget>[
                          const ListTile(title: Text("Phones")),
                          Column(
                            children: widget.contact.info!.phones
                                .map(
                                  (i) => Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                                child: ListTile(
                                  title: Text(i.label.name.toString()),
                                  trailing: Text(i.normalizedNumber),
                                ),
                              ),
                            )
                                .toList(),
                          ),
                          MaterialButton(onPressed: (){
                            PhoneContactsCubit.get(context).Contacts.forEach((element) {
                              if(element.FBimgURL!=null)
                                {
                                  ContactData.addAll({
                                   "${element.info?.id}": element.FBimgURL,
                                  });
                                }
                            });

                            print(ShardData.toString());
                            print(ContactData.toString());
                            CacheHelper.saveData(key: "ShardData", value: json.encode(ShardData));
                            CacheHelper.saveData(key: "ContactData", value: json.encode(ContactData));
                            // ));
                            Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => Webpage(widget.contact,)));
                          },child:Container(
                            color: Colors.blueGrey,
                            width:70,
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Image Picker" ,style: TextStyle(color:Colors.white),),
                              ],
                            ),
                          )),
                        ],
                      )
                    ]),
                  )
                ],
              ),
            ),
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


// Row(
// children: [
// Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(7),
// color: Colors.grey[300],
// ),
// width:45,
// height: MediaQuery.of(context).size.height*0.055,
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Icon(Icons.call),
// Text("Call",style: Theme
//     .of(context)
// .textTheme
//     .bodyText1!.copyWith(fontSize: 10),),
// ],),
// ),
// SizedBox(width: 10,),
// Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(7),
// color: Colors.grey[300],
// ),
// width:45,
// height: MediaQuery.of(context).size.height*0.055,
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Icon(Icons.message),
// Text("Message",style: Theme
//     .of(context)
// .textTheme
//     .bodyText1!.copyWith(fontSize: 10),),
// ],),
// ),
//
// ],
// ),