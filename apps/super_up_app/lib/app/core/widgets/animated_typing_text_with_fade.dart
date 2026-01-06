// Enhanced version with fade effect
import 'package:flutter/material.dart';

class AnimatedTypingTextWithFade extends StatefulWidget {
  final List<String> texts;
  final TextStyle? textStyle;
  final Duration typingSpeed;
  final Duration deletingSpeed;
  final Duration pauseDuration;
  final String cursor;
  final Curve curve;

  const AnimatedTypingTextWithFade({
    super.key,
    this.texts = const ['Welcome Back!', 'Please sign in to continue...'],
    this.textStyle,
    this.curve = Curves.easeInOut,
    this.typingSpeed= const Duration(milliseconds: 100),
    this.deletingSpeed= const Duration(milliseconds: 80),
    this.pauseDuration= const Duration(milliseconds: 1500),
    this.cursor= '▋',
  });

  @override
  State<AnimatedTypingTextWithFade> createState() =>
      _AnimatedTypingTextWithFadeState();
}

class _AnimatedTypingTextWithFadeState extends State<AnimatedTypingTextWithFade>
    with TickerProviderStateMixin {
  late AnimationController _cursorController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String _currentText = '';
  int _textIndex = 0;
  bool _isDeleting = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();

    // Setup cursor blinking animation
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    // Setup fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: widget.curve,
    ));

    _fadeController.forward();
    _startTypingAnimation();
  }

  @override
  void dispose() {
    _cursorController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startTypingAnimation() async {
    while (mounted) {
      if (_isPaused) {
        await Future.delayed(widget.pauseDuration);
        if (mounted) {
          await _fadeController.reverse();
          setState(() {
            _isPaused = false;
            _isDeleting = true;
          });
          await _fadeController.forward();
          continue;
        }
      }

      await Future.delayed(
        _isDeleting ? widget.deletingSpeed : widget.typingSpeed,
      );

      if (!mounted) return;

      setState(() {
        String targetText = widget.texts[_textIndex];

        if (_isDeleting) {
          if (_currentText.isEmpty) {
            _isDeleting = false;
            _textIndex = (_textIndex + 1) % widget.texts.length;
          } else {
            _currentText = _currentText.substring(0, _currentText.length - 1);
          }
        } else {
          if (_currentText.length < targetText.length) {
            _currentText = targetText.substring(0, _currentText.length + 1);
          } else {
            _isPaused = true;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor,
    );

    return FadeTransition(
      opacity: _fadeAnimation,
      // Wrap with LayoutBuilder to get available width
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  _currentText,
                  style: widget.textStyle ?? defaultStyle,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
                FadeTransition(
                  opacity: _cursorController,
                  child: Text(
                    widget.cursor,
                    style: widget.textStyle ?? defaultStyle,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}