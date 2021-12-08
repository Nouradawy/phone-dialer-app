
class NativePhoneEvent {
  /// Underlying call ID assigned by the device.
  /// android: always null
  /// ios: a uuid
  /// others: ??
  String? state;

  /// If available, the phone number being dialed.
  String? phoneNumber;

  /// The type of call event.
  String? type;

  NativePhoneEvent(Map<String,dynamic>json){
    state = json["state"];
    phoneNumber = json["phoneNumber"];
    type = json["type"];
  }


}

//
// enum PhoneStates {
//   New,
//   ringing,
//   dialing,
//   active,
//   holding,
//   disconnected,
//   disconnecting,
//   connecting,
//   SelectPhoneAccount,
//   AudioProcessing
//
// }
//
// enum PhoneType{
//   inbound,
//   outbound,
//   missedcall,
//   cancelled
// }