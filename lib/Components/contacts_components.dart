import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/Modules/Contacts/contacts_screen.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:dialer_app/Themes/light_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Container FavoritesContactsGroups(PhoneContactsCubit Cubit) {
  return Container(
    height:120,
    // width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      color:ContactsFavBackgroundColor(),
    ),
    child: Stack(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10.0,top:2),
          child: Text("Favourites"),
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
                height: 40,
                color: HexColor("#5683DE"),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                    onTap: (){
                      print(fbList[13].toString());
                      print(Cubit.Contacts[0].info!.displayName.toString());
                      Cubit.Contacts[0].info!.name.first = "Ahmed";
                      Cubit.Contacts[0].info?.update();
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
                                child: ContactAvatar(Contact, 38)),
                          ),
                          Text(Contact.info!.name.last.toString(),style: Theme.of(context).textTheme.subtitle1!.copyWith(color:Colors.white),),
                          Text(Contact.info!.name.last.toString(),style: Theme.of(context).textTheme.subtitle1!.copyWith(color:Colors.white),),
                        ],
                      ),
                    );
}
ConstrainedBox ContactsTagsNotes(BuildContext context) {
  return ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width*0.40,
    ),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Container(
                      alignment: AlignmentDirectional.topCenter,
                      width:80,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color:HexColor("#F5F5F5"),
                      ),
                      child:Padding(
                        padding: const EdgeInsets.only(top:2.0),
                        child: Text("Work colleague",style: Theme.of(context).textTheme.caption,),
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
              ],
            ),

          ],
        ),
      ],
    ),
  );
}