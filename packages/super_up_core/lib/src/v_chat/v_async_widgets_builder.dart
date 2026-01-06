// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../v_chat/v_enums.dart';

// switch between different widgets with animation
// depending on api call status
class VAsyncWidgetsBuilder extends StatefulWidget {
  final VChatLoadingState loadingState;
  final Widget Function()? loadingWidget;
  final Widget Function() successWidget;
  final Widget Function()? errorWidget;
  final Widget Function()? emptyWidget;
  final VoidCallback? onRefresh;
  final Duration animationDuration;
  final Curve animationCurve;

  const VAsyncWidgetsBuilder({
    super.key,
    required this.loadingState,
    this.loadingWidget,
    this.errorWidget,
    this.onRefresh,
    required this.successWidget,
    this.emptyWidget,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  State<VAsyncWidgetsBuilder> createState() => _VAsyncWidgetsBuilderState();
}

class _VAsyncWidgetsBuilderState extends State<VAsyncWidgetsBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.animationDuration,
      switchInCurve: widget.animationCurve,
      switchOutCurve: widget.animationCurve,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.02),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _buildStateWidget(),
    );
  }

  Widget _buildStateWidget() {
    switch (widget.loadingState) {
      case VChatLoadingState.success:
        return KeyedSubtree(
          key: const ValueKey('success'),
          child: widget.successWidget(),
        );

      case VChatLoadingState.error:
        return KeyedSubtree(
          key: const ValueKey('error'),
          child: widget.errorWidget?.call() ?? _buildDefaultErrorWidget(),
        );

      case VChatLoadingState.loading:
        return KeyedSubtree(
          key: const ValueKey('loading'),
          child: widget.loadingWidget?.call() ?? _buildDefaultLoadingWidget(),
        );

      case VChatLoadingState.empty:
        return KeyedSubtree(
          key: const ValueKey('empty'),
          child: widget.emptyWidget?.call() ?? _buildDefaultEmptyWidget(),
        );

      default:
        return KeyedSubtree(
          key: const ValueKey('success'),
          child: widget.successWidget(),
        );
    }
  }

  Widget _buildDefaultLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CupertinoActivityIndicator(radius: 16),
          const SizedBox(height: 16),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white60
                  : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Center(
      child: GestureDetector(
        onTap: () {
          if (widget.onRefresh != null) {
            HapticFeedback.mediumImpact();
            widget.onRefresh!();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.red.shade900.withOpacity(0.3)
                      : Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.red.shade300
                      : Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : Colors.black87,
                ),
              ),
              if (widget.onRefresh != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Tap to retry',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white60
                        : Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                Icon(
                  Icons.refresh,
                  size: 32,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.red.shade300
                      : Colors.red.shade700,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white24
                : Colors.black26,
          ),
          const SizedBox(height: 16),
          Text(
            'No data available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white60
                  : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
