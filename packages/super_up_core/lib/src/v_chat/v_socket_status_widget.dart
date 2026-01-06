// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VSocketStatusWidget extends StatefulWidget {
  final BoxDecoration decoration;
  final EdgeInsets padding;
  final String connectingLabel;
  final Duration delay;
  final IconData? icon;

  const VSocketStatusWidget({
    super.key,
    this.decoration = const BoxDecoration(color: Colors.red),
    this.padding = const EdgeInsets.all(5),
    required this.connectingLabel,
    this.delay = const Duration(seconds: 5),
    this.icon,
  });

  @override
  State<VSocketStatusWidget> createState() => _VSocketStatusWidgetState();
}

class _VSocketStatusWidgetState extends State<VSocketStatusWidget>
    with SingleTickerProviderStateMixin {
  final _socket = VChatController.I.nativeApi.remote.socketIo;
  bool show = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _delay();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return const SizedBox.shrink();
    }
    return StreamBuilder<VSocketStatusEvent>(
      stream: VChatController.I.nativeApi.streams.socketStatusStream,
      initialData: VSocketStatusEvent(
        isConnected: _socket.isConnected,
        connectTimes: 0,
      ),
      builder: (context, snapshot) {
        final isConnected = snapshot.data?.isConnected ?? false;
        
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
          child: !isConnected
              ? Container(
                  key: const ValueKey('disconnected'),
                  decoration: widget.decoration,
                  child: Padding(
                    padding: widget.padding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) => Opacity(
                              opacity: _pulseAnimation.value,
                              child: Icon(
                                widget.icon,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            widget.connectingLabel,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('connected')),
        );
      },
    );
  }

  Future<void> _delay() async {
    await Future.delayed(widget.delay);
    if (mounted) {
      setState(() {
        show = true;
      });
    }
  }
}
