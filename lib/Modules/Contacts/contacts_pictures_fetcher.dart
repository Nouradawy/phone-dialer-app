import 'dart:typed_data';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_states.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ndialog/ndialog.dart';

import 'appcontacts.dart';
import 'contacts_screen.dart';



class ContactsFetcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController SearchController = TextEditingController();
    bool FacebookIsPressed = false;
    bool GoogleIsPressed = false;
    bool TwitterIsPressed = false;
    return BlocProvider.value(
      value:PhoneContactsCubit.get(context)..SearchContacts,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title:Text("Contacts Updater"),
        ),
        body:
            ListView.builder(
              itemCount: PhoneContactsCubit.get(context).ContactsNoThumb.length,
              itemBuilder: (context,Index) {
                AppContact contact =PhoneContactsCubit.get(context).ContactsNoThumb[Index];
                late final AppContact Contact;
                return ListTile(
                  onTap: (){
                    Contact=contact;
                    NDialog(
                      content: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.75,
                        ),
                        child: DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              Material(
                                // type:MaterialType.transparency,
                                color:HexColor("#559FFF").withOpacity(0.64),
                                child: TabBar(
                                  labelColor: Colors.white,
                                  indicatorColor: HexColor("#F07F5C"),
                                  unselectedLabelColor: Colors.black,
                                  indicator: BoxDecoration(
                                    color: HexColor("#EB3B04").withOpacity(0.65),
                                  ),
                                  tabs: [
                                    Tab(text: 'Facebook', icon: FaIcon(FontAwesomeIcons.facebookSquare ,color:Colors.black)),
                                    Tab(text: 'Google', icon: FaIcon(FontAwesomeIcons.google ,color:Colors.black)),
                                    Tab(text: 'Twitter', icon: FaIcon(FontAwesomeIcons.twitter, color:Colors.black)),
                                  ],
                                ),
                              ),
                              Row(children: [
                                //TODO:Move Cursor with lable
                                Container(height: 3,width:(MediaQuery.of(context).size.width * 0.80 )/3,color: HexColor("#EB3B04").withOpacity(0.65),),
                              ],),
                              //TODO: Make the search bar as Icon would be better
                              TextField(
                                controller: SearchController,
                                onChanged: (value) {
                                  PhoneContactsCubit.get(context).SearchContacts(SearchController, PhoneContactsCubit.get(context).ContactsNoThumb);
                                  if (SearchController.text.isEmpty) {PhoneContactsCubit.get(context).isSearching = false;
                                  } else {
                                    PhoneContactsCubit.get(context).isSearching = true;}},
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.80,
                                height: MediaQuery.of(context).size.height * 0.58,
                                child: TabBarView(
                                    children: [
                                      BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
                                        builder:(context,state) {
                                          return Container(
                                            width: MediaQuery.of(context).size.width * 0.80,
                                            height: MediaQuery.of(context).size.height * 0.58,
                                            child: PhoneContactsCubit.get(context).isSearching == true?ListView.builder(
                                                itemCount: PhoneContactsCubit.get(context).FilterdContacts.length,
                                                itemBuilder: (context, index) {
                                                  AppContact contact =PhoneContactsCubit.get(context).FilterdContacts[index];
                                                  return ListTile(
                                                    onTap: (){},
                                                    title: Text(contact.info!.displayName),
                                                    leading: ContactAvatar(contact, 45),);
                                                }):ListView.builder(
                                              itemCount: fbList.length,
                                              itemBuilder: (context, index) {
                                                String Image = fbList[index]["ProfileIMG"];
                                                String UserName = fbList[index]["UserName"];
                                                return ListTile(
                                                    onTap:() async {
                                                      Contact.info?.photo = await PhoneContactsCubit.get(context).ToUint8List(Image.replaceAll('"', ''));
                                                      Contact.info?.thumbnail = await PhoneContactsCubit.get(context).ToUint8List(Image.replaceAll('"', ''));
                                                      Contact.info?.socialMedias=[SocialMedia("Facebook: ${UserName.replaceAll('"', '')} | UID: ${fbList[index]["UID"]} ",label:SocialMediaLabel.other,customLabel:'facebook')];
                                                      await Contact.info?.update();
                                                    },
                                                    title: Text(UserName.replaceAll('"', '')),
                                                    leading: FittedBox(
                                                      fit:BoxFit.cover,
                                                      child: CircleAvatar(radius: 45,backgroundImage: NetworkImage(Image.replaceAll('"', ''))),
                                                    ));
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      Text("2"),
                                      Text("2"),
                                    ]
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      dialogStyle: DialogStyle(
                        titlePadding: EdgeInsets.all( 0),
                        contentPadding: EdgeInsets.all(0),
                      ),).show(context);
                  },
                  leading: ContactAvatar(contact, 45),
                  title: Text(contact.info!.displayName),

                );
              },

            ),

        ),
    );
  }
}
