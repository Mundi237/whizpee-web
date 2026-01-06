import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

enum AppButtonType { filled, outlined }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final bool disabled;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final double borderRadius;
  final Widget? customLoadingWidget;
  final Widget? customIconWidget;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.filled,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50,
    this.disabled = false,
    this.padding,
    this.elevation,
    this.borderRadius = 12,
    this.customLoadingWidget,
    this.customIconWidget,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = AppTheme.of(context);
    final backgroundColor = this.backgroundColor ??
        (type == AppButtonType.filled
            ? AppTheme.primaryGreen
            : Colors.transparent);
    final textColor = this.textColor ??
        (type == AppButtonType.filled ? Colors.white : AppTheme.primaryGreen);
    final borderRadius = BorderRadius.circular(this.borderRadius);
    final buttonSize = Size(width ?? double.infinity, height);

    Widget childContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: customLoadingWidget ??
                Icon(Icons.hourglass_empty, color: textColor),
          ),
        if (customIconWidget != null && !isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: customIconWidget!,
          )
        else if (icon != null && !isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(icon, color: textColor),
          ),
        Opacity(
          opacity: isLoading ? 0.5 : 1.0,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ],
    );

    if (disabled) {
      childContent = Opacity(
        opacity: 0.5,
        child: childContent,
      );
    }

    final buttonStyle = type == AppButtonType.outlined
        ? OutlinedButton.styleFrom(
            minimumSize: buttonSize,
            side: BorderSide(color: textColor),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            padding: padding,
            elevation: elevation ?? 0,
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            minimumSize: buttonSize,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            elevation: elevation ?? 0,
            padding: padding,
          );

    final onPressed = disabled || isLoading ? null : this.onPressed;

    return type == AppButtonType.outlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: childContent,
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: childContent,
          );
  }
}
