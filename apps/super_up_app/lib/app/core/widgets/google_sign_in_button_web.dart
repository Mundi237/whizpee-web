// Copyright notice
import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

/// Web-specific implementation of the Google Sign-In button.
/// This uses the google_sign_in_web renderButton method.
Widget renderGoogleSignInButton({
  required Future<void> Function() onPressed,
}) {
  return web.renderButton(
    configuration: web.GSIButtonConfiguration(
      size: web.GSIButtonSize.large,
      text: web.GSIButtonText.continueWith,
    ),
  );
}
