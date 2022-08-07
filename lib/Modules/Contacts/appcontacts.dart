
import 'dart:ui';

import 'package:azlistview/azlistview.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';

class AppContact extends ISuspensionBean {
  final Color? color;
  String? tag;
  Contact? info;
  String? FBimgURL;
  List<Contact>? GooglePhones;
  List? Notes = <String>[''];



  AppContact({Key? key,
    this.color,
    this.info,
    this.tag,
    this.FBimgURL,
    this.GooglePhones,
    this.Notes,
  });





  @override
  String getSuspensionTag() => tag!;
}