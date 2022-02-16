
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

import 'appcontacts.dart';
import 'contacts_screen.dart';

class ContactEditor extends StatelessWidget {
  ContactEditor(this.contact,this.NumbersInAccount);
  final AppContact contact;
  final List NumbersInAccount;

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
  TextEditingController Website = TextEditingController();
  TextEditingController Notes = TextEditingController();
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
    Website.text = contact.info!.websites.isNotEmpty?'${contact.info?.websites.single.url}':"";
    NickName.text = '${contact.info?.name.nickname}';
    Notes.text = contact.info!.notes.isNotEmpty?'${contact.info?.notes.single.note}':"";

    PhoneContactsCubit.get(context).TextFormFieldInitialize(NumbersInAccount , contact);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.close),onPressed: (){
          PhoneContactsCubit.get(context).ContactCancel(contact,context);
          },),
        title: Center(child: Text("Edit Contact",style: TextStyle(color: Colors.black,fontSize: 15),)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 19.0),
            child:IconButton(onPressed: (){
              PhoneContactsCubit.get(context).ContactUpdate(contact,context);
            }, icon:Icon(Icons.check),)
          ),
        ],
      ),
      body:SingleChildScrollView(
        child: BlocBuilder<PhoneContactsCubit,PhoneContactStates>(
          builder:(context,state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ContactAvatar(contact, 70),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width*0.90,
                      child: ContactFormField(PhoneContactsCubit.get(context).DNtoggler == true?PrefixName:DisplayName,Icon(Icons.person),PhoneContactsCubit.get(context).DNtoggler == true?"Prefix":"Display name",true)),
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
                  ContactFormField(FirstName,null,"First name",false),
                  ContactFormField(MiddleName,null,"Middle name",false),
                  ContactFormField(LastName,null,"Last name",false),
                  ContactFormField(SufixName,null,"Suffix",false),
                ]),
              ):Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width*0.90,
                      child: ContactFormField(PhoneticName,null,PhoneContactsCubit.get(context).PNtoggler==true?"Phonetic last name":"Phonetic name",true)),
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
                      ContactFormField(PhoneticMiddleName,null,"Phonetic middle name",false),
                      ContactFormField(PhoneticFirstName,null,"Phonetic first name",false),
                    ]),
              ):Container(),

              Padding(
                padding: const EdgeInsets.only(left:5.0),
                child: Column(
                  children: [
                    ContactFormField(Company,Icon(Icons.business),"Company",false),
                    ContactFormField(JobTitle,Icon(Icons.work),"Job title",false),
                  ],
                ),
              ),

              Container(
                height: (PhoneContactsCubit.get(context).PhoneNumberController.length)*65,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: PhoneContactsCubit.get(context).PhoneNumberController.length,
                    itemBuilder: (context,index) {
                      return PhoneTextForm(index,context);
                    }),
              ),
              Container(
                height: (PhoneContactsCubit.get(context).EmailAddressController.length)*65,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: PhoneContactsCubit.get(context).EmailAddressController.length,
                    itemBuilder: (context,index)=>EmailAddressTextForm(index,context,)),
              ),
              Container(
                height: (PhoneContactsCubit.get(context).AddressController.length)*65,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: PhoneContactsCubit.get(context).AddressController.length,
                    itemBuilder: (context,index)=>AddressTextForm(index,context,)),
              ),
              Container(
                height: (PhoneContactsCubit.get(context).EventController.length)*65,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: PhoneContactsCubit.get(context).EventController.length,
                    itemBuilder: (context,index)=>EventTextForm(index,context,)),
              ),
              // Container(
              //
              //   height: 65,
              //   child: ListView.builder(
              //     physics: NeverScrollableScrollPhysics(),
              //       itemCount: 1,
              //       itemBuilder: (context,index)=>PhoneFormField(index,PhoneContactsCubit.get(context).PhoneNumberController[index],context,null,"Related Persons",PhoneContactsCubit.get(context).RelatedSideMenu,Icon(
              //         Icons.account_box_sharp,
              //       ),)),
              // ),
              Container(
                height: (PhoneContactsCubit.get(context).ChatController.length)*65,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: PhoneContactsCubit.get(context).ChatController.length,
                    itemBuilder: (context,index)=>ChatTextForm(index,context,)),
              ),
              Container(
                height: 65,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (context,index)=>Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: ContactFormField(NickName,FaIcon(FontAwesomeIcons.userNinja),"Nickname",false))),
              ),
              Container(
                height: 65,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (context,index)=>Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: ContactFormField(Website,Icon(Icons.language),"Website",false))),
              ),
              Container(
                height: 65,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (context,index)=>Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: ContactFormField(Notes,Icon(Icons.note),"Notes",false))),
              ),

            ],
          );
          },
        ),
      ),
    );
  }

  Padding ContactFormField(controller,PreIcon , LabelText , bool?DropDown) {
    return Padding(
      padding: EdgeInsets.only(right: DropDown==true?0.0:32,left: PreIcon !=null?15.0:55 , top: 8 , bottom: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          icon: PreIcon,
          suffixIcon: IconButton(onPressed: (){},icon: Icon(Icons.cancel)),
          labelText: LabelText,
          fillColor: Colors.grey[200],
            filled: true,
        ),
      ),
    );
  }


  Row PhoneTextForm(index,context) {
    return Row(
      children: [
        SizedBox(width: 20),
        index==0?FaIcon(FontAwesomeIcons.phoneAlt):SizedBox(width: 24),
        SizedBox(width: 10),
        ///DropDownMenu (Label)
        Container(
          width: 95,
          child: DropdownButtonFormField(
            // icon: preIcon,
            value: PhoneContactsCubit.get(context).PhoneSideMenu.first,
            alignment: AlignmentDirectional.center,
            onChanged: (label) {
              PhoneContactsCubit.get(context).PhoneSideMenuController[index]=label as PhoneLabel;
            },
            items: PhoneContactsCubit.get(context).PhoneSideMenu.map((value) {
              return DropdownMenuItem(
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
              if(PhoneContactsCubit.get(context).PhoneNumberController.last.text.isNotEmpty)
              {
                PhoneContactsCubit.get(context).PhoneNumberadd(true);
              }
              if(value.isEmpty&&PhoneContactsCubit.get(context).PhoneNumberController.length >1)
              { PhoneContactsCubit.get(context).PhoneNumberadd(false); }

            },
            controller: PhoneContactsCubit.get(context).PhoneNumberController[index],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left:5),
              suffixIcon: IconButton(onPressed: (){},icon: Icon(Icons.cancel)),
              labelText: "Number",
              fillColor: Colors.grey[200],
                filled: false,
            ),
          ),
        ),
      ),

      ]
    );
  }
  Row EmailAddressTextForm(index,context,) {
    return Row(
      children: [
        SizedBox(width: 20),
        index==0?Icon(Icons.contact_mail,):SizedBox(width: 24),
        SizedBox(width: 10),
        ///DropDownMenu (Label)
        Container(
          width: 95,
          child: DropdownButtonFormField(
            value: PhoneContactsCubit.get(context).EmailSideMenu.first,
            alignment: AlignmentDirectional.center,
            onChanged: (label) {
              PhoneContactsCubit.get(context).EmailSideMenuController[index]=label as EmailLabel;
            },
            items: PhoneContactsCubit.get(context).EmailSideMenu.map((value) {
              return DropdownMenuItem(
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
              if(PhoneContactsCubit.get(context).EmailAddressController.last.text.isNotEmpty)
              {
                PhoneContactsCubit.get(context).EmailAddressAdd(true);
              }
              if(value.isEmpty&&PhoneContactsCubit.get(context).EmailAddressController.length >1)
              { PhoneContactsCubit.get(context).EmailAddressAdd(false);}

            },
            controller: PhoneContactsCubit.get(context).EmailAddressController[index],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left:5),
              suffixIcon: IconButton(onPressed: (){},icon: Icon(Icons.cancel)),
              labelText: 'Email',
              fillColor: Colors.grey[200],
                filled: false,
            ),
          ),
        ),
      ),

      ]
    );
  }
  Row AddressTextForm(index,context,) {
    return Row(
      children: [
        SizedBox(width: 20),
        index==0?Icon(Icons.place):SizedBox(width: 24),
        SizedBox(width: 10),
        ///DropDownMenu (Label)
        Container(
          width: 95,
          child: DropdownButtonFormField(
            value: PhoneContactsCubit.get(context).EmailSideMenu.first,
            alignment: AlignmentDirectional.center,
            onChanged: (label) {
              PhoneContactsCubit.get(context).AddressSideMenuController[index]=label as AddressLabel;
            },
            items: PhoneContactsCubit.get(context).EmailSideMenu.map((value) {
              return DropdownMenuItem(
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
              if(PhoneContactsCubit.get(context).AddressController.last.text.isNotEmpty)
              {
                PhoneContactsCubit.get(context).AddressAdd(true);
              }
              if(value.isEmpty&&PhoneContactsCubit.get(context).AddressController.length >1) { PhoneContactsCubit.get(context).AddressAdd(false);}
            },
            controller: PhoneContactsCubit.get(context).AddressController[index],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left:5),
              suffixIcon: IconButton(onPressed: (){},icon: Icon(Icons.cancel)),
              labelText: "Address",
              fillColor: Colors.grey[200],
                filled: false,
            ),
          ),
        ),
      ),

      ]
    );
  }
  Row EventTextForm(index,context,) {
    return Row(
      children: [
        SizedBox(width: 20),
        index==0?Icon(Icons.event):SizedBox(width: 24),
        SizedBox(width: 10),
        ///DropDownMenu (Label)
        Container(
          width: 95,
          child: DropdownButtonFormField(
            // icon: preIcon,
            value: PhoneContactsCubit.get(context).EventSideMenu.first,
            alignment: AlignmentDirectional.center,
            onChanged: (label) {
              PhoneContactsCubit.get(context).EventSideMenuController[index]=label as EventLabel;
            },
            items: PhoneContactsCubit.get(context).EventSideMenu.map((value) {
              return DropdownMenuItem(
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
            onTap: (){
              showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime((DateTime.now().year)+10,1,1),).then((value){
                PhoneContactsCubit.get(context).EventController[index].text = DateFormat.yMMMd().format(value!);
              });
            },
            onChanged: (value){
              if(PhoneContactsCubit.get(context).EventController.last.text.isNotEmpty)
              {
                PhoneContactsCubit.get(context).EventAdd(true);
              } if(value.isEmpty&&PhoneContactsCubit.get(context).EventController.length >1) { PhoneContactsCubit.get(context).EventAdd(false);}

            },
            controller: PhoneContactsCubit.get(context).EventController[index],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left:5),
              suffixIcon: IconButton(onPressed: (){},icon: Icon(Icons.cancel)),
              labelText: "Date",
              fillColor: Colors.grey[200],
                filled: false,
            ),
          ),
        ),
      ),

      ]
    );
  }
  Row ChatTextForm(index,context) {
    return Row(
      children: [
        SizedBox(width: 20),
        index==0?Icon(Icons.forum):SizedBox(width: 24),
        SizedBox(width: 10),
        ///DropDownMenu (Label)
        Container(
          width: 95,
          child: DropdownButtonFormField(
            // icon: preIcon,
            value: PhoneContactsCubit.get(context).ChatSideMenu.first,
            alignment: AlignmentDirectional.center,
            onChanged: (label) {
              if(label.toString().contains('Phone')){
              index == index?PhoneContactsCubit.get(context).ChatSideMenuController[index]=label as SocialMediaLabel:null;
              }
            },
            items: PhoneContactsCubit.get(context).ChatSideMenu.map((value) {
              return DropdownMenuItem(
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
            },
            controller: PhoneContactsCubit.get(context).ChatController[index],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left:5),
              suffixIcon: IconButton(onPressed: (){},icon: Icon(Icons.cancel)),
              labelText: "IM",
              fillColor: Colors.grey[200],
                filled: false,
            ),
          ),
        ),
      ),

      ]
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


}
