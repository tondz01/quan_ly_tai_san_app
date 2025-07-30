import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WebViewCommon extends StatefulWidget {
  final String url;
  final String? title;
  final bool showAppBar;
  final bool enableJavaScript;
  final bool enableZoom;
  final Map<String, String>? headers;

  const WebViewCommon({
    Key? key,
    required this.url,
    this.title,
    this.showAppBar = true,
    this.enableJavaScript = true,
    this.enableZoom = true,
    this.headers,
  }) : super(key: key);

  @override
  State<WebViewCommon> createState() => _WebViewCommonState();
}

class _WebViewCommonState extends State<WebViewCommon> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(
        widget.enableJavaScript 
          ? JavaScriptMode.unrestricted 
          : JavaScriptMode.disabled,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Có thể hiển thị progress bar ở đây
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Lỗi tải trang: ${error.description}';
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.url),
        headers: widget.headers ?? {},
      );
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
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 1,
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, size: 24.sp),
          onPressed: () {
            _controller.reload();
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'back':
                _controller.goBack();
                break;
              case 'forward':
                _controller.goForward();
                break;
              case 'reload':
                _controller.reload();
                break;
              case 'share':
                _shareUrl();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'back',
              child: Row(
                children: [
                  Icon(Icons.arrow_back, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text('Quay lại'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'forward',
              child: Row(
                children: [
                  Icon(Icons.arrow_forward, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text('Tiến tới'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'reload',
              child: Row(
                children: [
                  Icon(Icons.refresh, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text('Tải lại'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text('Chia sẻ'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    return Stack(
      children: [
        WebViewWidget(
          controller: _controller,
        ),
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
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: Colors.red[300],
            ),
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
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                  _isLoading = true;
                });
                _controller.reload();
              },
              icon: Icon(Icons.refresh, size: 20.sp),
              label: Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareUrl() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chức năng chia sẻ sẽ được thêm sau'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// Widget helper để tạo web view với URL cụ thể
class PDFViewer extends StatelessWidget {
  final String url;
  final String? title;

  const PDFViewer({
    Key? key,
    required this.url,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebViewCommon(
      url: url,
      title: title ?? 'Xem tài liệu',
      enableZoom: true,
      enableJavaScript: true,
    );
  }
}

// Widget helper để tạo web view cho tài liệu quyết định
class DecisionDocumentViewer extends StatelessWidget {
  final String documentUrl;
  final String documentTitle;

  const DecisionDocumentViewer({
    Key? key,
    required this.documentUrl,
    this.documentTitle = 'Quyết định',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebViewCommon(
      url: documentUrl,
      title: documentTitle,
      enableZoom: true,
      enableJavaScript: true,
      headers: {
        'Accept': 'application/pdf,text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'vi-VN,vi;q=0.9,en;q=0.8',
      },
    );
  }
}
