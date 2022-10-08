
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:azlistview/azlistview.dart';
import 'package:dialer_app/Components/constants.dart';

import 'package:dialer_app/Components/contacts_components.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_states.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/Modules/Phone/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Phone/Cubit/state.dart';
import 'package:dialer_app/Modules/Phone/phone_Log_screen.dart';
import 'package:dialer_app/Modules/SocialMediaImage/SocialMedia.dart';
import 'package:dialer_app/Modules/webview/webpage.dart';
import 'package:dialer_app/Network/Local/cache_helper.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Components/components.dart';
import '../../Layout/incall_screen.dart';
import '../../NativeBridge/native_bridge.dart';
import '../../Themes/theme_config.dart';
import 'edit_contact.dart';

class ContactsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context ) {

        var Cubit = PhoneContactsCubit.get(context);
        double AppbarSize = MediaQuery.of(context).padding.top+AppCubit.get(context).AppbarSize-19;
        final MediaQueryData AccessibilityText = MediaQuery.of(context);
    ContactsLength = Cubit.Contacts.length.toString();
        return Padding(
            padding: EdgeInsets.only(top:AppbarSize),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: AzListView(
                  indexBarMargin:const EdgeInsets.only(top:45),
                  indexBarOptions:  IndexBarOptions(
                    textStyle: TextStyle(),
                  ),
                  data:Cubit.Contacts,
                  itemCount:  Cubit.isSearching==true ?Cubit.FilterdContacts.length:Cubit.Contacts.length,
                  itemBuilder:(context , index)
                  {
                    AppContact contact = Cubit.isSearching==true ?Cubit.FilterdContacts[index]:Cubit.Contacts[index];
                    TagNotesHelper(context ,  contact);
                    return Column(
                      children: [
                        index==0 && Cubit.isSearching==false?FavoritesContactsGroups(Cubit,context,AccessibilityText):Container(),
                        index==0 && Cubit.isSearching==false?const Text("Contacts"):Container(),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                             onTap: () {
                               CacheHelper.saveData(key: "fblist", value: json.encode(fbList));
                               //Todo: CacheHelper saving fblist
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
                                contact.info!.displayName.toString(),textScaleFactor: AccessibilityText.textScaleFactor>1.2?1.2:AccessibilityText.textScaleFactor, style:ContactNameTextStyle() ),
                              subtitle: Text(
                                contact.info!.phones.isNotEmpty ? contact.info!
                                    .phones.elementAt(0).number.toString() : '',
                                style: ContactNumberTextStyle(),textScaleFactor: AccessibilityText.textScaleFactor>1.2?1.2:AccessibilityText.textScaleFactor),
                              leading: ContactAvatar(contact, 45),
                              trailing: ContactsTagsNotes(context , contact),
                            ),
                      ],
                    );
                      }
                  ),
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
          final List PhoneAccounts=[];
          String? PrimeryNumber;
          String? PrimeryNormalizedNumber;
          bool CallNotesUpdateSuccess = false;
          String? DisplyAccount = contact.info?.accounts.first.type;
          final List SocialMediaList=[{
            "platform": "facebook",
            "Icon"  : FaIcon(FontAwesomeIcons.facebookSquare,size: 35,),
            "UserName": "Heba El-baz",
          }];
          PhoneContactsCubit.get(context).FilterContactsByAccount(contact);

          contact.info?.phones.forEach((e) {
            if(PhoneContactsCubit.get(context).PhoneAccounts[PhoneContactsCubit.get(context).SelectedPhoneAccountIndex]["AccountType"] == e.AccountType)
              {
                NumbersInAccount.add({
                  'label':e.label,
                  'number':e.number});
              }
            if(e.isPrimary ==true){
              PrimeryNumber =  e.number;
              PrimeryNormalizedNumber =  e.normalizedNumber;

            }
          });

      //     if(contact.Notes ==null) {
      //   ContactNotes.forEach((element) {
      //     if (element["id"] == contact.info?.id) {
      //       contact.Notes = element["Notes"].replaceAll("[","").replaceAll("]","").split(',');
      //       print(element["Notes"]);
      //     }
      //   });
      // }


          // NativeBridge.get(context).CallNotesUpdate.forEach((e) {
          //   if(contact.info?.id ==e) {
          //     ContactNotes.forEach((element) {
          //       if (element["id"] == contact.info?.id) {
          //         contact.Notes = element["Notes"].replaceAll("[","").replaceAll("]","").split(',');
          //         print(element["Notes"]);
          //       }
          //     });
          //     CallNotesUpdateSuccess =true;
          //   }
          // });
          // if(CallNotesUpdateSuccess ==true)
          //   {
          //     NativeBridge.get(context).CallNotesUpdate.remove(contact.info?.id);
          //     CallNotesUpdateSuccess= false;
          //   }
          // print(contact.info?.phones.last);
      PhoneLogsCubit.get(context).ContactCallLogs(contact);
          print("test contact log ");

          return Stack(
            alignment: AlignmentDirectional.center,
            children: [

              Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.grey[100],
                  actions: [
                    IconButton(onPressed: (){
                      PhoneContactsCubit.get(context).FavoratesItemColors(PhoneContactsCubit.get(context).FavoratesContacts.length,false);
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
                      GestureDetector(
                          onTap: (){
                            PhoneContactsCubit.get(context).ContactEdit= !PhoneContactsCubit.get(context).ContactEdit;
                            PhoneContactsCubit.get(context).Daillerinput();
                          },
                          child: ContactAvatar(contact, 70)),
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
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: NumbersInAccount.length*55+70,
                              ),
                              child: DefaultAccountView(NumbersInAccount, PrimeryNumber , PrimeryNormalizedNumber , PhoneAccounts)),
                          const Divider(thickness: 1, indent: 25, endIndent: 25,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.sticky_note_2),
                              const SizedBox(width:15),
                              if (contact.Notes?.isNotEmpty==true) PhoneContactsCubit.get(context).NoteEditting==false?
                                  ///if Contact Notes not Empty && i am not in editting mode show Notes
                              InkWell(
                                  onTap:(){
                                    PhoneContactsCubit.get(context).AddNote();
                                  },
                                  child: ContactTagNotes(context , contact.Notes)):
                              ///if Contact Notes not Empty && i am in editting mode show Start Editting Notes
                              InkWell(
                                onTap: (){
                                  PhoneContactsCubit.get(context).AddNote();
                                },
                                child: Container(
                                  width:MediaQuery.of(context).size.width*0.50,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color:HexColor("#F5F5F5"),
                                  ),
                                  child: TextField(
                                    style: TextStyle(
                                      fontFamily: "OpenSans",
                                      fontSize: 12,
                                    ),
                                    controller: PhoneContactsCubit.get(context).NotesController,
                                    textAlign:TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    onSubmitted: (value){
                                      contact.Notes?.add(value);
                                      PhoneContactsCubit.get(context).AddNote();
                                      PhoneContactsCubit.get(context).NotesController.clear();
                                      ContactNotes.forEach((element) {
                                        if(element["id"] == contact.info?.id){

                                          element["Notes"]=contact.Notes.toString();
                                        }
                                      });
                                      CacheHelper.saveData(key: "Notes", value: json.encode(ContactNotes));
                                      print(PhoneContactsCubit.get(context).NoteEditting);
                                      print("Notes : "+contact.Notes.toString());
                                    },
                                    decoration: InputDecoration(
                                      border:InputBorder.none,
                                    ),
                                  ),
                                ),
                              ) else PhoneContactsCubit.get(context).NoteEditting==false?InkWell(
                                onTap: (){
                                  if(contact.Notes ==null)
                                    {
                                      contact.Notes =[];
                                      ContactNotes.add({
                                        "id":contact.info?.id,
                                        "Notes" : ""
                                      });

                                    }
                                  PhoneContactsCubit.get(context).AddNote();
                                },
                                child: Container(
                                  width:MediaQuery.of(context).size.width*0.50,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color:HexColor("#F5F5F5"),
                                  ),
                                  child: Center(child: Icon(Icons.add)),
                                ),
                              ):InkWell(
                                onTap: (){

                                  PhoneContactsCubit.get(context).AddNote();
                                },
                                child: Container(
                                  width:MediaQuery.of(context).size.width*0.50,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color:HexColor("#F5F5F5"),
                                  ),
                                  child: TextField(
                                    style: TextStyle(
                                      fontFamily: "OpenSans",
                                      fontSize: 12,
                                    ),
                                    controller: PhoneContactsCubit.get(context).NotesController,
                                    textAlign:TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    onSubmitted: (value){

                                      contact.Notes?[0]=value;
                                      PhoneContactsCubit.get(context).NotesController.clear();
                                      PhoneContactsCubit.get(context).AddNote();
                                      print(PhoneContactsCubit.get(context).NoteEditting);
                                      print("Notes : "+contact.Notes.toString());
                                    },
                                    decoration: InputDecoration(
                                      border:InputBorder.none,
                                    ),
                                  ),
                                ),
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
                                        ContactNotes.forEach((element) {
                                          if(element["id"] == contact.info?.id){
                                            PhoneContactsCubit.get(context).ContactIdExist =true;
                                          }
                                        });
                                        print("testing notes value : "+PhoneContactsCubit.get(context).ContactIdExist.toString());
                                        if(PhoneContactsCubit.get(context).ContactIdExist == false){
                                          ContactNotes.add({
                                            "id":contact.info?.id,
                                            "Notes" : ""
                                          });
                                        }

                                        ContactNotes.forEach((element) {
                                          if(element["id"] == contact.info?.id){

                                            element["Notes"]=contact.Notes.toString();
                                          }
                                        });
                                        CacheHelper.saveData(key: "Notes", value: json.encode(ContactNotes));
                                        print(ContactNotes);
                                        print(Notes);
                                        PhoneContactsCubit.get(context).ContactIdExist =false;
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
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Call logs"),
                              SizedBox(width: MediaQuery.of(context).size.width*0.70),
                              const Text("View all"),

                            ],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: MediaQuery.of(context).size.height*0.30,
                            child: BlocBuilder<PhoneLogsCubit,PhoneLogsStates>(
                              builder: (context,index)=>ListView.builder(
                                itemCount: PhoneLogsCubit.get(context).contactCalllog.length>5?5:PhoneLogsCubit.get(context).contactCalllog.length,
                                itemBuilder: (context,index) {

                                  return ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                    onTap: () {},
                                    subtitle: Transform.translate(
                                      offset: Offset(-5,0),
                                      child: Text(calculateDifference(PhoneLogsCubit.get(context).contactCalllog[index]["Date"]),style: TextStyle(
                                        fontFamily: "cairo",
                                        fontSize: 10,

                                      ),),
                                    ),
                                    title: Transform.translate(
                                      offset:Offset(-5,0),
                                      //TODO: Let the user at the initialization Screen Specify SIM1 & SIM2
                                      child: Row(
                                        children: [
                                          Image.asset(PhoneLogsCubit.get(context).contactCalllog.first["phoneAccountId"] == PhoneLogsCubit.get(context).contactCalllog[index]["phoneAccountId"]?"assets/Images/sim1.png" :"assets/Images/sim2.png",scale: 1.3),
                                          Text(
                                            " ${PhoneLogsCubit.get(context).contactCalllog[index]["number"].toString()}",
                                            style: Theme.of(context).textTheme.bodyText2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // //TODO:Something Retarining null at loggerAvatar(Only affected by Android 32)

                                  );

                                },),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
              ),
              PhoneContactsCubit.get(context).ContactEdit==false?Container():GestureDetector(
                onTap: (){
                  PhoneContactsCubit.get(context).ContactEdit= !PhoneContactsCubit.get(context).ContactEdit;
                  PhoneContactsCubit.get(context).Daillerinput();
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX:6,sigmaY: 6),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black12.withOpacity(0.50),
                  ),
                ),
              ),
              PhoneContactsCubit.get(context).ContactEdit==false?Container():Padding(
                padding: EdgeInsets.only(top:60.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(30),topEnd: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width*0.95,
                  height: MediaQuery.of(context).size.height*0.70,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(30),topEnd: Radius.circular(30)),
                          gradient: getColorGradient(contact.color),
                        ),
                        width: MediaQuery.of(context).size.width*0.95,
                        height: (MediaQuery.of(context).size.height*0.70)*0.56,
                        child: ContactAvatar(contact, 70),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top:((MediaQuery.of(context).size.height*0.70)*0.56)*0.15),
                        child: defaultButton(
                          isUpperCase: false,
                          width: MediaQuery.of(context).size.width*0.55,
                          onPressed: (){
                            PhoneContactsCubit.get(context).ContactPicturePicker(contact);
                          },
                          Title: "Select a Photo",
                          gradient: LinearGradient(
                            stops: [0.1,30],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              HexColor("#30006E"),
                              HexColor("#D337D8"),
                            ],
                            tileMode: TileMode.clamp,
                          ),
                          radius: 15,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: defaultButton(
                          isUpperCase: false,
                          width: MediaQuery.of(context).size.width*0.55,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SocialMediaPicker(contact)),);
                          },
                          Title: "From Social Media",
                          gradient: LinearGradient(
                            stops: [0.1,30],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              HexColor("#30006E"),
                              HexColor("#D337D8"),
                            ],
                            tileMode: TileMode.clamp,
                          ),
                          radius: 15,
                        ),
                      ),
                      Divider(
                        height: 50,
                        thickness: 1,
                      ),
                      Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width*0.55,
                        decoration: BoxDecoration(
                          border: Border.all(color: HexColor("#3700B3"),width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: MaterialButton(
                            onPressed: (){},
                            child: Text("Cancel")),
                      )

                    ]),
                  
                ),
              ),
            ],
          );
        }
    );
  }








  ListView DefaultAccountView(List<dynamic> NumbersInAccount, String? PrimeryNumber , PrimeryNormalizedNumber, List<dynamic> PhoneAccounts) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: NumbersInAccount.length,
        itemBuilder: (context,index){
          int SelectedIndex = PhoneContactsCubit.get(context).DefaultPhoneAccountIndex ;
          int count=0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ///Account Name and type
              if (index==0) Padding(
                padding: const EdgeInsets.only(left:25.0),
                child: DropdownButton(
                  itemHeight: 60,
                  value:PhoneContactsCubit.get(context).PhoneAccounts[PhoneContactsCubit.get(context).SelectedPhoneAccountIndex],
                  items: PhoneContactsCubit.get(context).PhoneAccounts.map((value){
                    count++;
                    return DropdownMenuItem(
                      value:value,
                      child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AccountIcon(contact.info?.accounts[count-1].type),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // SizedBox(height: 4,),
                                    AccountTitle(PhoneContactsCubit.get(context).PhoneAccounts[count-1]["AccountType"]),
                                    Text("${PhoneContactsCubit.get(context).PhoneAccounts[count-1]["AccountName"]}"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    );

                  }).toList(),
                  onChanged: (value) {
                    PhoneContactsCubit.get(context).SelectedPhoneAccountIndex = PhoneContactsCubit.get(context).PhoneAccounts.indexOf(value);
                    NumbersInAccount.clear();
                    contact.info?.phones.forEach((e) {
                      if(PhoneContactsCubit.get(context).PhoneAccounts[PhoneContactsCubit.get(context).SelectedPhoneAccountIndex]["AccountType"] == e.AccountType)
                      {
                        NumbersInAccount.add({
                          'label':e.label,
                          'number':e.number});
                      }
                      if(e.isPrimary ==true){
                        PrimeryNumber =  e.number;

                      }
                    });
                    PhoneContactsCubit.get(context).Daillerinput();
                  },

                ),
              ) else Container(),
              ///Defualt Phone Number
              index==0 &&PrimeryNumber!=null ?
              ListTile(
                leading: Icon(Icons.phone_rounded),
                title:Text("${PrimeryNumber}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color:HexColor('#01223B').withOpacity(0.11),
                    ),
                    child:IconButton(onPressed: (){
                      OpenWhatsapp("$PrimeryNormalizedNumber",PrimeryNumber?.replaceAll(" ", ""),context);


                    } , icon:Icon(Icons.sms_rounded, color: HexColor("#8E2479"),)),
                  ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color:HexColor('#01223B').withOpacity(0.11),
                      ),
                      child:IconButton(onPressed: (){
                        PhoneContactsCubit.get(context).isSearching = false;
                        PhoneContactsCubit.get(context).dialpadShowcontact();
                        FlutterPhoneDirectCaller.callNumber("${PrimeryNumber}");
                        NativeBridge.get(context).isRinging = false;

                      } , icon:FaIcon(FontAwesomeIcons.phoneAlt, color: HexColor("#28A7D6"),)),
                    ),],),
              ):Container(),
              //TODO:ADD more account types Competability(Phone numbers ex:Google - samsung - apple what so ever)
              contact.info?.accounts[0].type==contact.info?.accounts[0].type &&contact.info?.phones[index].number !=PrimeryNumber?
              ListTile(
                title:Text("${contact.info?.phones[index].number}"),
                leading: PrimeryNumber==null?Icon(Icons.phone_rounded):Text(""),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color:HexColor('#01223B').withOpacity(0.11),
                      ),
                      child:IconButton(onPressed: (){
                        OpenWhatsapp("${contact.info?.phones[index].normalizedNumber}","${contact.info?.phones[index].number.replaceAll(" ", "")}",context);
                      } , icon:Icon(Icons.sms_rounded, color: HexColor("#8E2479"),)),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color:HexColor('#01223B').withOpacity(0.11),
                      ),
                      child:IconButton(onPressed: (){
                        PhoneContactsCubit.get(context).isSearching = false;
                        PhoneContactsCubit.get(context).dialpadShowcontact();
                        FlutterPhoneDirectCaller.callNumber("${contact.info?.phones[index].number}");
                        NativeBridge.get(context).isRinging = false;
                      } , icon:FaIcon(FontAwesomeIcons.phoneAlt, color: HexColor("#28A7D6"),)),
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
        child:buildCircleAvatar(contact.info!.photoOrThumbnail,contact.info!.displayName[0]));
  }
}
CircleAvatar buildCircleAvatar(Uint8List? avatar, String initials) {
  if(avatar != null && avatar.isNotEmpty){

    return CircleAvatar(backgroundImage:MemoryImage(avatar));
  } else {
    return CircleAvatar(child: Text(initials.toString(),textScaleFactor: 1,
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

void OpenWhatsapp(NormalizedNumber,number,context) async{
  showModalBottomSheet(context: context,
      shape:const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(17),
            topLeft: Radius.circular(17)
        ),
      ),
      isScrollControlled: true,
      builder: (context)
      {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children:  [
            Padding(
                padding: EdgeInsets.only(top: 30 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Send" ,
                      style: TextStyle(
                          fontFamily:"OpenSans",
                          color: Colors.black,
                          fontSize: 13
                      ),),
                  ],
                )),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Divider(thickness: 1, indent: 25, endIndent: 25,),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
              child: Row(children: [

                if(PhoneContactsCubit.get(context).WhatsappContacts.contains(number))Column(
                  children: const [
                    CircleAvatar(
                        radius:22,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.whatsapp_outlined , color: Colors.white,size: 27,)),
                    Text("WhatsApp",
                        style: TextStyle(
                            fontFamily:"OpenSans",
                            color: Colors.black,
                            fontSize: 11
                        )
                    ),

                  ],
                ),
                const SizedBox(width: 15),
                Column(
                  children: [
                    ShaderMask(
                        shaderCallback:(bounds)=>RadialGradient(
                          center: Alignment.bottomLeft,
                          radius: 1.5,
                          colors: [
                            HexColor("#0695FF"),
                            HexColor("#A334FA"),
                            HexColor("#FF6968"),
                          ],
                          tileMode: TileMode.clamp,
                        ).createShader(bounds),
                        child: FaIcon(FontAwesomeIcons.facebookMessenger ,size: 40,color: Colors.white,)),
                    const SizedBox(height: 4,),
                    const Text("Messenger",
                        style: TextStyle(
                            fontFamily:"OpenSans",
                            color: Colors.black,
                            fontSize: 11
                        )
                    ),

                  ],
                ),
              ],),
            ),
            SizedBox(height: 40),
          ],);
      }
  );
  // if( await canLaunchUrl(Uri.https("wa.me", number))){
  //   await launchUrl(Uri.https("wa.me", number),mode: LaunchMode.externalApplication);
  // }
}
