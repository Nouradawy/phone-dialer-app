
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dialer_app/Components/components.dart';
import 'package:dialer_app/Modules/Login&Register/Cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home.dart';
import 'Cubit/states.dart';

class DialerRegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var formKey = GlobalKey<FormState>();
    var namecontroller = TextEditingController();
    var phonecontroller = TextEditingController();
    var emailcontroller = TextEditingController();
    var passwordcontroller = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Account Register"),),
        body:BlocConsumer<LoginCubit,LoginCubitStates>(
          listener: (context, state) {
            if(state is DialerLoginSuccessState)
            {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder:(BuildContext context) => Home()),
                      (Route<dynamic>route) => false);
            }
          },
          builder: (context , state)
          {
            return GestureDetector(
              onTap:()=>FocusScope.of(context).unfocus(),
              child: Center(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('REGISTER',
                            style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.black),),
                          Text('Register and communicate with your friends.',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color:Colors.grey,
                            ),),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultTextForm(
                            context,
                            controller: namecontroller,
                            keyBoardType: TextInputType.text,
                            text: 'name',
                            onTap: (){},
                            validate: (String? value){
                              return value!.isEmpty? "Name must not be Empty": null;
                            },
                            preIcon: Icons.person,
                          ),
                          const SizedBox(height: 15,),
                          defaultTextForm(
                            context,
                            controller: phonecontroller,
                            keyBoardType: TextInputType.phone,
                            text: 'Phone number',
                            onTap: (){},
                            validate: (String? value){
                              return value!.isEmpty? "Phone must not be Empty": null;
                            },
                            preIcon: Icons.phone,
                          ),const SizedBox(height: 15,),
                          defaultTextForm(
                            context,
                            controller: emailcontroller,
                            keyBoardType: TextInputType.emailAddress,
                            text: 'EmailAddress',
                            onTap: (){},
                            validate: (String? value){
                              return value!.isEmpty? "emailAddress must not be Empty": null;
                            },
                            preIcon: Icons.email,
                          ),const SizedBox(height: 15,),
                          defaultTextForm(
                            context,
                            Cubit: LoginCubit.get(context),
                            controller: passwordcontroller,
                            keyBoardType: TextInputType.text,
                            IsPassword: true,
                            text: 'Password',
                            onTap: (){},
                            validate: (String? value) =>value!.isEmpty? "Password must not be Empty": null,
                            preIcon: Icons.vpn_key,
                          ),
                          SizedBox(height: 25,),
                          ConditionalBuilder(
                              condition: state is! DialerLoadingRegisterUserState,
                              builder: (BuildContext context) =>defaultButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    LoginCubit.get(context).RegisterUser(
                                        name: namecontroller.text,
                                        phone: phonecontroller.text,
                                        email: emailcontroller.text,
                                        password: passwordcontroller.text);
                                  }
                                },
                                Title: 'Submit',
                                isUpperCase: true,
                              ),
                              fallback: (context)=> Center(
                                child: CircularProgressIndicator(),
                              )),
                          Center(child: Text(LoginCubit.get(context).Textstate)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }, )
    );
  }
}