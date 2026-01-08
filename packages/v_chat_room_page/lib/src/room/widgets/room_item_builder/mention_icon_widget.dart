import 'package:flutter/material.dart';

class MentionIcon extends StatefulWidget {
  const MentionIcon({
    super.key,
    required this.mentionsCount,
    required this.isMeSender,
  });

  final int mentionsCount;
  final bool isMeSender;

  @override
  State<MentionIcon> createState() => _MentionIconState();
}

class _MentionIconState extends State<MentionIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    if (widget.mentionsCount > 0 && !widget.isMeSender) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(MentionIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mentionsCount != widget.mentionsCount) {
      if (widget.mentionsCount > 0 && !widget.isMeSender) {
        _controller.reset();
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mentionsCount == 0 || widget.isMeSender) {
      return const SizedBox.shrink();
    }
    
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.green,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.alternate_email,
                color: Colors.green,
                size: 12,
              ),
              const SizedBox(width: 2),
              Text(
                '${widget.mentionsCount}',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
