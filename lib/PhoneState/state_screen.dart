

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_state/extensions_static.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:flutter_phone_state/phone_event.dart';
import 'package:hexcolor/hexcolor.dart';


class PhoneStateScreen extends StatefulWidget {
  const PhoneStateScreen({Key? key}) : super(key: key);

  @override
  _PhoneStateScreenState createState() => _PhoneStateScreenState();
}

class _PhoneStateScreenState extends State<PhoneStateScreen> {
  // List<RawPhoneEvent>? _rawEvents;
  List<PhoneCallEvent>? _phoneEvents;

  @override
  void initState() {
    super.initState();
    _phoneEvents = _accumulate(FlutterPhoneState.phoneCallEvents);
    // _rawEvents = _accumulate(FlutterPhoneState.rawPhoneEvents);
  }

  List<R> _accumulate<R>(Stream<R> input) {
    final items = <R>[];
    input.forEach((item) {
      if (item != null) {
        setState(() {
          items.add(item);
        });
      }
    });
    return items;
  }

  // Iterable<PhoneCall> get _completedCalls =>
  //     Map.fromEntries(_phoneEvents.reversed.map((PhoneCallEvent event) {
  //       return MapEntry(event.call.id, event.call);
  //     })).values.where((c) => c.isComplete).toList();


  Widget build(BuildContext context) {
    String name ="Ahmed Mohammed";
    return Scaffold(
      backgroundColor: HexColor("#010A0A"),
      body: Column(
        children: [
          Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 220,),
              Stack(
                  alignment: AlignmentDirectional.center,
                  children:[
                    Container(
                      child: CircleAvatar(backgroundColor: HexColor("#545454"),
                        radius: 60,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: HexColor("#F8F8F8"),
                        ),
                      ),
                    ),
                    Icon(Icons.person,
                      color: HexColor("#D1D1D1"),
                      size: 70,),
                  ]),

            ],
          ),
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Images/blue purple wave.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment:AlignmentDirectional.topEnd,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text("Ahmed Mohammed".toUpperCase(),style: TextStyle(
                                fontFamily: "ZenKurenaido-Regular",
                                color: HexColor("#F5F5F5"),
                                fontSize: 25,
                              )),
                            ),
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:1.3),
                                  child: CircleAvatar(backgroundColor: HexColor("#23DB54"),radius: 5,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0),
                                  child: Text("Avilable".toUpperCase(),style: TextStyle(
                                    fontFamily: "ZenKurenaido-Regular",
                                    color: HexColor("#00B3A6"),
                                    fontSize: 10,
                                  )),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                  ],

                ),
                Column(children: [
                  Text("+201020007093",style: TextStyle(
                    fontFamily: "ZenKurenaido-Regular",
                    color: HexColor("#F5F5F5"),
                    fontSize: 25,
                  )),
                  SizedBox(height: 10),
                  Text("Ringing".toUpperCase(),style: TextStyle(
                      fontFamily: "ZenKurenaido-Regular",
                      color: HexColor("#26BF5E"),
                      fontSize: 23)),
                ],),
              ],
            ),

          ),


        ]
      ),
    );
  }

  Widget GetPhoneNumber({required final PhoneCall phoneCall}) {
    return Column(
      children: [
        Text("+${phoneCall.phoneNumber ?? "Unknown number"}",style: TextStyle(
          fontFamily: "ZenKurenaido-Regular",
          color: HexColor("#F5F5F5"),
          fontSize: 25,
        )),
        Text("${value(phoneCall.status)}",style: TextStyle(
    fontFamily: "ZenKurenaido-Regular",
        color: HexColor("#26BF5E"),
        fontSize: 23))

      ],
    );
  }

}

// class _CallCard extends StatelessWidget {
//   final PhoneCall? phoneCall;
//
//   const _CallCard({Key? key, this.phoneCall}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Text("+${phoneCall?.phoneNumber ?? "Unknown number"}: ${value(phoneCall?.status)}");
//   }
// }


