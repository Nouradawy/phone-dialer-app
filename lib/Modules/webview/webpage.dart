
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialer_app/Modules/Contacts/Contacts%20Cubit/contacts_cubit.dart';
import 'package:dialer_app/Modules/Contacts/appcontacts.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';



class Webpage extends StatefulWidget {

  Webpage(this.contact);
  final AppContact contact;

  @override
  _WebpageState createState() => _WebpageState();
}

class _WebpageState extends State<Webpage> {
  late WebViewController controller;
  var URLaddress = TextEditingController();
  String? Url;
  bool? IsFinished= true;
  bool? FirstTime=true;

  String? fbClassName;
  String? fbProfileLink;
  String? FriendsCountInSinglePage;
  String? TotalFriendsCount;
  String? moreButton;
  int? pagesCount;
  String? fbProfileIMG;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        leadingWidth: 25,
        toolbarHeight: 70,
        title: TextField(
          onSubmitted: (url){setState(() {
            if(url.contains("https://")) {
                    controller.loadUrl('$url');
                  }else {
              controller.loadUrl('https://$url');
            }
                });

          },
          controller:URLaddress,),
        actions: <Widget>[
      Row(
      children: <Widget>[
        Container(
        width: 20,
        child: IconButton(
          iconSize: 15,
          splashRadius: 15,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed:() async {
            if ( await controller.canGoBack()) {
              await controller.goBack();
            } else {
              // ignore: deprecated_member_use
              Scaffold.of(context).showSnackBar(
                const SnackBar(content: Text('No back history item')),
              );
            }
          },
        ),
      ),
      Container(
        width: 25,
        child: IconButton(
          iconSize: 15,
          splashRadius: 15,
          icon: const Icon(Icons.arrow_forward_ios,),
          onPressed:()async {
            if (await controller.canGoForward()) {
              await controller.goForward();
            } else {
              // ignore: deprecated_member_use
              Scaffold.of(context).showSnackBar(
                const SnackBar(content: Text('No forward history item')),
              );
            }
          },
        ),
      ),
      Container(
        alignment: AlignmentDirectional.center,
        width: 25,
        child: IconButton(
          iconSize: 15,
          splashRadius: 15,
          icon: const Icon(Icons.replay),
          onPressed: () {
            controller.reload();
          },
        ),
      )])
        ],
      ),

      body: Stack(
        children: [
          WebView(
            javascriptMode: SignedIN(),
            initialUrl: 'https://m.facebook.com/login.php?',
            onWebViewCreated:(controller) async {
              this.controller = controller;
            } ,
            onPageStarted: (url){
              print("page started loading $url");
              URLaddress.text = url;

            },
            onPageFinished: (url) async {
              print("page Finished loading $url");
              URLaddress.text = url;
              if(FirstTime == true)
              {
                await Future.delayed(Duration(seconds: 5));
                await controller.loadUrl('https://mbasic.facebook.com/friends/center/friends/?mff_nav=1');
                TotalFriendsCount = await controller.runJavascriptReturningResult(
                    "document.getElementById('friends_center_main').firstChild.textContent;");
                TotalFriendsCount =
                    TotalFriendsCount?.replaceAll(' Friends', '')
                        .replaceAll('"', '');
                print(TotalFriendsCount);
                fbClassName = await controller.runJavascriptReturningResult("document.querySelectorAll('table')[1].parentElement.className");
                FriendsCountInSinglePage =
                    await controller.runJavascriptReturningResult(
                        "document.getElementsByClassName($fbClassName).length;");
                pagesCount = (int.parse(TotalFriendsCount!) /
                        int.parse(FriendsCountInSinglePage!))
                    .truncate();
                print("pages count" + pagesCount.toString());
                FirstTime = false;
              }

              await Future.delayed(Duration(seconds: 2));
              String ScrollH = await controller.runJavascriptReturningResult("document.body.scrollHeight");
              controller.scrollTo(0, int.parse(ScrollH));
              await Future.delayed(Duration(microseconds: 500));
              faceScrap(controller, pagesCount  ,moreButton ,fbClassName , FriendsCountInSinglePage , fbProfileLink ,fbProfileIMG ) ;

            },
          ),
          InkWell(
              onTap: (){
                CookieManager().clearCookies();
              },
              child: ContactAvatar(widget.contact))
        ],
      ),
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     UpdateProfileButton(widget.contact),
      //     UpdateContactAvatar(widget.contact),
      //   ],
      // ),

    );
  }

  CircleAvatar ContactAvatar(AppContact contact) {

    if(contact.info!.thumbnail != null)
    {return CircleAvatar(radius: 30,backgroundImage: MemoryImage(widget.contact.info!.thumbnail!),);} else{
      if(contact.FBimgURL?.isNotEmpty ==true)
        {
          return CircleAvatar(radius: 30,backgroundImage: CachedNetworkImageProvider(
            contact.FBimgURL.toString(),
          ),);
        }
      else {
        return CircleAvatar(
          radius: 30,
          child: Text(
            contact.info!.displayName[0].toString(),
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    }

  }

  JavascriptMode SignedIN() {
    return URLaddress.text.contains("login")?JavascriptMode.disabled:JavascriptMode.unrestricted;
    // return JavascriptMode.unrestricted;
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  // Widget UpdateProfileButton(AppContact contact) {
  //   return FutureBuilder<WebViewController>(
  //       future: _controller.future,
  //       builder: (BuildContext context,
  //           AsyncSnapshot<WebViewController> controller) {
  //         if (controller.hasData) {
  //           return FloatingActionButton.extended(
  //             onPressed: () async {
  //
  //               PhoneContactsCubit.get(context).faceProfilelink = (await controller.data!.currentUrl())!;
  //               // ignore: deprecated_member_use
  //               Scaffold.of(context).showSnackBar(
  //                 SnackBar(content: Text('User added success')),
  //               );
  //             },
  //             label: Text("add Username"),
  //             icon: const Icon(Icons.person),
  //           );
  //         }
  //         return Container();
  //       });
  // }
  // Widget UpdateContactAvatar(AppContact contact) {
  //   return FutureBuilder<WebViewController>(
  //       future: _controller.future,
  //       builder: (BuildContext context,
  //           AsyncSnapshot<WebViewController> controller) {
  //         if (controller.hasData) {
  //           return FloatingActionButton.extended(
  //             onPressed: () async {
  //               // contact.info?.photo  = (await controller.data!.currentUrl())!;
  //               contact.FBimgURL = (await controller.data!.currentUrl())!;
  //               // ignore: deprecated_member_use
  //               Scaffold.of(context).showSnackBar(
  //                 SnackBar(content: Text('profile added success')),
  //               );
  //             },
  //             label: Text("Add Photo"),
  //             icon: const Icon(Icons.photo),
  //           );
  //         }
  //         return Container();
  //       });
  // }
}


void faceScrap(controller , pagesCount  ,moreButton ,fbClassName , FriendsCountInSinglePage , fbProfileLink ,fbProfileIMG ) async{
  moreButton = await controller.runJavascriptReturningResult("document.getElementById('friends_center_main').lastElementChild.firstChild.href;");
  moreButton = moreButton?.replaceAll('"', '');
  print('$moreButton');
  fbClassName = await controller.runJavascriptReturningResult("document.querySelectorAll('table')[1].parentElement.className");
  FriendsCountInSinglePage = await controller.runJavascriptReturningResult("document.getElementsByClassName($fbClassName).length;");
  for (int i =0; i < int.parse(FriendsCountInSinglePage); i++) {

      fbProfileLink = await controller.runJavascriptReturningResult("document.getElementsByClassName($fbClassName)[$i].firstChild.firstChild.firstChild.lastChild.firstChild.href;");
      fbProfileIMG = await controller.runJavascriptReturningResult("document.getElementsByClassName($fbClassName)[$i].firstChild.firstChild.firstChild.firstChild.firstChild.src;");
      const start = "uid=";
      const end = "&redirectURI";
      final startIndex = fbProfileLink.indexOf(start);
      final endIndx = fbProfileLink.indexOf(end, startIndex + start.length);
      String UID = fbProfileLink.substring(startIndex + start.length, endIndx);
      fblist.add({"UID": UID, "ProfileIMG": fbProfileIMG});
    }

  const start = "ppk=";
  const end = "&tid";
  final startIndex = moreButton.indexOf(start);
  final endIndx = moreButton.indexOf(end, startIndex + start.length);
  String pagenum = moreButton.substring(startIndex + start.length, endIndx);
  print("pagenum = "+pagenum);

  if(int.parse(pagenum) < pagesCount)
    {await controller.loadUrl('$moreButton');
    }


  print(fblist);
  print("total list count "+fblist.length.toString());
  await Future.delayed(Duration(seconds: 2));
}

