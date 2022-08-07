
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialer_app/Components/components.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Layout/Cubit/states.dart';
import 'package:dialer_app/Modules/Chat/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/states.dart';
import 'package:dialer_app/Modules/profile/Profile%20Cubit/profile_cubit.dart';
import 'package:dialer_app/Modules/profile/Profile%20Cubit/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Network/Local/shared_data.dart';
import '../Contacts/Contacts Cubit/contacts_cubit.dart';
import 'edit_profile.dart';

class ProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> CurrentUserStream = FirebaseFirestore.instance.collection('Users').doc(token).snapshots();
    return BlocProvider.value(
      value:LoginCubit(),
      child: Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: CurrentUserStream,
                  builder:(context,snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }
                    final data = snapshot..requireData;

                    LoginCubit.get(context).GetProvidersList();
                    return Column(
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
                                  child:Image(image: NetworkImage(data.data?["cover"]),
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
                                backgroundImage: NetworkImage(data.data?["image"]
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(data.data?["name"],
                          style:Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black)),
                      Text(data.data?["bio"],
                          style:Theme.of(context).textTheme.caption),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                child: Column(
                                  children: [
                                    FaIcon(FontAwesomeIcons.facebookSquare),
                                    Text(LoginCubit.get(context).FacebookLinked ==true?"Unlink Facebook":"Link Facebook",
                                        style:Theme.of(context).textTheme.caption!.copyWith(color: Colors.black)),
                                  ],
                                ),
                                onTap: (){
                                  LoginCubit.get(context).FacebookLinked?LoginCubit.get(context).UnlinkFacebookAccount():LoginCubit.get(context).LinkFacebookAccount();
                                },
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                child: Column(
                                  children: [
                                    FaIcon(FontAwesomeIcons.googlePlusG),
                                    Text(LoginCubit.get(context).GoogleLinked == true?"Unlink Google":"Link Google",
                                        style:Theme.of(context).textTheme.caption!.copyWith(color: Colors.black)),
                                  ],
                                ),
                                onTap: (){
                                  LoginCubit.get(context).GetProvidersList();
                                },
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
                                value:ProfileCubit.get(context),
                                child: EditProfileScreen())));
                          }, child: Icon(Icons.edit,size:16.0)),
                        ],
                      ),

                    ],
                  );
                  },
                ),
              ),
        ),
    );



  }
}