import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_chat_message_page/src/theme/theme.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class LinkViewerWidget extends StatefulWidget {
  final VLinkPreviewData? data;
  final bool isMeSender;

  const LinkViewerWidget({
    super.key,
    required this.data,
    required this.isMeSender,
  });

  @override
  State<LinkViewerWidget> createState() => _LinkViewerWidgetState();
}

class _LinkViewerWidgetState extends State<LinkViewerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null) return const SizedBox.shrink();
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
        HapticFeedback.selectionClick();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTap: () async {
        HapticFeedback.mediumImpact();
        await launchUrl(
          Uri.parse(widget.data!.link),
          mode: LaunchMode.externalApplication,
        );
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(
            maxWidth: 250,
          ),
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: widget.isMeSender
                ? context.vMessageTheme.senderReplyColor
                : context.vMessageTheme.receiverReplyColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 3,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGreen,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _getImage(),
                  if (widget.data!.image != null) const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data!.title,
                          style: const TextStyle(
                            color: CupertinoColors.systemGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.data!.description,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getImage() {
    if (widget.data!.image == null) {
      return const SizedBox.shrink();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: widget.data!.image!,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 60,
          height: 60,
          color: Colors.grey.shade200,
          child: const Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 60,
          height: 60,
          color: Colors.grey.shade200,
          child: const Icon(Icons.link, size: 24),
        ),
      ),
    );
  }
}
