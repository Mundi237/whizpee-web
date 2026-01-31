// Copyright notice
import 'package:flutter/widgets.dart';

/// Stub for the web-only renderButton method.
/// This file is used for non-web platforms.
Widget renderGoogleSignInButton({
  required Future<void> Function() onPressed,
}) {
  throw StateError('renderGoogleSignInButton should only be called on web');
}
