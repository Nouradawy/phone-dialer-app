import 'dart:typed_data';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_states.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                  leading: ContactAvatar(contact, 45),
                  title: Text(contact.info!.displayName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 40,
                        width:41,
                        child: Column(
                          children: [
                            const SizedBox(height:2),
                            IconButton(
                              constraints: const BoxConstraints(
                                minWidth: 37,
                                maxWidth: 50,
                              ),
                              padding: EdgeInsets.all(0),
                              iconSize: 24,
                              splashRadius: 15,
                              onPressed: (){
                                Contact=contact;
                                NDialog(
                                  title: TextField(
                                    controller: SearchController,
                                    onChanged: (value) {
                                      PhoneContactsCubit.get(context).SearchContacts(SearchController, PhoneContactsCubit.get(context).ContactsNoThumb);
                                    if (SearchController.text.isEmpty) {PhoneContactsCubit.get(context).isSearching = false;
                                    } else {
                                      PhoneContactsCubit.get(context).isSearching = true;}},
                                  ),
                                  content: BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
                                    builder:(context,state) {

                                      return Container(
                                      width: MediaQuery.of(context).size.width * 0.80,
                                      height: MediaQuery.of(context).size.height * 0.70,
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
                            ).show(context);
                          },
                              icon: const FaIcon(FontAwesomeIcons.facebookSquare),
                            ),
                            const Text("Facebook",style: TextStyle(height: 1.4 , fontSize: 9),),
                          ],
                        ),
                      ),
                      Container(height: 40,width: 2,color: Colors.blueAccent),
                      SizedBox(
                        height: 40,
                        width:41,
                        child: Column(
                          children: [
                            const SizedBox(height:2),
                            IconButton(
                              constraints: const BoxConstraints(
                                minWidth: 37,
                                maxWidth: 50,
                              ),
                              padding: EdgeInsets.all(0),
                              iconSize: 24,
                              splashRadius: 15,
                              onPressed: (){},
                              icon: const FaIcon(FontAwesomeIcons.googlePlusG ,),
                            ),
                            const Text("Google",style: TextStyle(height: 1.2 , fontSize: 9),),
                          ],
                        ),
                      ),
                      Container(height: 40,width: 2,color: Colors.blueAccent),
                      SizedBox(
                        height: 40,
                        width:41,
                        child: Column(
                          children: [
                            const SizedBox(height:2),
                            IconButton(
                              constraints: const BoxConstraints(
                                minWidth: 37,
                                maxWidth: 50,
                              ),
                              padding: EdgeInsets.all(0),
                              iconSize: 24,
                              splashRadius: 15,
                              onPressed: (){},
                              icon: const FaIcon(FontAwesomeIcons.twitter),
                            ),
                            const Text("Twitter",style: TextStyle(height: 1.5 , fontSize: 9),),
                          ],
                        ),
                      ),

                    ],
                  ),

                );
              },

            ),

        ),
    );
  }
}
