// Cross-tab authentication service
// Sử dụng conditional export để chọn implementation phù hợp với platform
//
// - Web: Sử dụng cross_tab_auth_web.dart với HTML5 Storage Event
// - Non-web: Sử dụng cross_tab_auth_stub.dart (không làm gì)
export 'cross_tab_auth_stub.dart'
    if (dart.library.html) 'cross_tab_auth_web.dart';
