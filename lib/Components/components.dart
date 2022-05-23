
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:dialer_app/Layout/incall_screen.dart';
import 'package:dialer_app/Models/user_model.dart';
import 'package:dialer_app/Modules/Chat/chat_screen.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Contacts/contacts_pictures_fetcher.dart';
import 'package:dialer_app/Modules/profile/Profile%20Cubit/profile_cubit.dart';
import 'package:dialer_app/Modules/profile/profile_page.dart';
import 'package:dialer_app/NativeBridge/native_bridge.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:dialer_app/Themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ndialog/ndialog.dart';
import '../home-editcolor.dart';
import '../home.dart';
import 'constants.dart';


AppBar MainAppBar(BuildContext context, double AppbarSize,TextEditingController Searchcontroller ) {
  return AppBar(
    // automaticallyImplyLeading: false,
    title:Container(
      height: 28,
      width:MediaQuery.of(context).size.width*0.55,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(3),
        color:SearchBackgroundColor(),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.55*0.01),
            child: Icon(Icons.search,color: SearchIconColor(),size: 25,),
          ),
          TextField(
            style: Theme.of(context).textTheme.headline2,
            controller: Searchcontroller,
            textAlign:TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            onChanged: (value){
              PhoneContactsCubit.get(context).SearchContacts(Searchcontroller , PhoneContactsCubit.get(context).Contacts);
              if(AppCubit.get(context).searchController.text.isEmpty)
                {
                  PhoneContactsCubit.get(context).isSearching = false;
                } else {
                PhoneContactsCubit.get(context).isSearching = true;
              }
            },
            decoration: InputDecoration(
              hintText: "Search among ${PhoneContactsCubit.get(context).Contacts.length} contact(s)",
              // contentPadding: EdgeInsets.all(0),
              // alignLabelWithHint: true,
              // labelText:"Search",
              hintStyle:Theme.of(context).textTheme.headline2,
              // isCollapsed: true,
              border:InputBorder.none,
              // fillColor: SearchBackgroundColor(),
            ),
          ),
        ],
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(top:16.0,right:15),
        child: InkWell(
          onTap:(){
            Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => ChatScreen()));
          },
          child: Stack(
            children: [
              Container(
                height: 25,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(3),
                  color:AppBarChatIconBackgroundColor(),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:4.0,left:5.5),
                child: Image.asset("assets/Images/Chatting_Logo.png",scale:3.2),
              ),
              Padding(
                padding: const EdgeInsets.only(left:28.0,top:4),
                child: Text("Chat",style: Theme.of(context).textTheme.headline2!.copyWith(color:AppBarChatTextColor()),),
              )
            ],),
        ),
      ),
    ],
    toolbarHeight: AppbarSize,
    flexibleSpace: SafeArea(
      child: ClipPath(
        child: Stack(
            children: [
              Container(
                  color: AppBarBackgroundColor(context)
              ),
              // Padding(
              //   padding:EdgeInsets.only(top:AppbarSize-13,left:12),
              //   child:Container(
              //       width: 35,
              //       height: 36,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(8),
              //         color:AppBarEditIconBackGroundColor(),
              //       ),
              //       child: InkWell(onTap: (){
              //         Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>HomeScreenEdite()));
              //       },
              //         child: Image.asset("assets/Images/droplet-solid.png",scale: 12,color: HexColor("#4527A0"),),
              //       )),
              // ),
            ]
        ),
        clipper: MyCustomeClipper(),
      ),
    ),
    bottom: TabBar(
      // padding: EdgeInsets.only(left:30,right:30),
      isScrollable: true,
      indicatorPadding: const EdgeInsets.only(bottom: 25),
      labelPadding: const EdgeInsets.only(bottom: 18,left:45,right:45),
      indicatorColor: TabBarindicatorColor(),
      labelColor: TabBarlabelColor(),
      unselectedLabelColor: TabBarUnselectedlabelColor(),
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle:Theme.of(context).textTheme.headline1,
      tabs: const [
        Tab(text:"Phone"),
        Tab(text:"Contacts"),
      ],),
  );
}
AppBar MainAppBarEditor(BuildContext context, double AppbarSize,TextEditingController Searchcontroller ) {
  return AppBar(
    // automaticallyImplyLeading: false,
    title:Container(
      height: 28,
      width:MediaQuery.of(context).size.width*0.55,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(3),
        color:SearchBackgroundColor(),
      ),
      child:

         InkWell(
          onTap: (){

            NDialog(
              content:BlocBuilder<AppCubit,AppStates>(
                  builder:(context,states)=> AppCubit.get(context).HomePageBackgroundColorPicker()),
              dialogStyle: DialogStyle(
                elevation: 10,
              ),
            ).show(context , barrierColor: Colors.black.withOpacity(0.20));
          },
          child: Row (
            children: [
              Padding(
                padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.55*0.01),
                child: Icon(Icons.search,color: SearchIconColor(),size: 25,),
              ),
              Text("Search among ${PhoneContactsCubit.get(context).Contacts.length} contact(s)",style: Theme.of(context).textTheme.headline2!.copyWith(color: AppCubit.get(context).SearchTextColor),),

            ],
          ),
        ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(top:16.0,right:15),
        child: InkWell(
          onTap:(){
            NDialog(
              content:AppCubit.get(context).HomePageBackgroundColorPicker(),
              dialogStyle: DialogStyle(),
            ).show(context);
          },
          child: Stack(
            children: [
              Container(
                height: 25,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(3),
                  color:AppBarChatIconBackgroundColor(),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:4.0,left:5.5),
                child: Image.asset("assets/Images/Chatting_Logo.png",scale:3.2),
              ),
              Padding(
                padding: const EdgeInsets.only(left:28.0,top:4),
                child: Text("Chat",style: Theme.of(context).textTheme.headline2!.copyWith(color:AppBarChatTextColor()),),
              ),

            ],
          ),
        ),
      ),
    ],
    toolbarHeight: AppbarSize,
    flexibleSpace: SafeArea(
      child: InkWell(
        onTap: (){
          NDialog(
            content:AppCubit.get(context).HomePageBackgroundColorPicker(),
            dialogStyle: DialogStyle(),
          ).show(context);
        },
        child: ClipPath(
          child: Stack(
              children: [
                Container(
                  /// background app bar value
                    color: AppCubit.get(context).CustomHomePageBackgroundColor
                ),
                Padding(
                  padding:EdgeInsets.only(top:AppbarSize-13,left:12),
                  child:Container(
                      width: 35,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:AppBarEditIconBackGroundColor(),
                      ),
                      child: IconButton(onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (
                            BuildContext context)=>Home()));
                        AppCubit.get(context).SaveCustomTheme();
                        print(AppCubit.get(context).CustomHomePageBackgroundColor);
                        AppCubit.get(context).EditorIsActive = false;
                      }, icon:Icon(Icons.done , color: AppBarEditIconColor(),),iconSize: 20 ,
                        tooltip: "Apply" ,)),
                ),
              ]
          ),
          clipper: MyCustomeClipper(),
        ),
      ),
    ),
    bottom: TabBar(
      // padding: EdgeInsets.only(left:30,right:30),
      isScrollable: true,
      indicatorPadding: EdgeInsets.only(bottom: 25),
      labelPadding: EdgeInsets.only(bottom: 18,left:45,right:45),
      indicatorColor: TabBarindicatorColor(),
      labelColor: TabBarlabelColor(),
      unselectedLabelColor: TabBarUnselectedlabelColor(),
      indicatorSize: TabBarIndicatorSize.label,

      labelStyle:Theme.of(context).textTheme.headline1,
      tabs: const [
        Tab(text:"Phone"),
        Tab(text:"Contacts"),
      ],),
  );
}




AppBar ChatAppBar(BuildContext context, double AppbarSize) => AppBar(
    automaticallyImplyLeading: false,
    title:Transform.translate(
      offset:const Offset(0, -4),
      child: Row(
        children: [
          Image.asset("assets/Images/chatLogo.png",scale: 1.9,),
          Text("Chats",style: TextStyle(
            fontFamily: "Cairo",
            fontWeight: FontWeight.w600,
            color:HexColor("#404040"),
            fontSize: 25,
          ),),
        ],
      ),
    ),
    actions: [
      Transform.translate(
          offset: const Offset(0, -4),
          child: IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_none_rounded),color:HexColor("#23036A"),padding: const EdgeInsets.all(1),))
    ],
    // leading: IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,color:AppBarMoreIconColor()),),
    toolbarHeight: AppbarSize,
    flexibleSpace: SafeArea(
      child: ClipPath(
        child: Container(
            color: AppBarBackgroundColor(context)
        ),
        clipper: MyCustomeClipper(),
      ),
    ),
  );
AppBar ChatMessagesAppBar(BuildContext context, double AppbarSize , UserModel Contact) {
  return AppBar(
    automaticallyImplyLeading: false,
    title:Transform.translate(
      offset:const Offset(0, -4),
      child: ListTile(

          leading:Container(
            width: 55,
              height: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:NetworkImage(Contact.image.toString()),
                  fit:BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),

          ),
        title:Text(Contact.name.toString(),style: TextStyle(
            fontFamily: "Cairo",
            fontWeight: FontWeight.w600,
            color:HexColor("#404040"),
            fontSize: 15,
          height: 1,
          ),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:const [
            Text("Last Seen",style: TextStyle(height: 1.2),),
            Text("30 Min ago",style: TextStyle(height: 1.2),),

          ]
        ),
      ),
    ),
    actions: [
      Transform.translate(
        offset: const Offset(18,-4),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                  color:Colors.black.withOpacity(0.73)
              ),
              width: 26,
              height: 26,

            ),
            IconButton(onPressed: (){}, icon: const Icon(Icons.phone),color:Colors.white,iconSize: 16,),
          ],
        ),
      ),
      Transform.translate(
        offset: const Offset(8,-4),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                  color:Colors.black.withOpacity(0.73)
              ),
              width: 26,
              height: 26,

            ),
            IconButton(onPressed: (){}, icon: const Icon(Icons.search),color:Colors.white,iconSize: 16,),
          ],
        ),
      ),
      Transform.translate(
          offset: const Offset(0, -4),
          child: IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert_rounded),color:HexColor("#23036A"),padding: const EdgeInsets.all(1),)),
    ],
    // leading: IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,color:AppBarMoreIconColor()),),
    toolbarHeight: AppbarSize,
    flexibleSpace: SafeArea(
      child: ClipPath(
        child: Container(
            color: AppBarBackgroundColor(context)
        ),
        clipper: MyCustomeClipper(),
      ),
    ),
  );
}
Column Dialpad(BuildContext context, double AppbarSize , TextEditingController dialerController ) {
bool DualSIM = false;

  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    children:[
      Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Container(
          width: 30,
          height: 1,
          color:Colors.grey,),
      ),

      //Show or Hide TextFormField above the dialer if it is empty hide if not show
      Container(
        child: dialerController.text.isNotEmpty?TextFormField(
          style: Theme
              .of(context)
              .textTheme
              .headline3,
          textAlign: TextAlign.center,
          controller: dialerController,
          onChanged: (value) {
            AppCubit.get(context).ShowHide();
          },
          // readOnly: true,
          showCursor: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 30),
            border: InputBorder.none,
          ),
        ):null,
      ),
      Row(
          children: [
            InkWell(
              splashColor: Colors.blue[100],
              customBorder:const RoundedRectangleBorder(
                borderRadius:BorderRadiusDirectional.only(
                  topStart: Radius.circular(30),
                ),
              ) ,
              onTap: (){
                //TODO:Make it Only active while incall
                NativeBridge.get(context).invokeNativeMethod("num1");

                AddingNumberToDialPad(dialerController, context , "1");

              },
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,
                color: Colors.transparent,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("1",style: Theme.of(context).textTheme.headline3),
                    Transform.translate(
                        offset: const Offset(0,-4),
                        child: const Icon(Icons.voicemail,size:15)),
                  ],
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.blue[100],
              onTap: (){
                PhoneContactsCubit.get(context).SearchTerm = ["a", "b", "c"];
                PhoneContactsCubit.get(context).DialpadSearch(dialerController);
                AddingNumberToDialPad(dialerController, context , "2");
                // dialerController.text = dialerController.text.isEmpty?"2":dialerController.text +"2";

              },
              child: DialPadButtonLayout(context, AppbarSize , "2" , "ABC"),
            ),
            InkWell(
              splashColor: Colors.blue,
              customBorder:const RoundedRectangleBorder(
                borderRadius:BorderRadiusDirectional.only(
                  topEnd: Radius.circular(30),
                ),
              ) ,
              onTap: (){
                PhoneContactsCubit.get(context).SearchTerm = ["d", "e", "f"];
                PhoneContactsCubit.get(context).DialpadSearch(dialerController,);
                AddingNumberToDialPad(dialerController, context , "3");
              },
              child: DialPadButtonLayout(context, AppbarSize , "3" , "DEF"),
            ),
          ]
      ),
      Row(
          children: [
            InkWell(
              onTap: (){
                PhoneContactsCubit.get(context).SearchTerm = ["g", "h", "i"];
                PhoneContactsCubit.get(context).DialpadSearch(dialerController,);
                AddingNumberToDialPad(dialerController, context , "4");
              },
              child: DialPadButtonLayout(context, AppbarSize , "4" , "GHI"),
            ),
            InkWell(
              onTap: (){
                PhoneContactsCubit.get(context).SearchTerm = ["j", "k", "l"];
                PhoneContactsCubit.get(context).DialpadSearch(dialerController,);
                AddingNumberToDialPad(dialerController, context , "5");
              },
              child: DialPadButtonLayout(context, AppbarSize , "5" , "JKL"),
            ),
            InkWell(
              onTap: (){
                PhoneContactsCubit.get(context).SearchTerm = ["m", "n", "o"];
                PhoneContactsCubit.get(context).DialpadSearch(dialerController,);
                AddingNumberToDialPad(dialerController, context , "6");
              },
              child: DialPadButtonLayout(context, AppbarSize , "6" , "MNO"),
            ),
          ]
      ),
      Row(
          children: [
            InkWell(
              onTap: (){
                PhoneContactsCubit.get(context).SearchTerm = ["p", "q", "r"];
                PhoneContactsCubit.get(context).DialpadSearch(dialerController,);
                AddingNumberToDialPad(dialerController, context , "7");
              },
              child: DialPadButtonLayout(context, AppbarSize , "7" , "PQRS"),
            ),
            InkWell(
              onTap: (){
                PhoneContactsCubit.get(context).SearchTerm = ["t", "u", "v"];
                PhoneContactsCubit.get(context).DialpadSearch(dialerController,);

                AddingNumberToDialPad(dialerController, context , "8");
              },
              child: DialPadButtonLayout(context, AppbarSize , "8" , "TUV"),
            ),
            InkWell(
              onTap: (){
                PhoneContactsCubit.get(context).SearchTerm = ["w", "x", "y"];
                PhoneContactsCubit.get(context).DialpadSearch(dialerController);

                AddingNumberToDialPad(dialerController, context , "9");
              },
              child: DialPadButtonLayout(context, AppbarSize , "9" , "WXYZ"),
            ),
          ]
      ),
      Row(
          children: [
            InkWell(
              onTap: (){
                NativeBridge.get(context).invokeNativeMethod("num*");
                AddingNumberToDialPad(dialerController, context , "*");

              },
              child: DialPadButtonLayout(context, AppbarSize , "*" , ""),
            ),
            InkWell(
              onTap: (){
                NativeBridge.get(context).invokeNativeMethod("num0");
                AddingNumberToDialPad(dialerController, context , "0");
              },
              child: DialPadButtonLayout(context, AppbarSize , "0" , "+"),
            ),
            InkWell(
              onTap: (){
                NativeBridge.get(context).invokeNativeMethod("num#");
                AddingNumberToDialPad(dialerController, context , "#");
              },
              child: DialPadButtonLayout(context, AppbarSize , "#" , ""),
            ),
          ]
      ),
      SizedBox(height: 7,),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: (){
                AppCubit.get(context).dialpadShow();
              },
              child: Container(
                width:MediaQuery.of(context).size.width*0.07,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/9,
                child:Image.asset("assets/Images/dialpad.png",scale:1.7),
              ),
            ),

            CallButton(context, AppbarSize , DualSIM , dialerController),

            InkWell(
              onTap: (){
                dialerController.text = dialerController.text.isNotEmpty ? dialerController.text.substring(0,dialerController.text.length-1) : dialerController.text;
                if(dialerController.text.isEmpty){
                  AppCubit.get(context).ShowHide();
                  PhoneContactsCubit.get(context).isSearching = false;
                }

              },
              onLongPress: (){
                dialerController.clear();
                if(dialerController.text.isEmpty){
                  AppCubit.get(context).ShowHide();
                }
                PhoneContactsCubit.get(context).isSearching = false;
              },
              child: Container(
                width:MediaQuery.of(context).size.width*0.08,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/9,
                child:Image.asset("assets/Images/backspace.png",scale:1.4,),
              ),
            ),
          ]
      ),
      SizedBox(height: 17,),
    ],

  );
}
Column InCallDialpad(BuildContext context, double AppbarSize , TextEditingController dialerController ) {
bool DualSIM = false;
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    children:[
      Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Container(
          width: 30,
          height: 1,
          color:Colors.grey,),
      ),

      //Show or Hide TextFormField above the dialer if it is empty hide if not show
      Container(

        child: TextFormField(
          style: Theme.of(context).textTheme.headline3!.copyWith(color:Colors.grey),
          textAlign: TextAlign.center,
          controller: dialerController,
          onChanged: (value) {
            AppCubit.get(context).ShowHide();
          },
          // readOnly: true,
          showCursor: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 25),
            border: InputBorder.none,
          ),
        )
      ),
      Row(
          children: [
            InkWell(
              splashColor: Colors.blue,
              customBorder:const RoundedRectangleBorder(
                borderRadius:BorderRadiusDirectional.only(
                  topStart: Radius.circular(30),
                ),
              ) ,
              onTap: (){
                //TODO:Make it Only active while incall
                NativeBridge.get(context).invokeNativeMethod("num1");

                AddingNumberToDialPad(dialerController, context , "1");

              },
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/7,
                color: Colors.transparent,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("1",style: Theme.of(context).textTheme.headline3!.copyWith(color:Colors.grey)),
                    Transform.translate(
                        offset: const Offset(0,-4),
                        child: const Icon(Icons.voicemail,size:14,color: Colors.grey,)),
                  ],
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.blue,
              onTap: (){

                NativeBridge.get(context).invokeNativeMethod("num2");
                AddingNumberToDialPad(dialerController, context , "2");
                // dialerController.text = dialerController.text.isEmpty?"2":dialerController.text +"2";

              },
              child: DialPadButtonLayoutInCall(context, AppbarSize , "2" , "ABC"),
            ),
            InkWell(
              splashColor: Colors.blue,
              customBorder:const RoundedRectangleBorder(
                borderRadius:BorderRadiusDirectional.only(
                  topEnd: Radius.circular(30),
                ),
              ) ,
              onTap: (){

                NativeBridge.get(context).invokeNativeMethod("num3");

                AddingNumberToDialPad(dialerController, context , "3");
              },
              child: DialPadButtonLayoutInCall(context, AppbarSize , "3" , "DEF"),
            ),
          ]
      ),
      Row(
          children: [
            InkWell(
              splashColor: Colors.blue,
              onTap: (){

                NativeBridge.get(context).invokeNativeMethod("num4");

                AddingNumberToDialPad(dialerController, context , "4");
              },
              child: DialPadButtonLayoutInCall(context, AppbarSize , "4" , "GHI"),
            ),
            InkWell(
              splashColor: Colors.blue,
              onTap: (){

                NativeBridge.get(context).invokeNativeMethod("num5");

                AddingNumberToDialPad(dialerController, context , "5");
              },
              child: DialPadButtonLayoutInCall(context, AppbarSize , "5" , "JKL"),
            ),
            InkWell(
              splashColor: Colors.blue,
              onTap: (){

                NativeBridge.get(context).invokeNativeMethod("num6");

                AddingNumberToDialPad(dialerController, context , "6");
              },
              child: DialPadButtonLayoutInCall(context, AppbarSize , "6" , "MNO"),
            ),
          ]
      ),
      Row(
          children: [
            InkWell(
              splashColor: Colors.blue,
              onTap: (){

                NativeBridge.get(context).invokeNativeMethod("num7");

                AddingNumberToDialPad(dialerController, context , "7");
              },
              child: DialPadButtonLayoutInCall(context, AppbarSize , "7" , "PQRS"),
            ),
            InkWell(
              splashColor: Colors.blue,
              onTap: (){

                NativeBridge.get(context).invokeNativeMethod("num8");
                AddingNumberToDialPad(dialerController, context , "8");
              },
              child: DialPadButtonLayoutInCall(context, AppbarSize , "8" , "TUV"),
            ),
            InkWell(
              splashColor: Colors.blue,
              onTap: (){

                NativeBridge.get(context).invokeNativeMethod("num9");
                AddingNumberToDialPad(dialerController, context , "9");
              },
              child: DialPadButtonLayoutInCall(context, AppbarSize , "9" , "WXYZ"),
            ),
          ]
      ),
      Row(
          children: [
            InkWell(
              splashColor: Colors.blue,
              onTap: (){
                NativeBridge.get(context).invokeNativeMethod("num*");
                AddingNumberToDialPad(dialerController, context , "*");

              },
              child: DialPadButtonLayoutInCall(context, AppbarSize , "*" , ""),
            ),
            InkWell(
              splashColor: Colors.blue,
              onTap: (){
                NativeBridge.get(context).invokeNativeMethod("num0");
                AddingNumberToDialPad(dialerController, context , "0");
              },
              child: DialPadButtonLayoutInCall(context, AppbarSize , "0" , "+"),
            ),
            InkWell(
              splashColor: Colors.blue,
              onTap: (){
                NativeBridge.get(context).invokeNativeMethod("num#");
                AddingNumberToDialPad(dialerController, context , "#");
              },
              child: DialPadButtonLayoutInCall(context, AppbarSize , "#" , ""),
            ),
          ]
      ),
      SizedBox(height: 7,),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.blue,
              borderRadius: BorderRadius.circular(7),
              onTap: (){
                AppCubit.get(context).dialpadShow();
              },
              child: Container(
                width:30,
                height: 35,
                child:Image.asset("assets/Images/dialpad.png",scale:1.6,color: Colors.grey.withOpacity(0.88),),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 85.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(5),
                radius: 2,
                onTap:(){
                  NativeBridge.get(context)
                      .invokeNativeMethod("RejectCall",null);
                },
                child: CircleAvatar(
                  backgroundColor: HexColor("#FC5757"),
                  radius: 31,
                  child: Image.asset("assets/Images/call_end.png",scale:6),
                ),
              ),
            ),

            InkWell(
              splashColor: Colors.blue,
              borderRadius: BorderRadius.circular(5),
              // radius: 15,
              onTap: (){
                dialerController.text = dialerController.text.isNotEmpty ? dialerController.text.substring(0,dialerController.text.length-1) : dialerController.text;
                if(dialerController.text.isEmpty){
                  AppCubit.get(context).ShowHide();
                  PhoneContactsCubit.get(context).isSearching = false;
                }
              },
              onLongPress: (){
                dialerController.clear();
                if(dialerController.text.isEmpty){
                  AppCubit.get(context).ShowHide();
                }
                PhoneContactsCubit.get(context).isSearching = false;
              },
              child: Container(
                width:30,
                height: 30,
                child:Image.asset("assets/Images/backspace.png",scale:1.3,color: Colors.white,),
              ),
            ),
          ]
      ),
      SizedBox(height: 17,),
    ],

  );
}

Container DialPadButtonLayout(BuildContext context, double AppbarSize , String Numpad , String alpha) {
  return Container(
              width:MediaQuery.of(context).size.width/3,
              height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text(Numpad,style: Theme.of(context).textTheme.headline3),
                  Transform.translate(
                      offset: const Offset(0,-4),
                      child: Text(alpha,style:Theme.of(context).textTheme.headline4)),
                ],
              ),
            );
}
Container DialPadButtonLayoutInCall(BuildContext context, double AppbarSize , String Numpad , String alpha) {
  return Container(
              width:MediaQuery.of(context).size.width/3,
              height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/7,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text(Numpad,style: Theme.of(context).textTheme.headline3!.copyWith(color:Colors.grey )),
                  Transform.translate(
                      offset: const Offset(0,-4),
                      child: Text(alpha,style:Theme.of(context).textTheme.headline4)),
                ],
              ),
            );
}

void AddingNumberToDialPad(TextEditingController dialerController, BuildContext context , String Num) {
  if(dialerController.text.isEmpty)
  {
    AppCubit.get(context).ShowHide();
    dialerController.text =Num;
  }else{
    AppCubit.get(context).ShowHide();
    dialerController.text =dialerController.text +Num;
    PhoneContactsCubit.get(context).isSearching = true;
  }
}

Row CallButton(BuildContext context, double AppbarSize , bool DualSIM , TextEditingController dialerController) {

  if(DualSIM==true) {
    return Row(
      children: [
        InkWell(
          onTap: () {},
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              Container(
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                  color: HexColor("#57E3A0"),
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height:
                    ((MediaQuery.of(context).size.height - AppbarSize) / 2) / 8,
                child: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("SIM1",
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 13,
                        color: Colors.white,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child:
                    Image.asset("assets/Images/call_black_36dp.png", scale: 7),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {},
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              Container(
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                  color: HexColor("#57E3A0"),
                ),
                width: MediaQuery.of(context).size.width * 0.29,
                height:
                    ((MediaQuery.of(context).size.height - AppbarSize) / 2) / 8,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("SIM2",
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child:
                    Image.asset("assets/Images/call_black_36dp.png", scale: 7),
              ),
              Transform.translate(
                  offset: Offset(0, 0),
                  child: Container(
                    width: 0.7,
                    height:
                        (((MediaQuery.of(context).size.height - AppbarSize) /
                                    2) /
                                8) -
                            18,
                    color: HexColor("#808080").withOpacity(0.28),
                  )),
            ],
          ),
        ),
      ],
    );
  }
  else {
    return Row(
      children: [
        SizedBox(width:MediaQuery.of(context).size.width*0.22),
         InkWell(
           onTap: (){

             PhoneContactsCubit.get(context).isSearching = false;
             AppCubit.get(context).dialpadShow();
             FlutterPhoneDirectCaller.callNumber(dialerController.text);
             dialerController.clear();
             Navigator.pushAndRemoveUntil(context,
               MaterialPageRoute(builder: (BuildContext context) => InCallScreen()),
                   (Route<dynamic>route)=>false,);
             NativeBridge.get(context).isRinging = false;
           },
           child: Container(
            width:55,
            height:55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color:HexColor("#57E3A0"),
            ),
            child:Image.asset("assets/Images/call_black_36dp.png", scale: 6),
        ),
         ),
        SizedBox(width:MediaQuery.of(context).size.width*0.22),
      ],
    );
  }
}

Drawer AppDrawer(BuildContext context , AppbarSize) {

  return Drawer(
    child: Builder(
            builder: (index){
              ProfileCubit.get(context)..GetChatContacts();
              var Cubit = ProfileCubit.get(context);
              String UserState = "online";


              return  Padding(
                padding:EdgeInsets.only(top:MediaQuery.of(context).padding.top),
                child: Column(

                    children: [
                      Container(height: MediaQuery.of(context).size.height*0.20,
                          color:Colors.amber,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0,top: 3),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:Border.all(width: 1.5)
                                  ),
                                  child: InkWell(
                                    onLongPress: (){
                                      signOut(context);
                                    },
                                    onTap: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>ProfilePage(),));
                                    },
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(Cubit.CurrentUser[0].image.toString()),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left:15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Text(Cubit.CurrentUser[0].name.toString()),
                                        SizedBox(width: 5,),

                                        FocusedMenuHolder(
                                          menuOffset: 5,
                                          menuItems: [
                                            FocusedMenuItem(
                                                title: Text("online"),
                                                trailingIcon: Icon(Icons.circle ,size:12 , color: Colors.green,),
                                                onPressed: (){
                                                  UserState = "online";
                                                }),
                                            FocusedMenuItem(
                                                title: Text("Away"),
                                                trailingIcon: Icon(Icons.circle ,size:12 , color: Colors.red,),
                                                onPressed: (){
                                                  UserState = "Away";
                                                }),
                                          ],
                                          onPressed: (){},
                                          menuWidth: 80,
                                          openWithTap: true,
                                          child: Container(

                                            decoration: BoxDecoration(
                                              color:Colors.white,
                                              borderRadius: BorderRadius.circular(4)
                                            ),

                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0),
                                              child: Transform.translate(
                                                offset: Offset(5,0),
                                                child: Row(
                                                  children: [
                                                    Transform.translate(
                                                        offset: Offset(0,1.5),
                                                        child: CircleAvatar(radius: 5, backgroundColor: UserState == "online"?Colors.green:Colors.red,)),
                                                    SizedBox(width:1),
                                                    Text(UserState),
                                                    Transform.translate(
                                                        offset: Offset(0,1.5),
                                                        child: Icon(Icons.arrow_drop_down ,)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                    Text(Cubit.CurrentUser[0].email.toString()),
                                  ],
                                ),

                              ),
                            ],
                          )
                      ),
                      Text("Display Settings"),
                      ListTile(
                        title:Text("Lang"),
                        trailing: Text("Eng"),
                      ),
                      ListTile(
                        onTap: (){
                          AppCubit.get(context).ThemeSwitcher();
                        },
                        title:Text("Theme"),
                        trailing: Text(ThemeSwitch?"Light":"Dark"),
                      ),
                      Text("System Settings"),
                      ListTile(
                        onTap: (){},
                        leading: Icon(Icons.settings),
                        title:Text("Settings"),
                      ),
                      ListTile(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=> ContactsFetcher()));
                        },
                        leading: Icon(Icons.contacts),
                        title:Text("ContactPictures"),
                      ),
                      ListTile(
                        onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomeScreenEdite()
                            ));
                        },
                        leading: FaIcon(FontAwesomeIcons.theaterMasks),
                        title:Text("Theme Customization"),
                      ),
                    ],
                  ),
              );

            }
    ),
  );
}

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
  IconData? LeadingIcon,
})=>AppBar(
  leading: IconButton(
    onPressed: ()=>Navigator.pop(context),
    icon:Icon(LeadingIcon),
  ),
  titleSpacing: 0.0,
  title:Text(title.toString()),
  actions: actions,
);


Widget defaultTextForm(
    context, {
      required TextEditingController controller,
      required TextInputType keyBoardType,
      required String text,
      required Function() onTap,
      Function(String?)? onChang,
      bool IsPassword = false,
      // bool ObsText = false
      String? Function(String?)? validate,
      IconData? preIcon,
      IconData? SuffixIcon,
      bool AutoFocus = false,
      String? prefixText,
      var Cubit,
    }) {
  final bool isactive = IsPassword;
  isactive ? IsPassword = Cubit.isPassword : null;

  return TextFormField(
    controller: controller,
    autofocus: AutoFocus,
    obscureText: IsPassword,
    keyboardType: keyBoardType,
    validator: validate,
    onTap: onTap,
    onChanged: onChang,
    decoration: InputDecoration(
      prefixText: prefixText,
      labelText: text,
      prefixIcon: Icon(
        preIcon,
      ),
      suffixIcon: isactive
          ? IconButton(
        onPressed: () {
          Cubit.Passon();
        },
        icon: Icon(Cubit.suffixIcon),
      )
          : IconButton(
        onPressed: () {},
        icon: Icon(SuffixIcon),
      ),
      border: OutlineInputBorder(),
    ),
  );


}
Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  required Function() function,
  required String text,
  bool isUpperCase = true,
  double radius = 3.0,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(
          radius,
        ),
      ),
    );

void showToast({
  required String text,
  required ToastStates state,})=>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0
    );

enum ToastStates {SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastStates state)
{
  Color color;

  switch(state)
  {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
  }
  return color;
}

class MyCustomeClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    Path path = Path();
    path.lineTo(0, size.height * 0.14);
    path.cubicTo(0, 0, 0, 0, size.width * 0.1, 0);
    path.cubicTo(size.width * 0.1, 0, size.width * 0.9, 0, size.width * 0.9, 0);
    path.cubicTo(size.width, 0, size.width, 0, size.width, size.height * 0.14);
    path.cubicTo(size.width, size.height * 0.14, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width, size.height * 0.86, size.width, size.height * 0.86, size.width * 0.9, size.height * 0.86);
    path.cubicTo(size.width * 0.9, size.height * 0.86, size.width * 0.1, size.height * 0.86, size.width * 0.1, size.height * 0.86);
    path.cubicTo(0, size.height * 0.86, 0, size.height * 0.86, 0, size.height);
    path.cubicTo(0, size.height, 0, size.height * 0.14, 0, size.height * 0.14);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldCliper) => false;
}