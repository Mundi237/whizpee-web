import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/src/models/call/call.dart';

class VBackgroundCallState{
  bool isInCall  = false;
  VCallDto? callDto;



}


// class VBackgroundCallModel extends ValueNotifier<VBackgroundCallState> {
//   VBackgroundCallModel() : super(VBackgroundCallState());
//
//
//   Future<void> stopCurrentCall() async {
//     value.callDto =null;
//     value.isInCall = false;
//   }
//
// }
