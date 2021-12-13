import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:system_settings/system_settings.dart';

import '../../home.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).PermissionHandle();
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context , states){},
      builder: (context,states) {
        return Scaffold(
          appBar:AppBar(
            title:Text("DialerAPP"),
          ),
          body:Column(
            children: [
              Center(child: Text("Permissions")),
              SizedBox(height: 150,),
              Center(child: TextButton(onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) =>Home()));

              }, child: Text("Redirect to the APP"))),
              Center(child: TextButton(onPressed: (){
                SystemSettings.defaultApps();
              }, child: Text("Redirect to the APP"))),
            ],
          ),
        );
      }
    );
  }
}
