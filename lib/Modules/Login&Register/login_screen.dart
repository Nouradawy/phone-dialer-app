import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dialer_app/Components/components.dart';
import 'package:dialer_app/Components/constants.dart';
import 'package:dialer_app/Modules/Login&Register/register_screen.dart';
import 'package:dialer_app/Network/Local/cache_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home.dart';
import 'Cubit/cubit.dart';
import 'Cubit/states.dart';



class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var EmailController = TextEditingController();
  var PasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create:(BuildContext context)=>LoginCubit(),
        child:BlocConsumer<LoginCubit , LoginCubitStates>(
          listener:(context , state) {
            if(state is DialerLoginSuccessState){
              CacheHelper.saveData(key: "token", value: state.token);


            }
            if(state is DialerLoginSuccessState)
            {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder:(BuildContext context) => BlocProvider.value(
                      value:LoginCubit()..GetChatContacts(),
                      child: Home())),
                      (Route<dynamic>route) => false);
            }

            if(state is DialerLoginErrorState){
              showToast(
                text: state.error,
                state:ToastStates.WARNING,
              );
            }
          },
          builder:(context , state) {
            LoginCubit Cubit = LoginCubit.get(context);
            return GestureDetector(
              onTap:()=>FocusScope.of(context).unfocus(),
              child: Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LOGIN',
                              style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.black),),
                            Text('login now to see latest news',
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color:Colors.grey,
                              ),),
                            const SizedBox(height: 30.0,),
                            defaultTextForm(context,
                              controller: EmailController,
                              keyBoardType: TextInputType.emailAddress,
                              text: 'Email address',
                              onTap: (){},
                              preIcon: Icons.email,
                            ),
                            const SizedBox(height: 15.0,),
                            defaultTextForm(
                              context,
                              Cubit: Cubit,
                              controller: PasswordController,
                              IsPassword: true,
                              keyBoardType: TextInputType.text,
                              text: 'Password',
                              validate: (String? value) {
                                value!.isEmpty ? 'Password is too short' : null;
                              },
                              onTap: () {},
                              preIcon: Icons.lock_open_outlined,
                            ),
                            const SizedBox(height: 30.0,),
                            ConditionalBuilder(
                              builder: (BuildContext context) => defaultButton(
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    LoginCubit.get(context).userLogin(
                                        email: EmailController.text,
                                        password: PasswordController.text);
                                  }
                                },
                                text: 'login',
                                isUpperCase: true,
                              ),
                              condition: state is! DialerLoginLoadingState,
                              fallback: (context) =>
                                  Center(child: CircularProgressIndicator()),
                            ),

                            const SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Don\'t have an account ?'),
                                TextButton(onPressed: (){
                                  Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BlocProvider.value(
                                              value: LoginCubit(),
                                              child: DialerRegisterScreen()),
                                    ),
                                  );
                                }, child: const Text('Register Now')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        )
    );
  }
}