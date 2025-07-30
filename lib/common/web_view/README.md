# Web View Component

Component này cung cấp khả năng hiển thị tài liệu PDF và trang web trong ứng dụng Flutter.

## Tính năng

- ✅ Hiển thị tài liệu PDF
- ✅ Hỗ trợ zoom và pan
- ✅ Navigation controls (back, forward, reload)
- ✅ Loading indicator
- ✅ Error handling
- ✅ Custom headers
- ✅ JavaScript support
- ✅ Responsive design

## Cài đặt

Thêm dependency vào `pubspec.yaml`:

```yaml
dependencies:
  webview_flutter: ^4.7.0
```

Chạy lệnh:
```bash
flutter pub get
```

## Cách sử dụng

### 1. WebViewCommon (Component chính)

```dart
import 'package:your_app/common/web_view/web_view_common.dart';

// Sử dụng cơ bản
WebViewCommon(
  url: 'https://example.com/document.pdf',
  title: 'Tài liệu',
)

// Sử dụng với tùy chọn
WebViewCommon(
  url: 'https://example.com/document.pdf',
  title: 'Quyết định điều động tài sản',
  enableZoom: true,
  enableJavaScript: true,
  headers: {
    'Accept': 'application/pdf',
    'Authorization': 'Bearer your-token',
  },
)
```

### 2. PDFViewer (Helper cho PDF)

```dart
PDFViewer(
  url: 'https://example.com/document.pdf',
  title: 'Tài liệu PDF',
)
```

### 3. DecisionDocumentViewer (Helper cho tài liệu quyết định)

```dart
DecisionDocumentViewer(
  documentUrl: 'https://ams.sscdx.com.vn/web#',
  documentTitle: 'Quyết định điều động tài sản',
)
```

## Tham số

### WebViewCommon

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---------|------|----------|-------|
| `url` | String | ✅ | URL của tài liệu/trang web |
| `title` | String? | ❌ | Tiêu đề hiển thị trên AppBar |
| `showAppBar` | bool | ❌ | Hiển thị AppBar (mặc định: true) |
| `enableJavaScript` | bool | ❌ | Bật JavaScript (mặc định: true) |
| `enableZoom` | bool | ❌ | Cho phép zoom (mặc định: true) |
| `headers` | Map<String, String>? | ❌ | Headers tùy chỉnh |

## Ví dụ sử dụng

### 1. Hiển thị tài liệu quyết định

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DecisionDocumentViewer(
      documentUrl: 'https://ams.sscdx.com.vn/web#',
      documentTitle: 'Quyết định điều động tài sản',
    ),
  ),
);
```

### 2. Hiển thị PDF với authentication

```dart
WebViewCommon(
  url: 'https://api.example.com/documents/123.pdf',
  title: 'Tài liệu nội bộ',
  headers: {
    'Authorization': 'Bearer your-jwt-token',
    'Accept': 'application/pdf',
  },
)
```

### 3. Hiển thị trang web thông thường

```dart
WebViewCommon(
  url: 'https://flutter.dev',
  title: 'Flutter Documentation',
  enableZoom: true,
  enableJavaScript: true,
)
```

## Tính năng nâng cao

### 1. Custom Navigation

```dart
WebViewCommon(
  url: url,
  title: 'Custom Navigation',
  showAppBar: false, // Ẩn AppBar mặc định
)
```

### 2. Error Handling

Component tự động xử lý lỗi và hiển thị:
- Loading indicator khi đang tải
- Error message khi có lỗi
- Retry button để thử lại

### 3. Headers tùy chỉnh

```dart
WebViewCommon(
  url: url,
  headers: {
    'Accept': 'application/pdf,text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'vi-VN,vi;q=0.9,en;q=0.8',
    'Cache-Control': 'no-cache',
    'Authorization': 'Bearer your-token',
  },
)
```

## Lưu ý

1. **Android**: Cần thêm permission internet trong `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

2. **iOS**: Không cần cấu hình thêm

3. **Performance**: WebView có thể tiêu tốn bộ nhớ, nên dispose khi không sử dụng

4. **Security**: Chỉ load URL từ nguồn đáng tin cậy

## Troubleshooting

### Lỗi thường gặp

1. **Không hiển thị nội dung**
   - Kiểm tra URL có hợp lệ không
   - Kiểm tra kết nối internet
   - Thử với URL khác

2. **Lỗi JavaScript**
   - Đảm bảo `enableJavaScript: true`
   - Kiểm tra console log

3. **Lỗi authentication**
   - Kiểm tra headers có đúng không
   - Kiểm tra token có hợp lệ không

### Debug

```dart
WebViewCommon(
  url: url,
  title: 'Debug Mode',
  enableJavaScript: true,
  headers: {
    'Accept': '*/*',
    'User-Agent': 'Mozilla/5.0 (compatible; Flutter WebView)',
  },
)
``` 