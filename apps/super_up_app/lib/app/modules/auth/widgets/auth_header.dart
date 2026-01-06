import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

class AuthHeader extends StatelessWidget {
  /// Whether to show the header (optional, defaults to true)
  final bool show;

  const AuthHeader({
    super.key,
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isLargeScreen = constraints.maxWidth > 600;

      if (isLargeScreen || !show) {
        return const SizedBox.shrink();
      }

      // Using a fixed height instead of height factor
      const headerHeight = 180.0;

      return Container(
        alignment: Alignment.center,
        height: headerHeight,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Image.asset(
                "assets/logo.png",
                height: 70,
                width: 70,
              ),
            ),
            const SizedBox(height: 12),
            SConstants.appName.h3
                .color(Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black)
                .bold,
          ],
        ),
      );
    });
  }
}
