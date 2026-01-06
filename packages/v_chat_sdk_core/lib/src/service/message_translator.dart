
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageTranslator {


  ///singleton
  MessageTranslator._();

  static final instance = MessageTranslator._();


  Future<String?> getRoomTr(String roomId) async {
    return null;
    // final room =
    //     await VChatController.I.nativeApi.local.room.getRoomById(roomId);
    // if (room == null) return null;
    // return room.transTo;
  }
}
