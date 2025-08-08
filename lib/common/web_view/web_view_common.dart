// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Conditional imports for web
import 'web_view_web.dart' if (dart.library.io) 'web_view_stub.dart';

class WebViewCommon extends StatefulWidget {
  final String url;
  final String? title;
  final bool showAppBar;
  final bool enableJavaScript;
  final bool enableZoom;
  final Map<String, String>? headers;

  const WebViewCommon({
    super.key,
    required this.url,
    this.title,
    this.showAppBar = true,
    this.enableJavaScript = true,
    this.enableZoom = true,
    this.headers,
  });

  @override
  State<WebViewCommon> createState() => _WebViewCommonState();
}

class _WebViewCommonState extends State<WebViewCommon> {
  late final WebViewController? _controller;
  bool _isLoading = true;
  String? _errorMessage;
  final String _viewId = 'webview_${UniqueKey()}';

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Đăng ký iframe view
      WebViewHelper.registerViewFactory(_viewId, widget.url);
      setState(() {
        _isLoading = false;
      });
    } else {
      _initializeWebView();
    }
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(
            widget.enableJavaScript
                ? JavaScriptMode.unrestricted
                : JavaScriptMode.disabled,
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted:
                  (_) => setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  }),
              onPageFinished: (_) => setState(() => _isLoading = false),
              onWebResourceError:
                  (error) => setState(() {
                    _isLoading = false;
                    _errorMessage = 'Lỗi tải trang: ${error.description}';
                  }),
            ),
          )
          ..loadRequest(Uri.parse(widget.url), headers: widget.headers ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? _buildAppBar() : null,
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        widget.title ?? 'Tài liệu',
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 1,
      actions: [
        if (!kIsWeb) ...[
          IconButton(
            icon: Icon(Icons.refresh, size: 24.sp),
            onPressed: () => _controller?.reload(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'back':
                  _controller?.goBack();
                  break;
                case 'forward':
                  _controller?.goForward();
                  break;
                case 'reload':
                  _controller?.reload();
                  break;
                case 'share':
                  _shareUrl();
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  _popupItem('back', Icons.arrow_back, 'Quay lại'),
                  _popupItem('forward', Icons.arrow_forward, 'Tiến tới'),
                  _popupItem('reload', Icons.refresh, 'Tải lại'),
                  _popupItem('share', Icons.share, 'Chia sẻ'),
                ],
          ),
        ],
        if (kIsWeb) ...[
          IconButton(
            icon: Icon(Icons.open_in_new, size: 24.sp),
            onPressed: () => WebViewHelper.openInNewTab(widget.url),
          ),
        ],
      ],
    );
  }

  PopupMenuItem<String> _popupItem(String value, IconData icon, String text) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [Icon(icon, size: 20.sp), SizedBox(width: 8.w), Text(text)],
      ),
    );
  }

  Widget _buildBody() {
    if (kIsWeb) {
      return HtmlElementView(viewType: _viewId);
    }

    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    return Stack(
      children: [
        WebViewWidget(controller: _controller!),
        if (_isLoading) _buildLoadingWidget(),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Đang tải tài liệu...',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red[300]),
          SizedBox(height: 16.h),
          Text(
            'Không thể tải tài liệu',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _errorMessage ?? 'Đã xảy ra lỗi không xác định',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _errorMessage = null;
                _isLoading = true;
              });
              _controller?.reload();
            },
            icon: Icon(Icons.refresh, size: 20.sp),
            label: Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  void _shareUrl() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chức năng chia sẻ sẽ được thêm sau')),
    );
  }
}

// Widget popup cho WebView
class WebViewPopup extends StatelessWidget {
  final String url;
  final String? title;
  final double width;
  final double height;

  const WebViewPopup({
    super.key,
    required this.url,
    this.title,
    this.width = 800,
    this.height = 600,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title ?? 'Tài liệu',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Button mở trong tab mới
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade200, width: 1),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.open_in_new, size: 16),
                      tooltip: 'Mở trong tab mới',
                      color: Colors.blue.shade700,
                      onPressed: () {
                        WebViewHelper.openInNewTab(url);
                      },
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: const EdgeInsets.all(4),
                    ),
                  ),
                  // Button đóng
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Divider
            const Divider(height: 1),
            // Content
            Expanded(
              child: WebViewCommon(
                url: url,
                title: title,
                showAppBar: false,
                enableZoom: true,
                enableJavaScript: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewContainer extends StatelessWidget {
  final String url;
  final String? title;
  final Function()? onPressed;

  const WebViewContainer({
    super.key,
    required this.url,
    this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // width: width,
        // height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title ?? 'Tài liệu',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Button mở trong tab mới
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade200, width: 1),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.open_in_new, size: 16),
                      tooltip: 'Mở trong tab mới',
                      color: Colors.blue.shade700,
                      onPressed: () {
                        WebViewHelper.openInNewTab(url);
                      },
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: const EdgeInsets.all(4),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade200, width: 1),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.visibility, size: 16),
                      tooltip: 'Ẩn preview',
                      color: Colors.blue.shade700,
                      onPressed: onPressed,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: const EdgeInsets.all(4),
                    ),
                  ),
                ],
              ),
            ),
            // Divider
            const Divider(height: 1),
            // Content
            Expanded(
              child: WebViewCommon(
                url: url,
                title: title,
                showAppBar: false,
                enableZoom: true,
                enableJavaScript: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function để show WebView popup
void showWebViewPopup(
  BuildContext context, {
  required String url,
  String? title,
  double width = 800,
  double height = 600,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) =>
            WebViewPopup(url: url, title: title, width: width, height: height),
  );
}
