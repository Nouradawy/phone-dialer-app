
import 'package:dialer_app/Components/components.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Layout/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/cubit.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/states.dart';
import 'package:dialer_app/Modules/profile/Profile%20Cubit/profile_cubit.dart';
import 'package:dialer_app/Network/Local/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Profile Cubit/profile_states.dart';


class EditProfileScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var Cubit = ProfileCubit.get(context);
    var NameController =TextEditingController();
    var BioController = TextEditingController();
    var phoneController = TextEditingController();
    var emailController = TextEditingController();
    Cubit.ProfileImageURL = Cubit.ProfileImageURL==null?Cubit.CurrentUser[0].image:Cubit.ProfileImageURL;
    Cubit.CoverImageURL= Cubit.CoverImageURL==null?Cubit.CurrentUser[0].cover:Cubit.CoverImageURL;


    return BlocProvider.value(
      value:ProfileCubit.get(context)..GetChatContacts(),
      child: BlocConsumer<ProfileCubit,ProfileStates>(
        listener: (contaxt,state){

          if(state is! UpdateUserInfoLoading)
          {
            NameController.text = ProfileCubit.get(context).CurrentUser[0].name!;
            BioController.text =  ProfileCubit.get(context).CurrentUser[0].bio!;

          }
        },
        builder:(context,state)=> Builder(
          builder:(index) {

            return Scaffold(
            appBar:defaultAppBar(
                context: context,
                title:"Edit Profile",
                actions: [
                  TextButton(onPressed: (){
                    UserProfilePic = ProfileCubit.get(context).CurrentUser[0].image.toString();
                    Cubit.updateUser(name: NameController.text , bio: BioController.text);

                  },
                      child: Text("UPDATE",
                        style: TextStyle(color:Colors.white)
                        ,)),
                  SizedBox(width:5.0),

                ]
            ),
            body:Padding(
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
                              child:Image(image: Cubit.CoverImage == null ? NetworkImage(ProfileCubit.get(context).CurrentUser[0].cover.toString()) : ImageSwap(Cubit.CoverImage),
                                fit: BoxFit.cover,
                                height: 170,
                                width: double.infinity,
                              )
                          ),
                        ),
                      ),
                      Container(
                        height:230,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: IconButton(onPressed:(){
                              Cubit.CoverImagePicker();
                            },icon:Icon(Icons.edit,),color: Colors.white,),
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
                            backgroundImage: Cubit.profileImage == null ? NetworkImage(ProfileCubit.get(context).CurrentUser[0].image.toString()) : ImageSwap(Cubit.profileImage),
                          ),
                        ),
                      ),
                      IconButton(onPressed:(){
                        Cubit.ProfileImagePicker();
                      },icon:Icon(Icons.edit,),color: Colors.white,),
                    ],
                  ),
                  Container(
                    width: 160,
                    child: TextFormField(
                      controller: NameController,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black),
                      decoration: InputDecoration.collapsed(
                        border:InputBorder.none,
                        hintText: NameController.text.toString(),
                      ),
                    ),
                  ),
                  Container(
                    width: 230,
                    child: TextFormField(
                      controller: BioController,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption,
                      maxLines: 3,
                      decoration: InputDecoration.collapsed(
                        border:InputBorder.none,
                        hintText: BioController.text.toString(),
                      ),
                    ),
                  ),


                ],
              ),
            ),

          );
          },
        ),
      ),
    );
  }
  ImageProvider<Object> ImageSwap(profileImage) => FileImage(profileImage);
}