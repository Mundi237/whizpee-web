import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageDownloaderWidget extends StatelessWidget {
  final VBaseMessage message;

  const MessageDownloaderWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        VDownloaderService.instance.addToMobileQueue(message);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration:
            const BoxDecoration(color: Colors.blueGrey, shape: BoxShape.circle),
        child: const Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.download,
            )
          ],
        ),
      ),
    );
  }
}
