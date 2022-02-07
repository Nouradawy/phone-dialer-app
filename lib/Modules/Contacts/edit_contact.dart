
import 'package:flutter/material.dart';

import 'appcontacts.dart';

class ContactEditor extends StatelessWidget {
ContactEditor(this.contact);
final AppContact contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.close),
        title: Center(child: Text("Edit Contact")),
        actions: [
          Icon(Icons.check),
        ],
      ),
    );
  }
}
