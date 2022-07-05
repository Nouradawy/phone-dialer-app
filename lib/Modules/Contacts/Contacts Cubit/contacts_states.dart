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

class DropDownDisplayName extends PhoneContactStates{}

class DropDownPhonaticName extends PhoneContactStates{}

class SideMenuUpdated extends PhoneContactStates{}

class TextFormInitialize extends PhoneContactStates{}
class PhoneNumberAddState extends PhoneContactStates{}
class EmailAddressAddSuccessState extends PhoneContactStates{}
class AddressAddSuccessState extends PhoneContactStates{}
class EventAddSuccessState extends PhoneContactStates{}
class ChatAddSuccessState extends PhoneContactStates{}

class ContactUpdateSucessState extends PhoneContactStates{}
class Contactstatechange extends PhoneContactStates{}
class isShowenSuccessState extends PhoneContactStates{}
class dailerInputSuccessstate extends PhoneContactStates{}