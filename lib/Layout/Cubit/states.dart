abstract class AppStates {}

// class NativeStates extends AppStates{}
class AppInitialState extends AppStates{}

class AppgetContactsSuccess extends AppStates{}
class AppgetContactsError extends AppStates{}
class AppgetContactsLoading extends AppStates{}
class AppgetContactsThen extends AppStates{}
class Listupdate extends AppStates{}
class getIndexSuccess extends AppStates{}
class SearchLoadingState extends AppStates{}
class SearchSuccessState extends AppStates{}
class isShowenSuccessState extends AppStates{}
class dailerInputLoadingstate extends AppStates{}
class dailerInputSuccessstate extends AppStates{}
class PhoneloglistSuccess extends AppStates{}
class CallerIDSuccess extends AppStates{}
class TimerStarted extends AppStates{}
class ThemeUpdateState extends AppStates {}

class GetChatContactsLoadingState extends AppStates{}
class GetChatContactsSuccessState extends AppStates{}
class GetChatContactsErrorState extends AppStates{
  final String error;
  GetChatContactsErrorState(this.error);
}

class ColorPickerColorChange extends AppStates{}
class PopUpMenuUpdate extends AppStates{}
