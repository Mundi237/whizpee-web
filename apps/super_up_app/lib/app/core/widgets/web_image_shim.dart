// This file is a shim to allow compilation on non-web platforms.
// It mocks the platformViewRegistry needed for HtmlElementView factory registration.

class PlatformViewRegistry {
  void registerViewFactory(String viewId, dynamic cb) {}
}

final platformViewRegistry = PlatformViewRegistry();
