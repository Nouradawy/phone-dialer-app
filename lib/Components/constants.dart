import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialer_app/Models/user_model.dart';
import 'package:dialer_app/Modules/Chat/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Chat/Cubit/states.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/states.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart';

class MyBlocObserver extends BlocObserver {

  void updateUserState({
    required bool? isOnline,
    required Timestamp? date,
  }){


    FirebaseFirestore.instance.collection("Users").doc(token).update({
      "IsOnline":  isOnline,
      "LastSeen": date,
    }).catchError((onError)
    {
      print("Update User State Error :"  +onError.toString());
    }
    );
  }
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if(bloc.state is ChatAppCubitInitialState)
      {
       updateUserState(isOnline: true,
       date:Timestamp.now(),
       );
      }
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if(bloc.state is ChatAppCubitInitialState)
    {
      updateUserState(isOnline: false,
        date:Timestamp.now(),
      );
    }
    print('onClose -- ${bloc.runtimeType}');
  }
}
String phonenum = "Empty";
String? token ;


class BlendMask extends SingleChildRenderObjectWidget {
  final BlendMode blendMode;
  final double opacity;

  BlendMask({
    required this.blendMode,
    this.opacity = 1.0,
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(context) {
    return RenderBlendMask(blendMode, opacity);
  }

  @override
  void updateRenderObject(BuildContext context, RenderBlendMask renderObject) {
    renderObject.blendMode = blendMode;
    renderObject.opacity = opacity;
  }
}

class RenderBlendMask extends RenderProxyBox {
  BlendMode blendMode;
  double opacity;

  RenderBlendMask(this.blendMode, this.opacity);

  @override
  void paint(context, offset) {
    context.canvas.saveLayer(
      offset & size,
      Paint()
        ..blendMode = blendMode
        ..color = Color.fromARGB((opacity * 255).round(), 255, 255, 255),
    );

    super.paint(context, offset);

    context.canvas.restore();
  }
}



