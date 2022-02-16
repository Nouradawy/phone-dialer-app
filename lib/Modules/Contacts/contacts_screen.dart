
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
import 'package:hexcolor/hexcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'edit_contact.dart';

class ContactsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context ) {
        var Cubit = PhoneContactsCubit.get(context);
        double AppbarSize = MediaQuery.of(context).padding.top+AppCubit.get(context).AppbarSize-19;
        // PhoneContactsCubit.get(context).GetShardPrefrancesData();

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

    return BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
        builder: (context , state) {
          final List NumbersInAccount=[];
          String? IsPrimery;
          final List SocialMediaList=[{
            "platform": "facebook",
            "Icon"  : FaIcon(FontAwesomeIcons.facebookSquare,size: 35,),
            "UserName": "Heba El-baz",
          }];

          contact.info?.phones.forEach((e) {
            if(e.isPrimary ==true){
              IsPrimery =  e.number;
            }
            if(e.accountType == contact.info?.accounts.first.type)
              {
                NumbersInAccount.add({
                  'label':e.label,
                  'number':e.number});
              }
          });
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[100],
              actions: [
                IconButton(onPressed: (){
                  PhoneContactsCubit.get(context).FavoratesItemColors();
                  if(contact.info?.isStarred ==true) {
                    contact.info?.isStarred = false;
                    contact.info?.update();
                    PhoneContactsCubit.get(context).FavoratesContacts.remove(contact);
                  }else {
                    contact.info?.isStarred = true;
                    contact.info?.update();
                    PhoneContactsCubit.get(context).FavoratesContacts.add(contact);
                  }
                }, icon:const Icon(Icons.star)),
              IconButton(icon: FaIcon(FontAwesomeIcons.edit),onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>ContactEditor(contact,NumbersInAccount.toList())));
              },),


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
            body: BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
              builder:(context,state)=> SafeArea(
                child: Column(
                  children: [
                    ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: NumbersInAccount.length*55+70,
                        ),
                        child: DefaultAccountView(NumbersInAccount, IsPrimery)),
                    const Divider(thickness: 1, indent: 25, endIndent: 25,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.sticky_note_2),
                        const SizedBox(width:15),
                        contact.info!.notes.length >0?ContactTagNotes(context , contact.info?.notes):Container(
                          width:MediaQuery.of(context).size.width*0.50,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color:HexColor("#F5F5F5"),
                          ),
                          child: Center(child: Icon(Icons.add)),
                        ),
                        const SizedBox(width:21,),
                        ///Social Media Area Where the user can link there Accounts here
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.25,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: SocialMediaList.length,
                                itemBuilder: (context,index){
                                  return Row(children: [
                                    SocialMediaList[index]["Icon"],

                                    Padding(
                                      padding: const EdgeInsets.only(left:3.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(SocialMediaList[index]["platform"],style: TextStyle(height: 1.3,fontWeight:FontWeight.w600),),
                                          Text(SocialMediaList[index]["UserName"],style: TextStyle(height: 1,fontSize: 10),),
                                        ],
                                      ),
                                    ),
                                  ],);
                                },
                              ),
                            ),
                            MaterialButton(
                              padding: EdgeInsets.all(5),
                              onPressed: (){
                              },
                              child: Row(children: [Image.asset("assets/Images/link.png",scale: 2.4,),SizedBox(width: 5),Text("Link Account")],),
                              color: HexColor("#C2C2C2"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                              ),

                            ),
                          ],
                      ),
                        ),
                    ],),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  ListView DefaultAccountView(List<dynamic> NumbersInAccount, String? IsPrimery) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: NumbersInAccount.length,
        itemBuilder: (context,index){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///Account Name and type
              index==0?Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
                child: Row(
                  children: [
                    AccountIcon(contact.info?.accounts[index].type),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4,),
                          AccountTitle(contact.info?.accounts[index].type),
                          Transform.translate(
                              offset: Offset(0,-7),
                              child: Text("${contact.info?.accounts[index].name}")),
                        ],
                      ),
                    ),
                  ],
                ),
              ):Container(),
              ///Defualt Phone Number
              index==0 &&IsPrimery!=null ?
              ListTile(
                        leading: Icon(Icons.phone_rounded),
                        title:Text("${IsPrimery}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color:HexColor('#01223B').withOpacity(0.11),
                            ),
                            child:IconButton(onPressed: (){} , icon:Icon(Icons.sms_rounded, color: HexColor("#8E2479"),)),
                          ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color:HexColor('#01223B').withOpacity(0.11),
                              ),
                              child:IconButton(onPressed: (){} , icon:FaIcon(FontAwesomeIcons.phoneAlt, color: HexColor("#28A7D6"),)),
                            ),],),
                      ):Container(),
              //TODO:ADD more account types Competability(Phone numbers ex:Google - samsung - apple what so ever)
              contact.info?.accounts[0].type==contact.info?.accounts[0].type &&contact.info?.phones[index].number !=IsPrimery?
              ListTile(
                title:Text("${contact.info?.phones[index].number}"),
                leading: IsPrimery==null?Icon(Icons.phone_rounded):Text(""),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color:HexColor('#01223B').withOpacity(0.11),
                      ),
                      child:IconButton(onPressed: (){} , icon:Icon(Icons.sms_rounded, color: HexColor("#8E2479"),)),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color:HexColor('#01223B').withOpacity(0.11),
                      ),
                      child:IconButton(onPressed: (){} , icon:FaIcon(FontAwesomeIcons.phoneAlt, color: HexColor("#28A7D6"),)),
                    ),],),
              ):Container(),
            ],
          );
        });
  }

  Text AccountTitle(AccountType) {
    if(AccountType?.contains("google")==true)
      return Text("Google");
    if(AccountType?.contains("whatsapp")==true)
      return Text("Whatsapp");
    else
      return Text("Google");
  }

  FaIcon AccountIcon(String? AccountType) {
    if(AccountType?.contains("google")==true)
    return FaIcon(FontAwesomeIcons.googlePlusSquare,size:32);
    if(AccountType?.contains("whatsapp")==true)
    return FaIcon(FontAwesomeIcons.whatsappSquare);
    else
      return FaIcon(FontAwesomeIcons.facebook);
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


