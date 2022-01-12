
import 'package:dialer_app/Components/components.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:dialer_app/Modules/Chat/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_profile.dart';

class ProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocProvider.value(
      value:AppCubit()..GetChatContacts(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context , state) {},
        builder:(context , index) {
          var Cubit = AppCubit.get(context);
          return Builder(
            builder: (index) {
              return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(
                          height:230,
                          child: Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 7,
                                child:Image(image: NetworkImage(Cubit.CurrentUser[0].cover.toString()),
                                  fit: BoxFit.cover,
                                  height: 170,
                                  width: double.infinity,
                                )
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(Cubit.CurrentUser[0].image.toString()
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(Cubit.CurrentUser[0].name.toString(),
                        style:Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black)),
                    Text(Cubit.CurrentUser[0].bio.toString(),
                        style:Theme.of(context).textTheme.caption),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text("265",
                                      style:Theme.of(context).textTheme.subtitle2),
                                  Text("photos",
                                      style:Theme.of(context).textTheme.caption!.copyWith(color: Colors.black)),
                                ],
                              ),
                              onTap: (){},
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text("10k",
                                      style:Theme.of(context).textTheme.subtitle2),
                                  Text("Followers",
                                      style:Theme.of(context).textTheme.caption!.copyWith(color: Colors.black)),
                                ],
                              ),
                              onTap: (){},
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text("100",
                                      style:Theme.of(context).textTheme.subtitle2),
                                  Text("Likes",
                                      style:Theme.of(context).textTheme.caption!.copyWith(color: Colors.black)),
                                ],
                              ),
                              onTap: (){},
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text("100",
                                      style:Theme.of(context).textTheme.subtitle2),
                                  Text("posts",
                                      style:Theme.of(context).textTheme.caption!.copyWith(color: Colors.black)),
                                ],
                              ),
                              onTap: (){},
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: (){}, child: Text("Add Photos"))),
                        OutlinedButton(onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>BlocProvider.value(
                              value:AppCubit()..GetChatContacts(),
                              child: EditProfileScreen())));
                        }, child: Icon(Icons.edit,size:16.0)),
                      ],
                    ),

                  ],
                ),
              ),
        );
            }
          );
        },
      ),
    );



  }
}