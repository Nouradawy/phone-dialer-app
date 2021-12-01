import 'extensions_static.dart';

class RawPhoneEvent {
  /// Underlying call ID assigned by the device.
  /// android: always null
  /// ios: a uuid
  /// others: ??
  String? state;

  /// If available, the phone number being dialed.
  String? phoneNumber;

  /// The type of call event.
  String? type;

  RawPhoneEvent.fromJson(Map<String,dynamic>json){
    state = json["state"];
    phoneNumber = json["phoneNumber"];
    type = json["type"];
  }

}

