
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/properties/phone.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../Themes/theme_config.dart';
import 'appcontacts.dart';
import 'contacts_screen.dart';

class ContactEditor extends StatelessWidget {
  ContactEditor(this.contact,this.NumbersInAccount);
  final AppContact contact;
  final List NumbersInAccount;
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  TextEditingController DisplayName = TextEditingController();
  TextEditingController PrefixName = TextEditingController();
  TextEditingController SufixName = TextEditingController();
  TextEditingController FirstName = TextEditingController();
  TextEditingController LastName = TextEditingController();
  TextEditingController MiddleName = TextEditingController();
  TextEditingController PhoneticName = TextEditingController();
  TextEditingController PhoneticFirstName = TextEditingController();
  TextEditingController PhoneticLastName = TextEditingController();
  TextEditingController PhoneticMiddleName = TextEditingController();
  TextEditingController Company = TextEditingController();
  TextEditingController JobTitle = TextEditingController();
  TextEditingController NickName = TextEditingController();

  String? testinglabel;
  String? testinglabe;
  @override
  Widget build(BuildContext context) {
    DisplayName.text = '${contact.info?.displayName}';
    PrefixName.text = '${contact.info?.name.prefix}';
    SufixName.text = '${contact.info?.name.suffix}';
    FirstName.text = "${contact.info?.name.first}";
    LastName.text = "${contact.info?.name.last}";
    MiddleName.text = "${contact.info?.name.middle}";
    PhoneticName.text = '${contact.info?.name.firstPhonetic}';
    PhoneticFirstName.text = "${contact.info?.name.firstPhonetic}";
    PhoneticMiddleName.text = "${contact.info?.name.middlePhonetic}";
    PhoneticLastName.text = "${contact.info?.name.lastPhonetic}";
    Company.text = contact.info!.organizations.isNotEmpty?'${contact.info?.organizations.single.company}':"";
    JobTitle.text = contact.info!.organizations.isNotEmpty?'${contact.info?.organizations.single.title}':"";
    PhoneContactsCubit.get(context).WebsiteController.text = contact.info!.websites.isNotEmpty?'${contact.info?.websites.single.url}':"";
    NickName.text = '${contact.info?.name.nickname}';
    PhoneContactsCubit.get(context).NoteController.text = contact.info!.notes.isNotEmpty?'${contact.info?.notes.single.note}':"";
    PhoneContactsCubit.get(context).TextFormFieldInitialize(NumbersInAccount , contact);

    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        leading: TextButton(onPressed: (){
          PhoneContactsCubit.get(context).ContactCancel(contact,context);
          }, child: const Text("Cancel"),),
        title: const Center(child: Text("edit contact",style: TextStyle(color: Colors.black,fontSize: 15),)),
        actions: [
          BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
            builder:(context,states)=> TextButton(
                onPressed: PhoneContactsCubit.get(context).DetailsIsChanged==false?(){

                contact.info?.displayName != DisplayName.text?contact.info?.displayName = DisplayName.text:null;
                contact.info?.name.prefix != PrefixName.text? contact.info?.name.prefix = PrefixName.text:null;
                contact.info?.name.suffix != SufixName.text?contact.info?.name.suffix = SufixName.text:null;
                contact.info?.name.first != FirstName.text?contact.info?.name.first = FirstName.text:null;
                contact.info?.name.last != LastName.text?contact.info?.name.last = LastName.text:null;
                contact.info?.name.middle != MiddleName.text?contact.info?.name.middle = MiddleName.text:null;
                contact.info?.name.firstPhonetic != PhoneticName.text?contact.info?.name.firstPhonetic = PhoneticName.text:null;
                contact.info?.name.firstPhonetic != PhoneticFirstName.text?contact.info?.name.firstPhonetic = PhoneticFirstName.text:null;
                contact.info?.name.middlePhonetic != PhoneticMiddleName.text?contact.info?.name.middlePhonetic = PhoneticMiddleName.text:null;
                contact.info?.name.lastPhonetic != PhoneticLastName.text?contact.info?.name.lastPhonetic = PhoneticLastName.text:null;
              // if(contact.info?.organizations.first.company != Company.text ||contact.info?.organizations.first.title != JobTitle.text)
              // {
              //   contact.info?.organizations.clear();
              //   contact.info?.organizations.add(Organization(company: Company.text.isNotEmpty?Company.text:"", title: JobTitle.text.isNotEmpty ?JobTitle.text:""));
              // }
                contact.info?.name.nickname != NickName.text?contact.info?.name.nickname = NickName.text:null;
              PhoneContactsCubit.get(context).ContactUpdate(contact,context);
            }:null,

                child: Text("Done")
            ),
          ),
        ],
      ),
      body:SingleChildScrollView(
        child: BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
          builder:(context,state) {
            int count =0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ContactAvatar(contact, 90),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PhoneContactsCubit.get(context).AccountIcon(PhoneContactsCubit.get(context).DefaultPhoneAccounts[PhoneContactsCubit.get(context).DefaultPhoneAccountIndex]["AccountType"]),
                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(height: 4,),
                                PhoneContactsCubit.get(context).AccountTitle(PhoneContactsCubit.get(context).DefaultPhoneAccounts[PhoneContactsCubit.get(context).DefaultPhoneAccountIndex]["AccountType"]),
                                SizedBox(
                                  width: 100,
                                  child: Text("${PhoneContactsCubit.get(context).DefaultPhoneAccounts[PhoneContactsCubit.get(context).DefaultPhoneAccountIndex]["AccountName"]}",overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.52,
                        child: ContactFormFieldHeader(context,
                            contact.info!.name.nickname.isNotEmpty?contact.info?.name.nickname:null,
                            NickName,FaIcon(FontAwesomeIcons.userNinja,color: ContactFormIconColor(),size: 16,),"Nickname",false),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width*0.90,
                      child: ContactFormField(context,
                          PhoneContactsCubit.get(context).DNtoggler == true?
                          contact.info!.name.prefix.isNotEmpty?contact.info?.name.prefix:null:
                          contact.info!.displayName.isNotEmpty?contact.info?.displayName:null,
                          PhoneContactsCubit.get(context).DNtoggler == true?PrefixName:DisplayName,
                          Icon(Icons.person,color: ContactFormIconColor(),),PhoneContactsCubit.get(context).DNtoggler == true?"Prefix":"Display name",true)),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0,left:10),
                    child: IconButton(
                      splashRadius: 15,
                        constraints: const BoxConstraints(
                          maxWidth: 10,
                        ),
                        padding:EdgeInsets.zero,onPressed: (){
                      PhoneContactsCubit.get(context).DisplayNameToggle();
                    }, icon: PhoneContactsCubit.get(context).DNtoggler == true?Transform.translate(
                        offset: Offset(-7,0),
                        child: Icon(Icons.arrow_drop_up)):
                    Transform.translate(
                        offset: Offset(-8,0),
                        child: Icon(Icons.arrow_drop_down)),
                    ),
                  )
                ],
              ),
              PhoneContactsCubit.get(context).DNtoggler==true?
              Padding(
                padding: const EdgeInsets.only(left:5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  ContactFormField(context,contact.info!.name.first.isNotEmpty?contact.info?.name.first:null,
                      FirstName,null,"First name",false),
                  ContactFormField(context,contact.info!.name.middle.isNotEmpty?contact.info?.name.middle:null,
                      MiddleName,null,"Middle name",false),
                  ContactFormField(context,contact.info!.name.last.isNotEmpty?contact.info?.name.last:null,
                      LastName,null,"Last name",false),
                  ContactFormField(context,contact.info!.name.suffix.isNotEmpty?contact.info?.name.suffix:null,
                      SufixName,null,"Suffix",false),
                ]),
              ):Container(),
              Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width*0.90,
                      child: ContactFormField(context,
                          PhoneContactsCubit.get(context).DNtoggler == true?
                          contact.info!.name.lastPhonetic.isNotEmpty?contact.info?.name.lastPhonetic:null:
                          contact.info!.name.firstPhonetic.isNotEmpty?contact.info?.name.firstPhonetic:null,
                          PhoneticName,null,PhoneContactsCubit.get(context).PNtoggler==true?"Phonetic last name":"Phonetic name",true)),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0,left:10),
                    child: IconButton(
                      splashRadius: 15,
                      constraints: const BoxConstraints(
                        maxWidth: 10,
                      ),
                      padding:EdgeInsets.zero,onPressed: (){
                      PhoneContactsCubit.get(context).PhoneticNameToggle();
                    }, icon: PhoneContactsCubit.get(context).PNtoggler == true?Transform.translate(
                        offset: Offset(-7,0),
                        child: Icon(Icons.arrow_drop_up)):
                    Transform.translate(
                        offset: Offset(-8,0),
                        child: Icon(Icons.arrow_drop_down)),
                    ),
                  )
                ],
              ),
              PhoneContactsCubit.get(context).PNtoggler==true?
              Padding(
                padding: const EdgeInsets.only(left:5.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ContactFormField(context,
                          contact.info!.name.middlePhonetic.isNotEmpty?contact.info?.name.middlePhonetic:null,
                          PhoneticMiddleName,null,"Phonetic middle name",false),
                      ContactFormField(context,
                          contact.info!.name.firstPhonetic.isNotEmpty?contact.info?.name.firstPhonetic:null,
                          PhoneticFirstName,null,"Phonetic first name",false),
                    ]),
              ):Container(),



              SizedBox(
                height: (PhoneContactsCubit.get(context).PhoneNumberController.length)*71,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: PhoneContactsCubit.get(context).PhoneNumberController.length,
                    itemBuilder: (context,index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PhoneTextForm(index,context,contact),
                      );
                    }),
              ),
              Container(
                height: (PhoneContactsCubit.get(context).EmailAddressController.length)*71,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: PhoneContactsCubit.get(context).EmailAddressController.length,
                    itemBuilder: (context,index)=>Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: EmailAddressTextForm(index,context,),
                    )),
              ),
              Container(
                height: (PhoneContactsCubit.get(context).AddressController.length)*71,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: PhoneContactsCubit.get(context).AddressController.length,
                    itemBuilder: (context,index)=>Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AddressTextForm(index,context,),
                    )),
              ),
              Container(
                height: (PhoneContactsCubit.get(context).EventController.length)*71,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: PhoneContactsCubit.get(context).EventController.length,
                    itemBuilder: (context,index)=>Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: EventTextForm(index,context,),
                    )),
              ),
              Container(
                height: (PhoneContactsCubit.get(context).ChatController.length)*71,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: PhoneContactsCubit.get(context).ChatController.length,
                    itemBuilder: (context,index)=>Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChatTextForm(index,context,),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  children: [
                    ContactFormField(context,contact.info!.organizations.isNotEmpty?contact.info?.organizations.first.company:null,Company,Icon(Icons.business,color:ContactFormIconColor(),size:20),"Company",false ),
                    SizedBox(height: 15,),
                    ContactFormField(context,contact.info!.organizations.isNotEmpty?contact.info?.organizations.first.company:null,JobTitle,Icon(Icons.work,color:ContactFormIconColor(),size: 20,),"Job title",false),
                  ],
                ),
              ),
              Container(
                height: 65,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (context,index)=>Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: ContactFormField(context,
                            contact.info!.websites.isNotEmpty?contact.info?.websites.first.url:null,
                            PhoneContactsCubit.get(context).WebsiteController,Icon(Icons.language,color: ContactFormIconColor(),),"Website",false))),
              ),
              Container(
                height: 65,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (context,index)=>Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: ContactFormField(context,
                            contact.info!.notes.isNotEmpty?contact.info?.notes.first.note:null,
                            PhoneContactsCubit.get(context).NoteController,Icon(Icons.note,color: ContactFormIconColor(),),"Notes",false))),
              ),

            ],
          );
          },
        ),
      ),
    );
  }



  TextFormField ContactFormFieldHeader(context,ValueToCompare,TextEditingController controller,PreIcon , LabelText , bool?DropDown ) {
    return TextFormField(
     onChanged: (value){
       if(value == ValueToCompare)
         {
           PhoneContactsCubit.get(context).DetailsIsChanged=true;
         }
       else
         {
           if(value.isEmpty)
             {
               PhoneContactsCubit.get(context).DetailsIsChanged=true;
             }
           else
           {
            PhoneContactsCubit.get(context).DetailsIsChanged = false;
          }
        }
       print(PhoneContactsCubit.get(context).DetailsIsChanged);
       PhoneContactsCubit.get(context).SideMenuUpdater();

     },
      style: ContactFormMainTextStyle(),
      controller: controller,
      decoration: InputDecoration(
        labelStyle: ContactFormLabelTextStyle(),
        icon: PreIcon,
        suffixIcon: IconButton(onPressed: (){},icon: const Icon(Icons.cancel,size: 20,)),
        labelText: LabelText,
        fillColor: ContactFormfillColor(),
          filled: true,
      ),
    );
  }




  Container EmailAddressTextForm(index,context,) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      height: 55,
      child: Row(
        children: [
          const SizedBox(width: 10),
          index==0?Icon(Icons.contact_mail,color:PhoneTextFormIconColor()):const SizedBox(width: 24),
          const SizedBox(width: 8),
          ///DropDownMenu (Label)
          Container(
            alignment: AlignmentDirectional.center,
            width: 78,
            child: DropdownButtonFormField(
              decoration:const InputDecoration(
                enabledBorder:InputBorder.none ,
              ),
              style: PhoneTextFormDropdownTextStyle(),
              value: PhoneContactsCubit.get(context).EmailSideMenu.first,
              alignment: AlignmentDirectional.center,
              onChanged: (label) {
                PhoneContactsCubit.get(context).EmailSideMenuController[index]=label as EmailLabel;
              },
              items: PhoneContactsCubit.get(context).EmailSideMenu.map((value) {
                return DropdownMenuItem(
                    alignment: AlignmentDirectional.center,
                    value:value,
                    child: ForumLabels(value));
              }).toList(),
            ),
          ),
          /// Divider bettween DropDownMenu and textField
          Container(
            width: 1,
            height: 20,
            color: Colors.black,
          ),
          /// TextField
          Padding(
          padding: EdgeInsets.only(right:15, top: 8 , bottom: 8),
          child: Container(
            width: MediaQuery.of(context).size.width-170,
            child: TextFormField(
              style: PhoneTextFormMainTextStyle(),
              onChanged: (value){
                if(PhoneContactsCubit.get(context).EmailAddressController.last.text.isNotEmpty)
                {
                  PhoneContactsCubit.get(context).EmailAddressAdd(true);
                }
                if(value.isEmpty&&PhoneContactsCubit.get(context).EmailAddressController.length >1)
                { PhoneContactsCubit.get(context).EmailAddressAdd(false);}

                if(PhoneContactsCubit.get(context).EmailAddressController[index].text.isEmpty || contact.info!.emails.isEmpty)
                {
                  PhoneContactsCubit.get(context).DetailsIsChanged=true;
                  PhoneContactsCubit.get(context).EmailAddressUpdate=false;
                }
                else
                {
                  if(PhoneContactsCubit.get(context).EmailAddressController[index].text == contact.info?.emails[index].address)
                  {
                    PhoneContactsCubit.get(context).DetailsIsChanged=true;
                    PhoneContactsCubit.get(context).EmailAddressUpdate=false;
                  }
                  else
                  {
                    PhoneContactsCubit.get(context).DetailsIsChanged = false;
                    PhoneContactsCubit.get(context).EmailAddressUpdate = true;
                  }
                }
                PhoneContactsCubit.get(context).SideMenuUpdater();
              },
              controller: PhoneContactsCubit.get(context).EmailAddressController[index],
              decoration: InputDecoration(
                labelStyle: PhoneTextFormLabelTextStyle(),
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left:5),
                suffixIcon: IconButton(onPressed: (){
                  PhoneContactsCubit.get(context).EmailAddressController.removeAt(index);
                  PhoneContactsCubit.get(context).SideMenuUpdater();
                },icon: Icon(Icons.remove_circle_outline),splashRadius: 3,color: Colors.red,iconSize: 21,),
                labelText: 'Email',
                fillColor: Colors.grey[200],
                  filled: false,
              ),
            ),
          ),
        ),

        ]
      ),
    );
  }

  Container AddressTextForm(index,context,) {
    return Container(
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
    ),
      height: 55,

      child: Row(
        children: [
          const SizedBox(width: 10),
          index==0?Icon(Icons.place,color:PhoneTextFormIconColor()):const SizedBox(width: 24),
          const SizedBox(width: 8),
          ///DropDownMenu (Label)
          Container(
            width: 78,
            child: DropdownButtonFormField(
              style: PhoneTextFormDropdownTextStyle(),
              decoration:const InputDecoration(
                enabledBorder:InputBorder.none ,
              ),
              value: PhoneContactsCubit.get(context).EmailSideMenu.first,
              alignment: AlignmentDirectional.center,
              onChanged: (label) {
                PhoneContactsCubit.get(context).AddressSideMenuController[index]=label as AddressLabel;
              },
              items: PhoneContactsCubit.get(context).EmailSideMenu.map((value) {
                return DropdownMenuItem(
                    alignment: AlignmentDirectional.center,
                    value:value,
                    child: ForumLabels(value));
              }).toList(),
            ),
          ),
          /// Divider bettween DropDownMenu and textField
          Container(
            width: 1,
            height: 20,
            color: Colors.black,
          ),
          /// TextField
          Padding(
          padding: EdgeInsets.only(right:15, top: 8 , bottom: 8),
          child: Container(
            width: MediaQuery.of(context).size.width-170,
            child: TextFormField(
              style: PhoneTextFormMainTextStyle(),
              onChanged: (value){
                if(PhoneContactsCubit.get(context).AddressController.last.text.isNotEmpty)
                {
                  PhoneContactsCubit.get(context).AddressAdd(true);
                }
                if(value.isEmpty&&PhoneContactsCubit.get(context).AddressController.length >1) { PhoneContactsCubit.get(context).AddressAdd(false);}

                if(PhoneContactsCubit.get(context).AddressController[index].text.isEmpty || contact.info!.addresses.isEmpty)
                {
                  PhoneContactsCubit.get(context).DetailsIsChanged=true;
                  PhoneContactsCubit.get(context).AddressUpdate=false;
                }
                else
                {
                  if(PhoneContactsCubit.get(context).AddressController[index].text == contact.info?.addresses[index].address)
                  {
                    PhoneContactsCubit.get(context).DetailsIsChanged=true;
                    PhoneContactsCubit.get(context).AddressUpdate=false;
                  }
                  else
                  {
                    PhoneContactsCubit.get(context).DetailsIsChanged = false;
                    PhoneContactsCubit.get(context).AddressUpdate = true;
                  }
                }
                PhoneContactsCubit.get(context).SideMenuUpdater();
              },
              controller: PhoneContactsCubit.get(context).AddressController[index],
              decoration: InputDecoration(
                labelStyle: PhoneTextFormLabelTextStyle(),
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left:5),
                suffixIcon: IconButton(onPressed: (){
                  PhoneContactsCubit.get(context).AddressController.removeAt(index);
                  PhoneContactsCubit.get(context).SideMenuUpdater();
                },icon: Icon(Icons.remove_circle_outline),splashRadius: 3,color: Colors.red,iconSize: 21,),
                labelText: "Address",
                fillColor: Colors.grey[200],
                  filled: false,
              ),
            ),
          ),
        ),

        ]
      ),
    );
  }

  Container EventTextForm(index,context,) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      height: 55,
      child: Row(
        children: [
          const SizedBox(width: 10),
          index==0?Icon(Icons.event,color:PhoneTextFormIconColor()):SizedBox(width: 24),
          const SizedBox(width: 8),
          ///DropDownMenu (Label)
          Container(
            width: 85,
            child: DropdownButtonFormField(
              style: PhoneTextFormDropdownTextStyle(),
              decoration:const InputDecoration(
                enabledBorder:InputBorder.none ,
              ),
              value: PhoneContactsCubit.get(context).EventSideMenu.first,
              alignment: AlignmentDirectional.center,
              onChanged: (label) {
                PhoneContactsCubit.get(context).EventSideMenuController[index]=label as EventLabel;
              },
              items: PhoneContactsCubit.get(context).EventSideMenu.map((value) {
                return DropdownMenuItem(
                    alignment: AlignmentDirectional.center,
                    value:value,
                    child: ForumLabels(value));
              }).toList(),
            ),
          ),
          /// Divider bettween DropDownMenu and textField
          Container(
            width: 1,
            height: 20,
            color: Colors.black,
          ),
          /// TextField
          Padding(
          padding: EdgeInsets.only(right:15, top: 8 , bottom: 8),
          child: Container(
            width: MediaQuery.of(context).size.width-170,
            child:
            TextFormField(
              readOnly: true,
              style: PhoneTextFormMainTextStyle(),
              onTap: (){
                showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime((DateTime.now().year)+10,1,1),).then((value){
                  PhoneContactsCubit.get(context).EventController[index].text = DateFormat.yMMMd().format(value!);
                  PhoneContactsCubit.get(context).EventPickerValue=value;

                }).then((value) {

                  if(PhoneContactsCubit.get(context).EventController.last.text.isNotEmpty)
                  {
                    print("Event tester");
                    PhoneContactsCubit.get(context).EventAdd(true);
                  } if(PhoneContactsCubit.get(context).EventController[index].text.isEmpty&&PhoneContactsCubit.get(context).EventController.length >=1) { PhoneContactsCubit.get(context).EventAdd(false);}


                  if(PhoneContactsCubit.get(context).AddressController[index].text.isEmpty || contact.info!.events.isEmpty)
                  {
                    PhoneContactsCubit.get(context).DetailsIsChanged=true;
                    PhoneContactsCubit.get(context).EventsUpdate=false;
                    print("Event tester");
                  }
                  else
                  {
                    if("${PhoneContactsCubit.get(context).EventPickerValue.month}-${PhoneContactsCubit.get(context).EventPickerValue.day}-${PhoneContactsCubit.get(context).EventPickerValue.year}" == "${contact.info?.events[index].month}-${contact.info?.events[index].day}-${contact.info?.events[index].year}")
                    {
                      print("Event tester");
                      PhoneContactsCubit.get(context).DetailsIsChanged=true;
                      PhoneContactsCubit.get(context).EventsUpdate=false;
                    }
                    else
                    {
                      print("Event tester");
                      PhoneContactsCubit.get(context).DetailsIsChanged = false;
                      PhoneContactsCubit.get(context).EventsUpdate = true;
                    }
                  }

                  PhoneContactsCubit.get(context).SideMenuUpdater();
                });
              },
              controller: PhoneContactsCubit.get(context).EventController[index],
              decoration: InputDecoration(
                labelStyle: PhoneTextFormLabelTextStyle(),
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left:5),
                suffixIcon: IconButton(onPressed: (){
                  PhoneContactsCubit.get(context).EventController.removeAt(index);
                  PhoneContactsCubit.get(context).SideMenuUpdater();
                },icon: Icon(Icons.remove_circle_outline),splashRadius: 3,color: Colors.red,iconSize: 21,),
                labelText: "Date",
                fillColor: Colors.grey[200],
                  filled: false,
              ),
            ),
          ),
        ),

        ]
      ),
    );
  }

  Container ChatTextForm(index,context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      height: 55,
      child: Row(
        children: [
          const SizedBox(width: 10),
          index==0?Icon(Icons.forum,color:PhoneTextFormIconColor()):const SizedBox(width: 24),
          const SizedBox(width: 8),
          ///DropDownMenu (Label)
          Container(
            width: 78,
            child: DropdownButtonFormField(
              value: PhoneContactsCubit.get(context).ChatSideMenu.first,
              decoration:const InputDecoration(
                enabledBorder:InputBorder.none ,
              ),
              alignment: AlignmentDirectional.center,
              onChanged: (label) {
                if(label.toString().contains('Phone')){
                index == index?PhoneContactsCubit.get(context).ChatSideMenuController[index]=label as SocialMediaLabel:null;
                }
              },
              items: PhoneContactsCubit.get(context).ChatSideMenu.map((value) {
                return DropdownMenuItem(
                    alignment: AlignmentDirectional.center,
                    value:value,
                    child: ForumLabels(value));
              }).toList(),
            ),
          ),
          /// Divider bettween DropDownMenu and textField
          Container(
            width: 1,
            height: 20,
            color: Colors.black,
          ),
          /// TextField
          Padding(
          padding: EdgeInsets.only(right:15, top: 8 , bottom: 8),
          child: Container(
            width: MediaQuery.of(context).size.width-170,
            child: TextFormField(
              onChanged: (value){
                if(PhoneContactsCubit.get(context).ChatController.last.text.isNotEmpty) {PhoneContactsCubit.get(context).ChatUserNameAdd(true);}
                if(value.isEmpty&&PhoneContactsCubit.get(context).ChatController.length >1) { PhoneContactsCubit.get(context).ChatUserNameAdd(false);}

                if(PhoneContactsCubit.get(context).ChatController[index].text.isEmpty || contact.info!.socialMedias.isEmpty)
                {
                  PhoneContactsCubit.get(context).DetailsIsChanged=true;
                  PhoneContactsCubit.get(context).ChatUpdate=false;
                }
                else
                {
                  if(PhoneContactsCubit.get(context).ChatController[index].text == contact.info?.socialMedias[index].userName)
                  {
                    PhoneContactsCubit.get(context).DetailsIsChanged=true;
                    PhoneContactsCubit.get(context).ChatUpdate=false;
                  }
                  else
                  {
                    PhoneContactsCubit.get(context).DetailsIsChanged = false;
                    PhoneContactsCubit.get(context).ChatUpdate = true;
                  }
                }
                PhoneContactsCubit.get(context).SideMenuUpdater();
              },
              controller: PhoneContactsCubit.get(context).ChatController[index],
              decoration: InputDecoration(
                labelStyle: PhoneTextFormLabelTextStyle(),
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left:5),
                suffixIcon: IconButton(onPressed: (){
                  PhoneContactsCubit.get(context).ChatController.removeAt(index);
                  PhoneContactsCubit.get(context).SideMenuUpdater();
                },icon: Icon(Icons.remove_circle_outline),splashRadius: 3,color: Colors.red,iconSize: 21,),
                labelText: "IM",
                fillColor: Colors.grey[200],
                  filled: false,
              ),
            ),
          ),
        ),

        ]
      ),
    );
  }

  Padding SingleFormField(controller,context,PreIcon,LabelText) {
    return Padding(
        padding: EdgeInsets.only(right:30, top: 8 , bottom: 8,left:15),
        child: Container(
          width: MediaQuery.of(context).size.width-170,
          child: TextFormField(
            onChanged: (value){
              if(PhoneContactsCubit.get(context).PhoneNumberController.last.text.isNotEmpty)
              {
                ///can't be equal to 1 to make it empty it will go back to 1 change the logic
                PhoneContactsCubit.get(context).PhoneNumberadd(true);
              }
              if(value.isEmpty &&PhoneContactsCubit.get(context).PhoneNumberController.length >1 )
               {
                PhoneContactsCubit.get(context).PhoneNumberadd(false);
              }
            },
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left:5),
              icon: PreIcon,
              suffixIcon: IconButton(onPressed: (){},icon: Icon(Icons.cancel)),
              labelText: LabelText,
              fillColor: Colors.grey[200],
                filled: true,
            ),
          ),
        ),
      );
  }




}
Padding ContactFormField(context,ValueToCompare,controller,PreIcon , LabelText , bool?DropDown) {
  return Padding(
    padding: EdgeInsets.only(right: DropDown==true?0.0:32,left: PreIcon !=null?15.0:55 , top: 8 , bottom: 8),
    child: TextFormField(
      onChanged: (value){
        if(value == ValueToCompare)
        {
          PhoneContactsCubit.get(context).DetailsIsChanged=true;
        }
        else
        {
          if(value.isEmpty)
          {
            PhoneContactsCubit.get(context).DetailsIsChanged=true;
          }
          else
          {
            PhoneContactsCubit.get(context).DetailsIsChanged = false;
          }
        }
        print(PhoneContactsCubit.get(context).DetailsIsChanged);
        PhoneContactsCubit.get(context).SideMenuUpdater();

      },
      style: ContactFormMainTextStyle(),
      controller: controller,
      decoration: InputDecoration(
        labelStyle: ContactFormLabelTextStyle(),
        icon: PreIcon,
        suffixIcon: IconButton(onPressed: (){
          controller.clear();
          PhoneContactsCubit.get(context).SideMenuUpdater();
        },icon: const Icon(Icons.cancel,size: 20,)),
        labelText: LabelText,
        fillColor: ContactFormfillColor(),
        filled: true,
      ),
    ),
  );
}

Container PhoneTextForm(index,context,contact) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
    ),
    height: 55,
    child: Row(
        children: [
          const SizedBox(width: 10),
          index==0?Icon(Icons.call,color:PhoneTextFormIconColor()):const SizedBox(width: 24),
          const SizedBox(width: 8),
          ///DropDownMenu (Label)
          Container(
            width: 78,
            child: DropdownButtonFormField(
              style: PhoneTextFormDropdownTextStyle(),
              decoration:const InputDecoration(
                enabledBorder:InputBorder.none ,
              ),
              // icon: preIcon,
              value: PhoneContactsCubit.get(context).phoneSideMenu.first,
              alignment: AlignmentDirectional.center,
              onChanged: (label) {
                PhoneContactsCubit.get(context).PhoneSideMenuController[index]=label as PhoneLabel;
              },
              items: PhoneContactsCubit.get(context).phoneSideMenu.map((value) {
                return DropdownMenuItem(
                    alignment: AlignmentDirectional.center,
                    value:value,
                    child: ForumLabels(value));
              }).toList(),
            ),
          ),
          /// Divider bettween DropDownMenu and textField
          Container(
            width: 1,
            height: 20,
            color: Colors.black,
          ),
          /// TextField
          Padding(
            padding: EdgeInsets.only(right:12, top: 8 , bottom: 8),
            child: Container(
              width: MediaQuery.of(context).size.width-170,
              child: TextFormField(
                style: PhoneTextFormMainTextStyle(),
                onChanged: (value){
                  if(PhoneContactsCubit.get(context).PhoneNumberController.last.text.isNotEmpty)
                  {
                    PhoneContactsCubit.get(context).PhoneNumberadd(true);
                  }
                  if(value.isEmpty&&PhoneContactsCubit.get(context).PhoneNumberController.length >1)
                  {
                    PhoneContactsCubit.get(context).PhoneNumberadd(false);
                  }

                  if(contact !=null){
                    if(PhoneContactsCubit.get(context).PhoneNumberController[index].text.isEmpty || contact.info!.phones.isEmpty)
                    {
                      PhoneContactsCubit.get(context).DetailsIsChanged=true;
                      PhoneContactsCubit.get(context).PhoneNumberUpdate=false;
                    }
                    else
                    {

                      if(PhoneContactsCubit.get(context).PhoneNumberController[index].text == contact.info?.phones[index].number)
                      {
                        PhoneContactsCubit.get(context).DetailsIsChanged=true;
                        PhoneContactsCubit.get(context).PhoneNumberUpdate=false;

                      }
                      else
                      {
                        PhoneContactsCubit.get(context).DetailsIsChanged = false;
                        PhoneContactsCubit.get(context).PhoneNumberUpdate = true;
                      }
                    }
                  }

                  PhoneContactsCubit.get(context).SideMenuUpdater();
                },
                controller: PhoneContactsCubit.get(context).PhoneNumberController[index],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelStyle: PhoneTextFormLabelTextStyle(),
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left:5),
                  suffixIcon: IconButton(onPressed: (){
                    PhoneContactsCubit.get(context).PhoneNumberController.removeAt(index);
                    PhoneContactsCubit.get(context).SideMenuUpdater();
                    print("Remove pressed");
                  },icon: Icon(Icons.remove_circle_outline),splashRadius: 3,color: Colors.red,iconSize: 21,),
                  labelText: "Number",
                  fillColor: Colors.grey[200],
                  filled: false,
                ),
              ),
            ),
          ),

        ]
    ),
  );
}
Text ForumLabels(value) {
  if(value == PhoneLabel.mobile) {
    return Text('mobile');
  }
  if(value == PhoneLabel.home || value == EmailLabel.home) {
    return Text('Home');
  }
  if(value == PhoneLabel.work || value == EmailLabel.work) {
    return Text('Work');
  }
  if(value == PhoneLabel.faxWork) {
    return Text('Fax Work');
  }
  if(value == PhoneLabel.faxHome) {
    return Text('Fax Home');
  }
  if(value == PhoneLabel.pager) {
    return Text('Pager');
  }
  if(value == PhoneLabel.other || value == EmailLabel.other || value == EventLabel.other) {
    return Text('Other');
  }
  if(value == PhoneLabel.custom || value == EmailLabel.custom || value == SocialMediaLabel.custom || value == EventLabel.custom) {
    return Text('Custom');
  }
  if(value == SocialMediaLabel.qqchat) {
    return Text('QQ');
  }
  if(value == SocialMediaLabel.skype) {
    return Text('Skype');
  }
  if(value == SocialMediaLabel.yahoo) {
    return Text('Yahoo');
  }
  if(value == SocialMediaLabel.aim) {
    return Text('AIM');
  }
  if(value == SocialMediaLabel.icq) {
    return Text('ICQ');
  }
  if(value == SocialMediaLabel.facebook) {
    return Text('facebook');
  }
  if(value == SocialMediaLabel.discord) {
    return Text('Discord');
  }

  if(value == EventLabel.birthday) {
    return Text('BirthDay');
  }

  if(value == EventLabel.anniversary) {
    return Text('Anniversary');
  }
  return Text('other');
}