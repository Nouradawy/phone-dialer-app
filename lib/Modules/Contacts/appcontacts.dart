
import 'dart:ui';

import 'package:azlistview/azlistview.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';

class AppContact extends ISuspensionBean {
  final Color? color;
  String tag;
  Contact? info;

  AppContact({Key? key,
    this.color,
    this.info,
    required this.tag,
  });

  @override
  String getSuspensionTag() => tag;
}