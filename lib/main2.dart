import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';

///TOP-LEVEL FUNCTION PROVIDED FOR WORK MANAGER AS CALLBACK


void main() {
  runApp(MyApp());

}

/// example widget for call log plugin
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];

  @override
  Widget build(BuildContext context) {
    const TextStyle mono = TextStyle(fontFamily: 'monospace');
    final List<Widget> children = <Widget>[];
    for (CallLogEntry entry in _callLogEntries) {
      children.add(
        Column(
          children: <Widget>[
            const Divider(),
            Text('F. NUMBER  : ${entry.formattedNumber}', style: mono),
            Text('C.M. NUMBER: ${entry.cachedMatchedNumber}', style: mono),
            Text('NUMBER     : ${entry.number}', style: mono),
            Text('NAME       : ${entry.name}', style: mono),
            Text('TYPE       : ${entry.callType}', style: mono),
            Text('DATE       : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)}',
                style: mono),
            Text('DURATION   : ${entry.duration}', style: mono),
            Text('ACCOUNT ID : ${entry.phoneAccountId}', style: mono),
            Text('SIM NAME   : ${entry.simDisplayName}', style: mono),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('call_log example')),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final Iterable<CallLogEntry> result = await CallLog.query();
                      setState(() {
                        _callLogEntries = result;
                      });
                    },
                    child: const Text('Get all'),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    child: const Text('Get all in background'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: children),
              ),
            ],
          ),
        ),
      ),
    );
  }
}