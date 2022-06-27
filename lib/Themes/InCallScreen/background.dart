import 'package:flutter/cupertino.dart';

class InCallBackGround extends StatefulWidget {

  @override
  State<InCallBackGround> createState() => _InCallBackGroundState();
}

class _InCallBackGroundState extends State<InCallBackGround> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              "assets/Images/blue purple wave.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
