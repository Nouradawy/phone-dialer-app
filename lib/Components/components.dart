import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
Column Dialpad(BuildContext context, double AppbarSize ) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    children:[
      Row(
          children: [
            InkWell(
              customBorder:RoundedRectangleBorder(
                borderRadius:BorderRadiusDirectional.only(
                  topStart: Radius.circular(30),
                ),
              ) ,
              onTap: (){
              },
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/5,
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

              },
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/5,
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
              onTap: (){},
              child: Container(
                color: Colors.transparent,
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/5,

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
              onTap: (){},
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/5,
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
              onTap: (){},
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/5,
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
              onTap: (){},
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/5,
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
              onTap: (){},
              child: Container(
                width:MediaQuery.of(context).size.width/3,
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/5,
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
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/5,
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
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/5,
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
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/5,
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
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/5,
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
                height: ((MediaQuery.of(context).size.height-AppbarSize)/2)/5,
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
    ],

  );
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