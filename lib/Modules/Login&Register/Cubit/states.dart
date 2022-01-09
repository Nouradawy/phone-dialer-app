abstract class LoginCubitStates {}
class DialerLoginInitialState extends LoginCubitStates{}

class DialerLoginLoadingState extends LoginCubitStates{}

class DialerLoginSuccessState extends LoginCubitStates{
  final String token;
  DialerLoginSuccessState(this.token);
}

class DialerLoginErrorState extends LoginCubitStates{
  final String error;
  DialerLoginErrorState(this.error);
}

class DialerIsPasswordState extends LoginCubitStates{}

class DialerLoadingRegisterUserState extends LoginCubitStates{
  final String Textstate;
  DialerLoadingRegisterUserState(this.Textstate);
}
class DialerSuccessRegisterUserState extends LoginCubitStates{
  final String Textstate;
  DialerSuccessRegisterUserState(this.Textstate);
}
class DialerErrorRegisterUserState extends LoginCubitStates{}

class DialerLoadingUserCreationState extends LoginCubitStates{}
class DialerSuccessUserCreationState extends LoginCubitStates{
  final String Textstate;
  DialerSuccessUserCreationState(this.Textstate);
}
class DialerErrorUserCreationState extends LoginCubitStates{}

class GetChatContactsLoadingState extends LoginCubitStates{}
class GetChatContactsSuccessState extends LoginCubitStates{}
class GetChatContactsErrorState extends LoginCubitStates{
  final String error;
  GetChatContactsErrorState(this.error);
}

class SocialUpdateUserLoadingState extends LoginCubitStates{}

class SocialUpdateUserSuccessState extends LoginCubitStates{}

class SocialUpdateUserErrorState extends LoginCubitStates{
  final String error;
  SocialUpdateUserErrorState(this.error);
}

class SocialProfileImagePickedSuccessState extends LoginCubitStates {}

class SocialProfileImagePickeedErrorState extends LoginCubitStates {}

class SocialUploadImagePickedSuccessState extends LoginCubitStates {}

class SocialUploadImageErrorState extends LoginCubitStates {}
class NewMessageRecived extends LoginCubitStates {}
