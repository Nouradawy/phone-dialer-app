import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/Modules/Contacts/contacts_screen.dart';
import 'package:dialer_app/NativeBridge/native_bridge.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:dialer_app/Themes/theme_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/properties/note.dart';
import 'package:hexcolor/hexcolor.dart';

Container FavoritesContactsGroups(PhoneContactsCubit Cubit,context , AccessibilityText) {
  return Container(
    height:MediaQuery.of(context).size.height*0.15,
    // width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      color:ContactsFavBackgroundColor(),
    ),
    child: Stack(
      children: [
         Padding(
          padding: EdgeInsets.only(left: 10.0,top:2),
          child: Text("Favourites",textScaleFactor: AccessibilityText.textScaleFactor>1.2?1.2:AccessibilityText.textScaleFactor,),
        ),
        Padding(
          padding: const EdgeInsets.only(top:25,bottom: 9),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics:BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: Cubit.FavoratesContacts.length,
                    separatorBuilder: (context,index)=> SizedBox(width: 10,),
                    itemBuilder: (context, index) {
                      PhoneContactsCubit.get(context).FavoratesItemColors();
                      return FavoritesCards(context ,Cubit.FavoratesContacts[index]);
                    },
                  ),
                ),
              ),
              /*Vertical Separator*/
              Container(
                width:1,
                height: 30,
                color: HexColor("#5683DE"),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                    onTap: () async {
                      // print(fbList[13].toString());

                      //TODO: Testing FBLISt at contact screen @Fav icon
                    },
                    child: Image.asset("assets/Images/people_black_24dp.png",scale: 1.4,)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}



Container FavoritesCards( context , Contact) {
  final Color?  FavColor = PhoneContactsCubit.get(context).FavoratesItemColor;
  return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color:FavColor,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                            child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 1.4,color: Colors.white.withOpacity(0.80)),
                                ),
                                child: ContactAvatar(Contact, 34)),
                          ),
                          Text(Contact.info!.name.first.toString(),textScaleFactor: 1,style: Theme.of(context).textTheme.subtitle1!.copyWith(color:Colors.white),),
                          Text(Contact.info!.name.last.toString(),textScaleFactor: 1,style: Theme.of(context).textTheme.subtitle1!.copyWith(color:Colors.white),),
                        ],
                      ),
                    );
}

TextEditingController TagController = TextEditingController();
TextEditingController HeaderController = TextEditingController();

 Widget ContactsTagsNotes(BuildContext context , AppContact contact) {

   return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Tag!=null?MediaQuery.of(context).size.width*0.40:MediaQuery.of(context).size.width*0.20,
          ),
          child: Row(

            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Tag!=null?InkWell(

                    onTap: (){
                      showModalBottomSheet(context: context , builder: (context){
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top:20.0 , left: 20.0 , bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                              child: Stack(

                                children: [


                                  Stack(
                                    alignment:AlignmentDirectional.topEnd,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top:8.0),
                                        child: Container(
                                            alignment: AlignmentDirectional.topCenter,
                                            width:MediaQuery.of(context).size.width*0.50,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              color:HexColor("#F5F5F5"),
                                            ),
                                            child:Padding(
                                              padding: const EdgeInsets.only(top:7.0,right: 5,left: 5),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  hintText: "Type in your Hint body....",
                                                  border:InputBorder.none,
                                                ),
                                                maxLines: 2,
                                                maxLength: 45,
                                                controller: TagController,
                                                style: Theme.of(context).textTheme.button?.copyWith(color: Colors.black26),
                                                onSubmitted: (value){
                                                  TagsNotes.add({
                                                    "Tag": TagController.text,
                                                    "Header" : HeaderController.text,
                                                    "ContactID" : contact.info?.id,
                                                  });
                                                },

                                              ),
                                            )),
                                      ),
                                      IconButton(onPressed: (){
                                        HeaderController.clear();
                                        TagController.clear();
                                        TagsNotes.removeWhere((element) => element["ContactID"] == contact.info?.id);
                                      }, icon: Icon(Icons.remove_circle_outline)),
                                    ],
                                  ),
                                  Container(
                                      alignment: AlignmentDirectional.center,
                                      height:17,
                                      width:100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          gradient: LinearGradient(
                                            colors: [HexColor("#615A5A"),HexColor("#A227CE")],
                                          )
                                      ),
                                      child:Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintStyle: Theme.of(context).textTheme.button,
                                            isCollapsed: true,
                                            hintText: "Hint",
                                            border:InputBorder.none,
                                          ),
                                          controller: HeaderController,
                                          minLines: 1,
                                          style: Theme.of(context).textTheme.button?.copyWith(overflow: TextOverflow.visible),


                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: IconButton(onPressed: (){
                                print(TagsNotes);
                                TagsNotes.add({
                                  "Tag": TagController.text,
                                  "Header" : HeaderController.text,
                                  "ContactID" : contact.info?.id,
                                });
                              }, icon: Icon(Icons.check_circle_outline_outlined)),
                            ),
                          ],
                        );
                      });
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Container(
                              alignment: AlignmentDirectional.topCenter,
                              width:MediaQuery.of(context).size.width*0.30,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color:HexColor("#F5F5F5"),
                              ),
                              child:Padding(
                                padding: const EdgeInsets.only(top:10.0,right: 5,left: 5),
                                child: Text(Tag!,style:Theme.of(context).textTheme.button?.copyWith(color: Colors.black)),
                              )),
                        ),
                        Container(
                            alignment: AlignmentDirectional.center,
                            width: 70,
                            height: 17,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                gradient: LinearGradient(
                                  colors: [HexColor("#615A5A"),HexColor("#A227CE")],
                                )
                            ),
                            child:Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(Header.toString(),style:Theme.of(context).textTheme.button?.copyWith(),maxLines:1,overflow: TextOverflow.ellipsis),
                            )),
                      ],
                    ),
                  ):IconButton(onPressed: (){
                    showModalBottomSheet(context: context , builder: (context){
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top:20.0 , left: 20.0 , bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                            child: Stack(

                              children: [


                                Stack(
                                  alignment:AlignmentDirectional.topEnd,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:8.0),
                                      child: Container(
                                          alignment: AlignmentDirectional.topCenter,
                                          width:MediaQuery.of(context).size.width*0.50,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            color:HexColor("#F5F5F5"),
                                          ),
                                          child:Padding(
                                            padding: const EdgeInsets.only(top:7.0,right: 5,left: 5),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: "Type in your Hint body....",
                                                border:InputBorder.none,
                                              ),
                                              maxLines: 2,
                                              maxLength: 45,
                                              controller: TagController,
                                              style: Theme.of(context).textTheme.button?.copyWith(color: Colors.black26),
                                              onSubmitted: (value){
                                                TagsNotes.add({
                                                  "Tag": TagController.text,
                                                  "Header" : HeaderController.text,
                                                  "ContactID" : contact.info?.id,
                                                });
                                              },

                                            ),
                                          )),
                                    ),
                                    IconButton(onPressed: (){
                                      HeaderController.clear();
                                      TagController.clear();
                                      TagsNotes.removeWhere((element) => element["ContactID"] == contact.info?.id);
                                    }, icon: Icon(Icons.remove_circle_outline)),
                                  ],
                                ),
                                Container(
                                    alignment: AlignmentDirectional.center,
                                    height:17,
                                    width:100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        gradient: LinearGradient(
                                          colors: [HexColor("#615A5A"),HexColor("#A227CE")],
                                        )
                                    ),
                                    child:Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintStyle: Theme.of(context).textTheme.button,
                                          isCollapsed: true,
                                          hintText: "Hint",
                                          border:InputBorder.none,
                                        ),
                                        controller: HeaderController,
                                        minLines: 1,
                                        style: Theme.of(context).textTheme.button?.copyWith(overflow: TextOverflow.visible),


                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: IconButton(onPressed: (){
                              print(TagsNotes);
                              TagsNotes.add({
                                "Tag": TagController.text,
                                "Header" : HeaderController.text,
                                "ContactID" : contact.info?.id,
                              });
                            }, icon: Icon(Icons.check_circle_outline_outlined)),
                          ),
                        ],
                      );
                    });
                  }, icon: Icon(Icons.new_label_rounded)),

                ],
              ),

            ],
          ),
        );

  }

  String? Tag =null;
  String? Header =null;
 void TagNotesHelper (context ,  contact){
  Tag =null;
  Header =null;
   TagsNotes.forEach((element) {
     if(contact.info?.id == element["ContactID"])
       {
         Tag=element["Tag"];
         Header = element["Header"];
       }
   });

}

ConstrainedBox ContactTagNotes(BuildContext context ,Notes) {
  return ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width*0.50,
      maxHeight: 100,
    ),
    child: PageView.builder(
      itemCount: Notes?.length,

      itemBuilder:(context,index) {
        NotesPageIndex = index;
        print("Page Index : "+NotesPageIndex.toString());
        return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Container(
                    alignment: AlignmentDirectional.topCenter,
                    width:MediaQuery.of(context).size.width*0.50,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color:HexColor("#F5F5F5"),
                    ),
                    child:Padding(
                      padding: const EdgeInsets.only(top:9.0,right: 7,left: 7),
                      child: Text(Notes![index],style: Theme.of(context).textTheme.caption,),
                    )),
              ),
              Container(
                  alignment: AlignmentDirectional.center,
                  width:26,
                  height: 14,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: LinearGradient(
                        colors: [HexColor("#615A5A"),HexColor("#A227CE")],
                      )
                  ),
                  child:Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Text("Hint",style:Theme.of(context).textTheme.button),
                  )),
              Transform.translate(
                offset: Offset(-3,55),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text("${index+1}/${Notes.length}")),
              ),
            ],
          ),

        ],
      );
      },
    ),
  );
}