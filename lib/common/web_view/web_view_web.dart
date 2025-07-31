// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui' as ui;

// Web-specific implementations
class WebViewHelper {
  static void registerViewFactory(String viewId, String url) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = url
        ..style.border = 'none'
        ..width = '100%'
        ..height = '100%';
      return iframe;
    });
  }

  static void openInNewTab(String url) {
    html.window.open(url, '_blank');
  }
} 