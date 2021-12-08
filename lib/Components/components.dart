import 'dart:ui';

import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hexcolor/hexcolor.dart';



AppBar MainAppBar(BuildContext context, double AppbarSize,TextEditingController Searchcontroller) {
  return AppBar(
    automaticallyImplyLeading: false,
    title:Container(
      height: 28,
      width:MediaQuery.of(context).size.width*0.55,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(3),
        color:SearchBackgroundColor(),
      ),
      child: TextField(
        // style: Theme.of(context).textTheme.headline2,
        controller: Searchcontroller,
        textAlignVertical: TextAlignVertical.center,
        onChanged: (value){
          AppCubit.get(context).filterContacts(Searchcontroller);
        },
        decoration: InputDecoration(
          hintText: "Search among ${AppCubit.get(context).Contacts.length} contact(s)",
          // contentPadding: EdgeInsets.all(0),
          // alignLabelWithHint: true,
          // labelText:"Search",
          hintStyle:Theme.of(context).textTheme.headline2,
          // isCollapsed: true,
          prefixIcon: Icon(Icons.search,color: SearchIconColor(),size: 25,),
          border:InputBorder.none,
          // fillColor: SearchBackgroundColor(),
        ),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(top:16.0,right:15),
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
              child: Text("Chat",style: Theme.of(context).textTheme.headline2!.copyWith(color:HexColor("#616161")),),
            )
          ],),
      ),
    ],
    leading: IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,color:AppBarMoreIconColor()),),
    toolbarHeight: AppbarSize,
    flexibleSpace: SafeArea(
      child: ClipPath(
        child: Stack(
            children: [
              Container(
                  color: AppBarBackgroundColor()
              ),
              Padding(
                padding:EdgeInsets.only(top:AppbarSize-13,left:12),
                child:Container(
                    width: 35,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:AppBarEditIconColor(),
                    ),
                    child: IconButton(onPressed: (){}, icon:Icon(Icons.create_outlined),iconSize: 20)),
              ),
            ]
        ),
        clipper: MyCustomeClipper(),
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
              customBorder:RoundedRectangleBorder(
                borderRadius:BorderRadiusDirectional.only(
                  topStart: Radius.circular(30),
                ),
              ) ,
              onTap: (){
                if(dialerController.text.isEmpty)
                  {
                    AppCubit.get(context).ShowHide();
                  }

                // String value = "1";
                dialerController.text = dialerController.text.isEmpty?"1":dialerController.text +"1";

              },
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,
                color: Colors.transparent,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("1",style: Theme.of(context).textTheme.headline3),
                    Transform.translate(
                        offset: Offset(0,-4),
                        child: Icon(Icons.voicemail,size:15)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                if(dialerController.text.isEmpty)
                {
                  AppCubit.get(context).ShowHide();
                }
                if(dialerController.text.length==1){
                  AppCubit.get(context).ShowHide();
                }
                dialerController.text = dialerController.text.isEmpty?"2":dialerController.text +"2";

              },
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Text("2",style: Theme.of(context).textTheme.headline3),
                    Transform.translate(
                        offset: Offset(0,-4),
                        child: Text("ABC",style:Theme.of(context).textTheme.headline4)),
                  ],
                ),
              ),
            ),
            InkWell(
              customBorder:RoundedRectangleBorder(
                borderRadius:BorderRadiusDirectional.only(
                  topEnd: Radius.circular(30),
                ),
              ) ,
              onTap: (){

                if(dialerController.text.isEmpty)
                {
                  AppCubit.get(context).ShowHide();
                }
                if(dialerController.text.length==1){
                  AppCubit.get(context).ShowHide();
                }
                dialerController.text = dialerController.text.isEmpty?"3":dialerController.text +"3";

              },
              child: Container(
                color: Colors.transparent,
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,

                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("3",style: Theme.of(context).textTheme.headline3),
                    Transform.translate(
                        offset: Offset(0,-4),
                        child: Text("DEF",style:Theme.of(context).textTheme.headline4)),
                  ],
                ),
              ),
            ),
          ]
      ),
      Row(
          children: [
            InkWell(
              onTap: (){
                if(dialerController.text.isEmpty)
                {
                  AppCubit.get(context).ShowHide();
                }
                if(dialerController.text.length==1){
                  AppCubit.get(context).ShowHide();
                }
                dialerController.text = dialerController.text.isEmpty?"4":dialerController.text +"4";
              },
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("4",style: Theme.of(context).textTheme.headline3),
                    Transform.translate(
                        offset: Offset(0,-4),
                        child: Text("GHI",style:Theme.of(context).textTheme.headline4)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                if(dialerController.text.isEmpty)
                {
                  AppCubit.get(context).ShowHide();
                }
                if(dialerController.text.length==1){
                  AppCubit.get(context).ShowHide();
                }
                dialerController.text = dialerController.text.isEmpty?"5":dialerController.text +"5";
              },
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("5",style: Theme.of(context).textTheme.headline3),
                    Transform.translate(
                        offset: Offset(0,-4),
                        child: Text("JKL",style:Theme.of(context).textTheme.headline4)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                if(dialerController.text.isEmpty)
                {
                  AppCubit.get(context).ShowHide();
                }
                if(dialerController.text.length==1){
                  AppCubit.get(context).ShowHide();
                }
                dialerController.text = dialerController.text.isEmpty?"6":dialerController.text +"6";
              },
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("6",style: Theme.of(context).textTheme.headline3),
                    Transform.translate(
                        offset: Offset(0,-4),
                        child: Text("MNO",style:Theme.of(context).textTheme.headline4)),
                  ],
                ),
              ),
            ),
          ]
      ),
      Row(
          children: [
            InkWell(
              onTap: (){
                if(dialerController.text.isEmpty)
                {
                  AppCubit.get(context).ShowHide();
                }
                if(dialerController.text.length==1){
                  AppCubit.get(context).ShowHide();
                }
                dialerController.text = dialerController.text.isEmpty?"7":dialerController.text +"7";
              },
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("7",style: Theme.of(context).textTheme.headline3),
                    Transform.translate(
                        offset: Offset(0,-4),
                        child: Text("PQRS",style:Theme.of(context).textTheme.headline4)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("8",style: Theme.of(context).textTheme.headline3),
                    Transform.translate(
                        offset: Offset(0,-4),
                        child: Text("TUV",style:Theme.of(context).textTheme.headline4)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("9",style: Theme.of(context).textTheme.headline3),
                    Transform.translate(
                        offset: Offset(0,-4),
                        child: Text("WXYZ",style:Theme.of(context).textTheme.headline4)),
                  ],
                ),
              ),
            ),
          ]
      ),
      Row(
          children: [
            InkWell(
              onTap: (){},
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("*",style: Theme.of(context).textTheme.headline3),
                    Transform.translate(
                        offset: Offset(0,-4),
                        child: Text("",style:Theme.of(context).textTheme.headline4)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("0",style: Theme.of(context).textTheme.headline3),
                    Transform.translate(
                        offset: Offset(0,-4),
                        child: Text("+",style:Theme.of(context).textTheme.headline4)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/6,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("#",style: Theme.of(context).textTheme.headline3),
                    Transform.translate(
                        offset: Offset(0,-4),
                        child: Text("",style:Theme.of(context).textTheme.headline4)),
                  ],
                ),
              ),
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
                }

              },
              onLongPress: (){
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
             FlutterPhoneDirectCaller.callNumber(dialerController.text);
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