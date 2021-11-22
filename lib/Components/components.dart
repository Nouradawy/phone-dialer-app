import 'package:dialer_app/Themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

AppBar MyAppBar(BuildContext context, double AppbarSize) {
  return AppBar(
    automaticallyImplyLeading: false,
    title:Stack(
      children: [
        Container(
          height: 28,
          width: MediaQuery.of(context).size.width*0.55,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(3),
            color:SearchBackgroundColor(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left:4.0),
          child: Icon(Icons.search,color: SearchIconColor(),size: 28,),
        ),
        Padding(
          padding: const EdgeInsets.only(left:37.0,top:6),
          //TODO: Add the correct contacts number
          child: Text("Search among 292 contact(s)",style:Theme.of(context).textTheme.headline2 ,),
        ),

      ],),
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