import 'package:flutter/material.dart';

class MessageProgressCircularWidget extends StatelessWidget {
  final double downloadProgress;
  final VoidCallback onCancel;

  const MessageProgressCircularWidget({
    super.key,
    required this.downloadProgress,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCancel,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration:
            const BoxDecoration(color: Colors.blueGrey, shape: BoxShape.circle),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.orangeAccent,
              backgroundColor: Colors.blueGrey,

              ///-0.1 means the download is just start without any progress but it already started!!!
              value: downloadProgress == -0.1 ? null : downloadProgress,
            ),
            const Icon(
              Icons.close,
            )
          ],
        ),
      ),
    );
  }
}
