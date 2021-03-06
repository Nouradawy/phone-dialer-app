
import 'dart:typed_data';

import 'package:azlistview/azlistview.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dialer_app/Components/contacts_components.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class ContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context ) {
    var Cubit = AppCubit.get(context);
    double AppbarSize = MediaQuery.of(context).size.height*Cubit.AppbarSize;
    List<Color> FavColors =[
      HexColor("#515150"),
      HexColor("#FF4B76"),
      HexColor("#2C087A"),
      HexColor("#C6C972"),
      HexColor("#515150"),
      HexColor("#FF4B76"),
      HexColor("#2C087A"),
      HexColor("#C6C972"),
      HexColor("#515150"),
      HexColor("#FF4B76"),
      HexColor("#2C087A"),
      HexColor("#C6C972"),

    ];
    return BlocProvider.value(
      value:AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
          listener:(context,state){},
          builder:(context,state)
          {
            return Padding(
              padding: EdgeInsets.only(top:AppbarSize*1.40),
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: AzListView(
                      indexBarMargin:EdgeInsets.only(top:45),
                    indexBarOptions: IndexBarOptions(

                    ),
                      data:Cubit.Azitem,
                      itemCount: Cubit.isSearching == true?Cubit.FilterdContacts.length:Cubit.Contacts.length,
                      itemBuilder:(context , index)
                      {
                        AppContact contact = Cubit.isSearching == true?Cubit.FilterdContacts[index]:Cubit.Contacts[index];
                        return Column(
                          children: [
                            index==0?FavoritesContactsGroups(AppbarSize, Cubit, FavColors):Container(),
                            index==0?Text("Contacts"):Container(),
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ContactDetails(
                                          contact,
                                          onContactDelete: (AppContact _contact) {
                                            Cubit.GetContacts();
                                            Navigator.of(context).pop();
                                          },
                                          onContactUpdate: (AppContact _contact) {
                                            Cubit.GetContacts();
                                          },
                                        )
                                ));
                              },
                              title: Text(
                                contact.info!.displayName.toString(), style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1,),
                              subtitle: Text(
                                contact.info!.phones!.isNotEmpty ? contact.info!
                                    .phones!
                                    .elementAt(0).value.toString() : '',
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
                  )

              ),
            );}
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

    showDeleteConfirmation() {
      Widget cancelButton = FlatButton(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget deleteButton = FlatButton(
        color: Colors.red,
        child: Text('Delete'),
        onPressed: () async {
          await ContactsService.deleteContact(widget.contact.info!);
          widget.onContactDelete(widget.contact);
          Navigator.of(context).pop();
        },
      );
      AlertDialog alert= AlertDialog(
        title: Text('Delete contact?'),
        content: Text('Are you sure you want to delete this contact?'),
        actions: <Widget>[
          cancelButton,
          deleteButton
        ],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          }
      );

    }

    onAction(String action) async {
      switch(action) {
        case 'Edit':
          try {
            Contact updatedContact = await ContactsService.openExistingContact(widget.contact.info!);
            setState(() {
              widget.contact.info = updatedContact;
            });
            widget.onContactUpdate(widget.contact);
          } on FormOperationException catch (e) {
            switch(e.errorCode) {
              case FormOperationErrorCode.FORM_OPERATION_CANCELED:
              case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
              case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                print(e.toString());
            }
          }
          break;
        case 'Delete':
          showDeleteConfirmation();
          break;
      }
      print(action);
    }
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context , state){},
        builder: (context , state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 180,
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Center(child: ContactAvatar(widget.contact, 100)),
                        Align(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          alignment: Alignment.topLeft,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(onPressed: (){
                                AppCubit.get(context).FavoratesContacts.add(widget.contact);
                              }, icon:Icon(Icons.star)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PopupMenuButton(
                                  onSelected: onAction,
                                  itemBuilder: (BuildContext context) {
                                    return actions.map((String action) {
                                      return PopupMenuItem(
                                        value: action,
                                        child: Text(action),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      ListTile(
                        title: Text("Name"),
                        trailing: Text(widget.contact.info!.givenName ?? ""),
                      ),
                      ListTile(
                        title: Text("Family name"),
                        trailing: Text(widget.contact.info!.familyName ?? ""),
                      ),
                      Column(
                        children: <Widget>[
                          ListTile(title: Text("Phones")),
                          Column(
                            children: widget.contact.info!.phones!
                                .map(
                                  (i) => Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                                child: ListTile(
                                  title: Text(i.label ?? ""),
                                  trailing: Text(i.value ?? ""),
                                ),
                              ),
                            )
                                .toList(),
                          )
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
        child:buildCircleAvatar(contact.info!.avatar,contact.info!.initials()));
  }
}
CircleAvatar buildCircleAvatar(Uint8List? avatar, String initials) {
  if(avatar != null && avatar.length > 0){
    return CircleAvatar(backgroundImage:MemoryImage(avatar));
  } else {
    return CircleAvatar(child: Text(initials.toString(),
        style: TextStyle(color: Colors.white)),
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