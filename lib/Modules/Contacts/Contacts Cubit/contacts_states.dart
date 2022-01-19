import 'package:dialer_app/Modules/Contacts/appcontacts.dart';

abstract class PhoneContactStates {}

class ContactsInitialState extends PhoneContactStates{}

class RawContactsLoadingState extends PhoneContactStates{}
class RawContactsSuccessState extends PhoneContactStates{
}
class PhoneLogsExtractionInitiating extends PhoneContactStates{}
class PhoneLogsExtractionSuccessful extends PhoneContactStates{}
class PhoneLogsExtractionError extends PhoneContactStates{}


class SearchingContactsStarted extends PhoneContactStates{}
class SearchContactsFinished extends PhoneContactStates{}


class dialPadSearchLoadingState extends PhoneContactStates{}
class dialPadSearchSuccessState extends PhoneContactStates{}