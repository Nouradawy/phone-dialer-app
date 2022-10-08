import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import  'package:string_similarity/string_similarity.dart';

import '../Contacts/contacts_screen.dart';

class SocialMediaPicker extends StatefulWidget {
  SocialMediaPicker(this.contact);

  final AppContact contact;


  @override
  State<SocialMediaPicker> createState() => _SocialMediaPickerState();
}
int SuggestionsItemIndex = 0;

TextEditingController SearchController = TextEditingController();
bool isSearching = false;

class _SocialMediaPickerState extends State<SocialMediaPicker> {

  @override
  void initiState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    GetSuggestionsList(widget.contact);
    int count=0;
    List SuggestionsItemList = [{
      "name": "facebook",
      "icon":FaIcon(FontAwesomeIcons.facebook)
    },
      {
        "name": "Twitter",
        "icon":FaIcon(FontAwesomeIcons.facebook)
      }];
    return GestureDetector(
      onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ContactAvatar(widget.contact, 50),
              SizedBox(width: 10,),
              Container(
                width:110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Text(widget.contact.info!.displayName.toString(),style: TextStyle(color: Colors.black,fontFamily: "Cairo" , fontSize: widget.contact.info!.displayName.length >32?12:15 , fontWeight: FontWeight.w400  ),overflow: TextOverflow.visible, ),

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
        ),
        body:SingleChildScrollView(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: SuggestionsList.isEmpty?0:MediaQuery.of(context).size.height*0.24,
                color: Colors.black26.withOpacity(0.10),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0 , horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Suggestions" , style: TextStyle(fontFamily: "Cairo" ,color: Colors.black),),

                      ],),
                  ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: GridView.count(
                        physics: BouncingScrollPhysics(),
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 15,
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          children: List.generate(SuggestionsList.length, (index) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(radius: 32,backgroundImage: NetworkImage(SuggestionsList[index]["ProfileIMG"].replaceAll('"', '')),),
                              SizedBox(height: 5,),
                              Text(SuggestionsList[index]["Name"].replaceAll('"', '')),
                            ],))
                      ),
                    )
                    ],),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0,bottom: 25),
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.90,
                      height: 30,
                      decoration: BoxDecoration(
                         color: HexColor("#D6D6D6").withOpacity(0.40),
                          borderRadius: BorderRadius.all(Radius.circular(8)),

                      ),
                      child:Padding(
                        padding: const EdgeInsets.only(left:30.0,),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search",
                            border:InputBorder.none,
                          ),
                          controller: SearchController,
                          onChanged: (value) {
                            setState(() {
                              SearchFbList(SearchController);
                            });

                            if (SearchController.text.isEmpty) {
                              isSearching = false;
                            } else {
                              isSearching = true;}},
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: Colors.black)
                      ),
                      child:Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: DropdownButton(
                          value: SuggestionsItemList[SuggestionsItemIndex],
                          items: SuggestionsItemList.map((value) {
                            count++;
                            return DropdownMenuItem(
                                value:value,
                                child: Container(
                                  height: 25,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SuggestionsItemList[count-1]["icon"],
                                        SizedBox(width: 5,),
                                        Text(SuggestionsItemList[count-1]["name"]),
                                      ]),
                                ));
                          }).toList(),
                          onChanged: (value) {
                            setState((){
                              SuggestionsItemIndex = SuggestionsItemList.indexOf(value);
                            });

                          },

                        ),
                      ),
                    ),
                  ],),
              ),
              ListView.builder(
                  physics:BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:isSearching==false?fbList.length:FilterdfbList.length,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ListTile(
                          title: Text( isSearching ==false?fbList[index]["UserName"].replaceAll('"',''):FilterdfbList[index]["UserName"].replaceAll('"','')),
                          leading: CircleAvatar(radius: 40,backgroundImage:NetworkImage(isSearching ==false?fbList[index]["ProfileIMG"].replaceAll('"',''):FilterdfbList[index]["ProfileIMG"].replaceAll('"','') ,),
                          )),
                    );
                  }),


            ],
          ),
        ),
      ),
    );
  }
}
List SuggestionsList =[];

void GetSuggestionsList (AppContact contact){
  print("Suggestions Start");
  SuggestionsList.clear();
  String ContactName = "${contact.info?.name.first} ${contact.info?.name.middle} ${contact.info?.name.last}";
  fbList.forEach((element) {
    if(StringSimilarity.compareTwoStrings(element["UserName"], ContactName)>=0.25)
      {
        SuggestionsList.add({
          "Name":element["UserName"],
          "ProfileIMG":element["ProfileIMG"],
        });
      }
  });
}
List FilterdfbList =[];

void SearchFbList(TextEditingController SearchController){
  FilterdfbList.clear();
  FilterdfbList.addAll(fbList);
  FilterdfbList.retainWhere((contact){
    String searchTerm = SearchController.text.toLowerCase();
    String contactName = contact["UserName"].replaceAll('"','').toLowerCase();
    return contactName.contains(searchTerm);
  });
}