// app_logo.dart
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final String? title;
  final TextStyle? titleStyle;

  const AppLogo({
    super.key,
    this.size = 130,
    this.title,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/logo.png',
          width: size,
          height: size,
        ),
        if (title != null) ...[
          const SizedBox(height: 16),
          Text(
            title!,
            style: titleStyle ?? Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}