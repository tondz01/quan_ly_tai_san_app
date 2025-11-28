import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quan_ly_tai_san_app/common/components/popup_input_pin.dart';
import 'package:quan_ly_tai_san_app/common/download_file.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:se_gay_components/base_api/api_config.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class CommonContract extends StatefulWidget {
  final List<Widget> contractPages; // Danh sách trang động
  final List<String> signatureList;
  final String? idTaiLieu;
  final String? idNguoiKy;
  final String? tenNguoiKy;
  final NhanVien? nhanVien;
  final int? pin;
  final bool isSavePin;
  final bool isShowKy;
  final bool isKyNhay;
  final bool isKyThuong;
  final bool isKySo;
  final Function()? eventSignature;
  final String? showTitle;

  const CommonContract({
    super.key,
    required this.contractPages,
    required this.signatureList,
    this.idTaiLieu,
    this.showTitle,
    this.idNguoiKy,
    this.tenNguoiKy,
    this.nhanVien,
    this.isShowKy = true,
    this.isKyNhay = true,
    this.isKyThuong = true,
    this.isKySo = true,
    this.eventSignature,
    this.pin,
    this.isSavePin = false,
  });

  @override
  State<CommonContract> createState() => _CommonContractState();
}

class _CommonContractState extends State<CommonContract> {
  final GlobalKey _contractKey = GlobalKey();
  final List<DraggableImage> images = [];
  bool _submitting = false;

  // Danh sách dynamic keys cho các trang
  late List<GlobalKey> _pageKeys;

  bool _isDigital = false;
  int _selectedSigningType =
      2; // 1: Ký nháy, 2: Ký thường, 3: Ký số ký hiệu, 4: Ký số hình ảnh

  // Reference dimensions for coordinate normalization (A4 size)
  static const double REFERENCE_WIDTH = 800.0;
  static const double REFERENCE_HEIGHT = 1131.0; // A4 ratio (297/210 * 800)

  // Coordinate conversion helpers
  double _toNormalizedX(double absoluteX) {
    return absoluteX / REFERENCE_WIDTH;
  }

  double _toNormalizedY(double absoluteY) {
    return absoluteY / REFERENCE_HEIGHT;
  }

  double _toAbsoluteX(double normalizedX) {
    return normalizedX * REFERENCE_WIDTH;
  }

  double _toAbsoluteY(double normalizedY) {
    return normalizedY * REFERENCE_HEIGHT;
  }

  // ===== Helpers UI =====

  // ===== Add signatures =====
  void _addSignature(
    Uint8List bytes,
    int loaiKy,
    double top,
    double left,
    bool isEdit, {
    bool isNew = true,
  }) {
    setState(() {
      images.add(
        DraggableImage(
          key: GlobalKey(),
          bytes: bytes,
          loaiKy: loaiKy,
          // 1: ký nháy, 2: ký, 3: ký số
          top: top,
          left: left,
          isEdit: isEdit,
          isNew: isNew,
        ),
      );
    });
  }

  Future<void> _addFirstSignatureFromList(
    int loaiKy, {
    double top = 100,
    double left = 100,
  }) async {
    if (_isDigital) {
      if (!mounted) return;
      Future.microtask(() {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Chỉ được ký chữ ký số')));
        }
      });
    }

    if (widget.signatureList.isEmpty) {
      if (!mounted) return;
      Future.microtask(() {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Danh sách chữ ký rỗng')));
        }
      });
    }
    try {
      String url = "";
      if (loaiKy == 2) {
        String name = widget.nhanVien?.chuKyThuong ?? "";

        url = widget.signatureList.firstWhere((e) => e.contains(name));
        print('loai ky 2');
        print(url);
      } else if (loaiKy == 1) {
        String name = widget.nhanVien?.chuKyNhay ?? "";
        url = widget.signatureList.firstWhere((e) => e.contains(name));
        print('loai ky 1');
        print(url);
      } else if (loaiKy == 4) {
        String name = widget.nhanVien?.chuKyThuong ?? "";
        url = widget.signatureList.firstWhere((e) => e.contains(name));
        print('loai ky 4');
        print(url);
      } else if (loaiKy == 5) {
        String name = widget.nhanVien?.chuKyNhay ?? "";
        url = widget.signatureList.firstWhere((e) => e.contains(name));
        print('loai ky 5');
        print(url);
      }
      if (url.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Bạn chưa có chữ ký')));
        }
        return;
      }
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _addSignature(response.bodyBytes, loaiKy, top, left, true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi tải ảnh')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi tải ảnh: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Khởi tạo keys cho từng trang
    _pageKeys = List.generate(
      widget.contractPages.length,
      (index) => GlobalKey(),
    );
    _loadSignatures();
  }

  // Future<void> _pickImage(int loaiKy) async {
  //   final result = await FilePicker.platform.pickFiles(type: FileType.image);
  //   if (result != null && result.files.single.bytes != null) {
  //     _addSignature(result.files.single.bytes!, loaiKy, 100, 100);
  //   }
  // }

  List<Map<String, dynamic>> signatures = [];

  Future<void> _loadSignatures() async {
    final url = Uri.parse(
      "${ApiConfig.getBaseURL()}/api/chuky/${widget.idTaiLieu}",
    );
    final res = await http.get(url);
    final decoded = jsonDecode(res.body);
    final List<dynamic> data =
        decoded is List ? decoded : (decoded['data'] ?? []);
    final List<Map<String, dynamic>> uniqueData = [];
    final Set<String> seenKeys = {};

    for (var item in data) {
      if (item is Map) {
        final mapItem = Map<String, dynamic>.from(item);
        final key =
            "${mapItem['idTaiLieu']}_${mapItem['loaiKy']}_${mapItem['idNguoiKy']}_${mapItem['ngayKy']}";

        if (!seenKeys.contains(key)) {
          seenKeys.add(key);
          uniqueData.add(mapItem);
        }
      }
    }

    setState(() {
      signatures = uniqueData;
    });

    _fillSignatures();
  }

  Future<void> _fillSignatures() async {
    if (widget.signatureList.isEmpty) return;

    // Log toàn bộ dữ liệu API để debug
    SGLog.info(
      'Load signatures',
      'API data: ${signatures.map((e) => e.toString()).join('\n')}',
    );

    for (var sig in signatures) {
      // Load normalized coordinates (0-1 range) and convert to absolute
      final double normalizedX = sig["x"]?.toDouble() ?? 0;
      final double normalizedY = sig["y"]?.toDouble() ?? 0;
      final double x = _toAbsoluteX(normalizedX);
      final double y = _toAbsoluteY(normalizedY);
      final int loaiKy = sig["loaiKy"] ?? 1;
      final String? idNguoiKy = sig["idNguoiKy"]?.toString();
      final String? tenNguoiKy = sig["tenNguoiKy"]?.toString();
      final String? ngayKy = sig["ngayKy"]?.toString();
      String signatureUrl = "";
      if (loaiKy == 1) {
        signatureUrl = sig["chuKyNhay"].toString();
      } else if (loaiKy == 2) {
        signatureUrl = sig["chuKyThuong"].toString();
      } else if (loaiKy == 4) {
        signatureUrl = sig["chuKyThuong"].toString();
      } else if (loaiKy == 5) {
        signatureUrl = sig["chuKyNhay"].toString();
      }
      if (loaiKy == 3 || loaiKy == 4 || loaiKy == 5) {
        setState(() {
          _isDigital = true;
        });
      }
      if (loaiKy == 3) {
        // Lấy ngày ký từ API, format nếu có
        String? formattedDate;
        if (ngayKy != null && ngayKy.isNotEmpty) {
          try {
            final dateTime = DateTime.parse(ngayKy);
            formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
          } catch (e) {
            formattedDate = ngayKy; // Nếu không parse được, dùng giá trị gốc
          }
        }
        // Sử dụng tên người ký từ API, nếu không có thì fallback về widget.tenNguoiKy
        final tenKyDung = tenNguoiKy ?? widget.tenNguoiKy;
        Uint8List? imgBytes = await _captureWidget(tenKyDung, formattedDate);
        if (imgBytes != null) {
          _addSignature(imgBytes, loaiKy, y, x, false, isNew: false);
        }
      } else {
        // Sử dụng URL chữ ký từ API response nếu có
        String? urlToUse = signatureUrl;

        // Nếu không có signatureUrl từ API, fallback về signatureList
        if (urlToUse.isNotEmpty) {
          try {
            urlToUse =
                '${ApiConfig.getBaseURL()}/api/upload/download/$urlToUse';
            print('list signature');
            print(urlToUse);
            final response = await http.get(Uri.parse(urlToUse));
            if (response.statusCode == 200) {
              // Với ký nháy/ký thường: chỉ hiển thị ảnh chữ ký
              _addSignature(
                response.bodyBytes,
                loaiKy,
                y,
                x,
                false,
                isNew: false,
              );
            } else {
              SGLog.error(
                'Load signature',
                'Failed to load signature for user $idNguoiKy: HTTP ${response.statusCode}',
              );
            }
          } catch (e) {
            SGLog.error(
              'Load signature',
              'Error loading signature for user $idNguoiKy: $e',
            );
          }
        } else {
          SGLog.warning(
            'Load signature',
            'No signature URL found for user $idNguoiKy',
          );
        }

        // Log để debug
        SGLog.info(
          'Load signature',
          'Loading signature for user $idNguoiKy ($tenNguoiKy), loaiKy: $loaiKy, url: $urlToUse',
        );
      }
    }
  }

  // ===== Export PDF =====
  Future<void> _exportToPdf() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final pdf = pw.Document();

      // Ẩn viền chọn trước khi chụp (bỏ chọn tất cả)
      final selectedStates =
          images.map((img) {
            final state =
                (img.key as GlobalKey).currentState as _DraggableImageState?;
            return state?.isSelected ?? false;
          }).toList();

      for (var img in images) {
        final state =
            (img.key as GlobalKey).currentState as _DraggableImageState?;
        if (state != null && state.isSelected) {
          state.setState(() => state.isSelected = false);
        }
      }
      await Future.delayed(const Duration(milliseconds: 50));

      // Xuất từng trang thành PDF page riêng biệt
      for (int i = 0; i < _pageKeys.length; i++) {
        final pageKey = _pageKeys[i];
        // Scroll đến trang để đảm bảo nó được render (fix lỗi Local result has not been initialized)
        if (pageKey.currentContext != null) {
          await Scrollable.ensureVisible(
            pageKey.currentContext!,
            duration: const Duration(milliseconds: 100),
          );
          await Future.delayed(const Duration(milliseconds: 150));
        }

        final boundary =
            pageKey.currentContext?.findRenderObject()
                as RenderRepaintBoundary?;

        if (boundary != null) {
          final double pixelRatio = kIsWeb ? 1.5 : 2.0;
          final image = await boundary.toImage(pixelRatio: pixelRatio);
          final byteData = await image.toByteData(
            format: ui.ImageByteFormat.png,
          );
          final pngBytes = byteData!.buffer.asUint8List();

          // Kiểm tra kích thước ảnh
          final imageWidth = image.width.toDouble();
          final imageHeight = image.height.toDouble();

          if (imageWidth.isNaN ||
              imageHeight.isNaN ||
              imageWidth <= 0 ||
              imageHeight <= 0) {
            throw Exception(
              'Kích thước ảnh không hợp lệ trang ${i + 1}: ${imageWidth}x$imageHeight',
            );
          }

          final imageProvider = pw.MemoryImage(pngBytes);

          // Lọc chữ ký thuộc trang này (dựa trên vị trí Y)
          final pageHeight = 800 * (297 / 210); // Chiều cao A4Canvas
          final pageSignatures = <DraggableImage>[];

          for (var img in images) {
            final state =
                (img.key as GlobalKey).currentState as _DraggableImageState?;
            if (state != null) {
              final signatureY = state.top;
              final startY = i * pageHeight;
              final endY = (i + 1) * pageHeight;

              // Kiểm tra chữ ký thuộc trang nào
              if (signatureY >= startY && signatureY < endY) {
                pageSignatures.add(img);
              }
            }
          }

          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4.portrait,
              margin: pw.EdgeInsets.zero,
              build:
                  (context) => pw.Stack(
                    children: [
                      // Nội dung trang
                      pw.SizedBox.expand(
                        child: pw.FittedBox(
                          fit: pw.BoxFit.fill,
                          child: pw.Image(imageProvider),
                        ),
                      ),
                      // Thêm chữ ký vào đúng vị trí (nếu có)
                      ...pageSignatures.map((img) {
                        final state =
                            (img.key as GlobalKey).currentState
                                as _DraggableImageState?;
                        if (state != null) {
                          // Tính toán vị trí tương đối cho từng trang
                          double relativeY = state.top - (i * pageHeight);

                          return pw.Positioned(
                            left: state.left * (PdfPageFormat.a4.width / 800),
                            top:
                                relativeY *
                                (PdfPageFormat.a4.height / pageHeight),
                            child: pw.Container(
                              width: 100 * state.scale,
                              height: 60 * state.scale,
                              child: pw.Image(pw.MemoryImage(img.bytes)),
                            ),
                          );
                        }
                        return pw.Container();
                      }),
                    ],
                  ),
            ),
          );
        }
      }

      final pdfBytes = await pdf.save();

      if (kIsWeb) {
        await downloadFileFromBytes(pdfBytes, 'document.pdf', context);
      } else {
        await Printing.sharePdf(bytes: pdfBytes, filename: 'document.pdf');
      }

      // Khôi phục trạng thái chọn
      for (int i = 0; i < images.length; i++) {
        final state =
            (images[i].key as GlobalKey).currentState as _DraggableImageState?;
        if (state != null && selectedStates[i]) {
          state.setState(() => state.isSelected = true);
        }
      }
    } catch (e) {
      SGLog.error('Lỗi xuất PDF', 'Lỗi xuất PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi xuất PDF: $e')));
      }
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  // ===== Collect data to insert DB =====
  List<Map<String, dynamic>> getSignaturesData() {
    final List<Map<String, dynamic>> data = [];
    for (var i = 0; i < images.length; i++) {
      final img = images[i];
      if (!img.isNew) continue;
      final state =
          (img.key as GlobalKey).currentState as _DraggableImageState?;
      if (state != null) {
        // Convert absolute positions to normalized coordinates (0-1 range)
        final normalizedX = _toNormalizedX(state.left);
        final normalizedY = _toNormalizedY(state.top);

        data.add({
          "id": UniqueKey().toString(),
          "idTaiLieu": widget.idTaiLieu,
          "loaiKy": img.loaiKy, // 1/2/3
          "x": normalizedX,
          "y": normalizedY,
          "idNguoiKy": widget.idNguoiKy,
          "chuKySo":
              img.loaiKy == 3 || img.loaiKy == 4 || img.loaiKy == 5
                  ? signatureValue
                  : null,
          "ngayKy": DateTime.now().toIso8601String(),
          "stt": i + 1,
          // Có thể thêm "Scale": state.scale nếu DB cần
        });
      }
    }

    return data;
  }

  // ===== Confirm (call API) =====
  Future<void> _confirmSignatures() async {
    final signatures = getSignaturesData();
    if (signatures.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có chữ ký nào để lưu')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      // Thay URL API của bạn tại đây:
      final uri = Uri.parse('${ApiConfig.getBaseURL()}/api/chuky');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(signatures),
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        widget.eventSignature?.call();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã lưu chữ ký thành công')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Lưu chữ ký thất bại: ${resp.statusCode} - ${resp.body}',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi kết nối API: $e')));
      }
    } finally {
      setState(() => _submitting = false);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  String signatureValue = '';

  String generateSha256(String input) {
    // Chuyển String sang bytes UTF-8
    final bytes = utf8.encode(input);

    // Tạo hash SHA-256
    final digest = sha256.convert(bytes);
    SGLog.info('Chu ky', 'Chu ky: ${digest.toString()}');

    // Trả về hash dạng hex string
    return digest.toString();
  }

  Future<String?> login() async {
    final String url = "https://rms.efy.com.vn/clients/login";
    final Map<String, dynamic> payload = {
      "username": "rp_test",
      "password": "rp_test",
      "rpCode": "RP_TEST",
    };
    final Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final token = data['token'];
        SGLog.info('Đăng nhập', 'Đăng nhập thành công! Token: $token');
        return token;
      } else {
        SGLog.info(
          'Đăng nhập',
          'Login thất bại: HTTP ${response.statusCode}: ${response.body}',
        );
        return null;
      }
    } catch (e) {
      SGLog.error('Đăng nhập', 'Lỗi khi login: $e');
      return null;
    }
  }

  final GlobalKey _captureKey = GlobalKey();
  Uint8List? capturedImage;

  // Lưu thông tin cho chữ ký số đang được capture
  String? _currentSignatureName;
  String? _currentSignatureDate;

  Future<Uint8List?> _captureWidget(String? tenNguoiKy, String? ngayKy) async {
    try {
      // Lưu thông tin người ký tạm thời để widget có thể hiển thị đúng
      setState(() {
        _currentSignatureName = tenNguoiKy;
        _currentSignatureDate =
            ngayKy ?? DateFormat('dd/MM/yyyy').format(DateTime.now());
      });

      // Đợi một frame để widget được rebuild với thông tin mới
      await Future.delayed(const Duration(milliseconds: 50));

      RenderRepaintBoundary boundary =
          _captureKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      SGLog.error('Capture error', 'Capture error: $e');
      return null;
    }
  }

  Future<Uint8List?> _captureWidgetForSigning() async {
    // Dùng cho ký mới (dùng widget.tenNguoiKy)
    return _captureWidget(
      widget.tenNguoiKy,
      DateFormat('dd/MM/yyyy').format(DateTime.now()),
    );
  }

  // ===== Ký hash =====
  Future<void> signing(
    NhanVien nhanVien, {
    double top = 500,
    double left = 500,
  }) async {
    if (widget.idNguoiKy == null || widget.idTaiLieu == null) {
      return;
    }

    String value = widget.idNguoiKy! + widget.idTaiLieu!;
    String hash = generateSha256(value);
    SGLog.info('Chu ky', 'Chu ky SHA-256: $hash');

    // 1️⃣ Lấy token trước
    final token = await login();
    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login thất bại, không thể ký')),
        );
      }
      return;
    }

    try {
      // 2️⃣ Capture widget trước khi call API
      Uint8List? imgBytes =
          await _captureWidgetForSigning(); // hàm này trả Uint8List
      if (imgBytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể chụp chữ ký')),
          );
        }
        return;
      }

      // 3️⃣ Thêm chữ ký vào màn hình
      _addSignature(imgBytes, 3, top, left, true);

      // 4️⃣ Gọi API ký
      final String url = "https://rms.efy.com.vn/signing/hash";
      final Map<String, dynamic> signingPayload = {
        "agreementUUID": "02e80096-912a-4b30-a38e-334ddc110a1e",
        "authMode": "EXPLICIT/PIN",
        "authorizeCode": "efyvn@123",
        "encryption": "RSA",
        "hash": hash,
        "hashAlgorithm": "SHA-256",
        "mimeType": "application/sha256-binary",
      };
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(signingPayload),
      );

      // 5️⃣ Xử lý kết quả
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        setState(() {
          signatureValue = result['signatureValue'] ?? '';
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Đã ký thành công')));
        }
      } else {
        SGLog.error('Ký', 'HTTP ${response.statusCode}: ${response.body}');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Ký không thành công')));
        }
      }
    } catch (e) {
      SGLog.error('Ký', 'Lỗi ký: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Ký không thành công')));
      }
    }
  }

  // ===== Ký hash với loại ký = 4 (ký số thuần với hình ảnh từ type 2) =====
  Future<void> signingWithImageType4(
    NhanVien nhanVien, {
    double top = 500,
    double left = 500,
  }) async {
    if (widget.idNguoiKy == null || widget.idTaiLieu == null) {
      return;
    }

    String value = widget.idNguoiKy! + widget.idTaiLieu!;
    String hash = generateSha256(value);
    SGLog.info('Chu ky', 'Chu ky SHA-256: $hash');

    // 1️⃣ Lấy token trước
    final token = await login();
    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login thất bại, không thể ký')),
        );
      }
      return;
    }

    try {
      // 2️⃣ Lấy hình ảnh từ chữ ký type 2 (widget.signatureList[1])
      Uint8List? imgBytes;
      if (widget.signatureList.isNotEmpty && widget.signatureList.length > 1) {
        try {
          String name = widget.nhanVien?.chuKyThuong ?? "";
          final url = widget.signatureList.firstWhere((e) => e.contains(name));

          print('Lấy hình ảnh chữ ký type 2 từ: $url');
          final response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            imgBytes = response.bodyBytes;
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Không tải được ảnh chữ ký: $url (HTTP ${response.statusCode})',
                  ),
                ),
              );
            }
            return;
          }
        } catch (e) {
          SGLog.error('Ký', 'Lỗi tải ảnh chữ ký type 2: $e');
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Lỗi tải ảnh chữ ký: $e')));
          }
          return;
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không tìm thấy hình ảnh chữ ký type 2'),
            ),
          );
        }
        return;
      }

      // 3️⃣ Thêm chữ ký vào màn hình với loaiKy = 4
      _addSignature(imgBytes, 4, top, left, true);

      // 4️⃣ Gọi API ký
      final String url = "https://rms.efy.com.vn/signing/hash";
      final Map<String, dynamic> signingPayload = {
        "agreementUUID": "02e80096-912a-4b30-a38e-334ddc110a1e",
        "authMode": "EXPLICIT/PIN",
        "authorizeCode": "efyvn@123",
        "encryption": "RSA",
        "hash": hash,
        "hashAlgorithm": "SHA-256",
        "mimeType": "application/sha256-binary",
      };
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(signingPayload),
      );

      // 5️⃣ Xử lý kết quả
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        setState(() {
          signatureValue = result['signatureValue'] ?? '';
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Đã ký thành công')));
        }
      } else {
        SGLog.error('Ký', 'HTTP ${response.statusCode}: ${response.body}');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Ký không thành công')));
        }
      }
    } catch (e) {
      SGLog.error('Ký', 'Lỗi ký: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Ký không thành công')));
      }
    }
  }

  // ===== Ký hash với loại ký = 2 (ký số dạng hình ảnh) =====
  Future<void> signingWithImageType(
    NhanVien nhanVien, {
    double top = 500,
    double left = 500,
  }) async {
    if (widget.idNguoiKy == null || widget.idTaiLieu == null) {
      return;
    }

    String value = widget.idNguoiKy! + widget.idTaiLieu!;
    String hash = generateSha256(value);
    SGLog.info('Chu ky', 'Chu ky SHA-256: $hash');

    // 1️⃣ Lấy token trước
    final token = await login();
    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login thất bại, không thể ký')),
        );
      }
      return;
    }

    try {
      // 2️⃣ Capture widget trước khi call API
      Uint8List? imgBytes =
          await _captureWidgetForSigning(); // hàm này trả Uint8List
      if (imgBytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể chụp chữ ký')),
          );
        }
        return;
      }

      // 3️⃣ Thêm chữ ký vào màn hình với loaiKy = 2
      _addSignature(imgBytes, 2, top, left, true);

      // 4️⃣ Gọi API ký
      final String url = "https://rms.efy.com.vn/signing/hash";
      final Map<String, dynamic> signingPayload = {
        "agreementUUID": "02e80096-912a-4b30-a38e-334ddc110a1e",
        "authMode": "EXPLICIT/PIN",
        "authorizeCode": "efyvn@123",
        "encryption": "RSA",
        "hash": hash,
        "hashAlgorithm": "SHA-256",
        "mimeType": "application/sha256-binary",
      };
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(signingPayload),
      );

      // 5️⃣ Xử lý kết quả
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        setState(() {
          signatureValue = result['signatureValue'] ?? '';
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Đã ký thành công')));
        }
      } else {
        SGLog.error('Ký', 'HTTP ${response.statusCode}: ${response.body}');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Ký không thành công')));
        }
      }
    } catch (e) {
      SGLog.error('Ký', 'Lỗi ký: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Ký không thành công')));
      }
    }
  }

  // Helper method to get signature URL by type
  String? _getSignatureUrlByType(int loaiKy) {
    if (widget.signatureList.isEmpty || widget.nhanVien == null) return null;

    try {
      String name = "";
      if (loaiKy == 1 || loaiKy == 5) {
        // Ký nháy
        name = widget.nhanVien?.chuKyNhay ?? "";
      } else if (loaiKy == 2 || loaiKy == 4) {
        // Ký thường
        name = widget.nhanVien?.chuKyThuong ?? "";
      }

      if (name.isEmpty) return null;
      return widget.signatureList.firstWhere(
        (e) => e.contains(name),
        orElse: () => "",
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _handleSigning(double top, double left) async {
    if (_selectedSigningType == 1) {
      // Ký nháy
      _addFirstSignatureFromList(1, top: top, left: left);
    } else if (_selectedSigningType == 2) {
      // Ký thường
      _addFirstSignatureFromList(2, top: top, left: left);
    } else {
      // Ký số (3 hoặc 4)
      if (widget.nhanVien == null) {
        AppUtility.showSnackBar(context, "Không tìm thấy thông tin nhân viên");
        return;
      }

      if (!(widget.nhanVien!.savePin ?? false)) {
        showPopupInputPin(
          context: context,
          title: "Xác nhận mã Pin",
          description: "Vui lòng nhập mã Pin để xác nhận",
          onConfirm: (value) async {
            if (value == widget.pin) {
              if (_selectedSigningType == 3) {
                await signing(widget.nhanVien!, top: top, left: left);
              } else {
                await signingWithImageType4(
                  widget.nhanVien!,
                  top: top,
                  left: left,
                );
              }
            } else {
              AppUtility.showSnackBar(
                context,
                "Mã pin chưa chính xác, vui lòng nhập lại!",
                isError: true,
              );
            }
          },
        );
      } else {
        if (_selectedSigningType == 3) {
          await signing(widget.nhanVien!, top: top, left: left);
        } else {
          await signingWithImageType4(widget.nhanVien!, top: top, left: left);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return Column(
            children: [
              // Thanh tiêu đề
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      widget.showTitle ?? 'Soạn & Ký Tài Liệu',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${widget.contractPages.length} trang',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _exportToPdf,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Xuất PDF'),
                    ),
                    IconButton(
                      tooltip: 'Đóng',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.green),
                    ),
                  ],
                ),
              ),

              // Nội dung chính
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tab công cụ bên trái
                    Container(
                      width: 350,
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Công cụ ký",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (widget.isKyThuong)
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<int>(
                                    title: const Text("Ký thường"),
                                    value: 2,
                                    groupValue: _selectedSigningType,
                                    contentPadding: EdgeInsets.zero,
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedSigningType = val!;
                                      });
                                    },
                                  ),
                                ),
                                if (_getSignatureUrlByType(2) != null)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Image.network(
                                      _getSignatureUrlByType(2)!,
                                      width: 60,
                                      height: 40,
                                      fit: BoxFit.contain,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const SizedBox(
                                          width: 60,
                                          height: 40,
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          if (widget.isKyNhay)
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<int>(
                                    title: const Text("Ký nháy"),
                                    value: 1,
                                    groupValue: _selectedSigningType,
                                    contentPadding: EdgeInsets.zero,
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedSigningType = val!;
                                      });
                                    },
                                  ),
                                ),
                                if (_getSignatureUrlByType(1) != null)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Image.network(
                                      _getSignatureUrlByType(1)!,
                                      width: 60,
                                      height: 40,
                                      fit: BoxFit.contain,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const SizedBox(
                                          width: 60,
                                          height: 40,
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          if (widget.isKySo)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      12,
                                      8,
                                      12,
                                      0,
                                    ),
                                    child: Text(
                                      "Chữ ký số",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),

                                  RadioListTile<int>(
                                    title: const Text("Hiển thị mặc định"),
                                    value: 3,
                                    groupValue: _selectedSigningType,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedSigningType = val!;
                                      });
                                    },
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile<int>(
                                          title: const Text(
                                            "Hiển thị chữ ký thường",
                                          ),
                                          value: 4,
                                          groupValue: _selectedSigningType,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 4,
                                              ),
                                          onChanged: (val) {
                                            setState(() {
                                              _selectedSigningType = val!;
                                            });
                                          },
                                        ),
                                      ),
                                      if (_getSignatureUrlByType(4) != null)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Image.network(
                                            _getSignatureUrlByType(4)!,
                                            width: 60,
                                            height: 40,
                                            fit: BoxFit.contain,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return const SizedBox(
                                                width: 60,
                                                height: 40,
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile<int>(
                                          title: const Text(
                                            "Hiển thị chữ ký nháy",
                                          ),
                                          value: 5,
                                          groupValue: _selectedSigningType,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 4,
                                              ),
                                          onChanged: (val) {
                                            setState(() {
                                              _selectedSigningType = val!;
                                            });
                                          },
                                        ),
                                      ),
                                      if (_getSignatureUrlByType(5) != null)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Image.network(
                                            _getSignatureUrlByType(5)!,
                                            width: 60,
                                            height: 40,
                                            fit: BoxFit.contain,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return const SizedBox(
                                                width: 60,
                                                height: 40,
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Tính toán vị trí center của phần content
                                final contentWidth = screenWidth - 250;
                                final centerX = contentWidth / 2;
                                final centerY = screenHeight / 2;
                                _handleSigning(centerY, centerX);
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text("Ký"),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed:
                                  _submitting ? null : _confirmSignatures,
                              icon:
                                  _submitting
                                      ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Icon(Icons.check_circle),
                              label: Text(
                                _submitting ? 'Đang lưu...' : 'Xác nhận',
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                                side: const BorderSide(color: Colors.redAccent),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close),
                              label: const Text("Hủy"),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Nội dung tài liệu
                    Expanded(
                      child: Container(
                        color: Colors.grey[200],
                        child: SingleChildScrollView(
                          child: Center(
                            child: Stack(
                              children: [
                                Positioned(
                                  top: (screenHeight - 100) / 2,
                                  left: (screenWidth - 250 - 200) / 2,
                                  child: RepaintBoundary(
                                    key: _captureKey,
                                    child: buildSignatureValidContainer(
                                      _currentSignatureName ??
                                          widget.tenNguoiKy,
                                      _currentSignatureDate ??
                                          DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(DateTime.now()),
                                    ),
                                  ),
                                ),
                                // Tài liệu A4
                                RepaintBoundary(
                                  key: _contractKey,
                                  child: Stack(
                                    children: [
                                      // Nội dung hợp đồng
                                      Column(
                                        children: [
                                          // Tạo các trang động từ contractPages
                                          ...widget.contractPages
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                                final int index = entry.key;
                                                final Widget pageContent =
                                                    entry.value;

                                                return RepaintBoundary(
                                                  key: _pageKeys[index],
                                                  child: pageContent,
                                                );
                                              }),
                                        ],
                                      ),
                                      // Các chữ ký kéo thả
                                      ...images,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget buildSignatureValidContainer(String? name, String date) {
  return Container(
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.green, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Chữ ký số",
          style: TextStyle(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Ký bởi: ${name ?? ''}",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.check, color: Colors.green, size: 20),
          ],
        ),
        Text(
          "Ký ngày: $date",
          style: const TextStyle(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

class DraggableImage extends StatefulWidget {
  final Uint8List bytes;
  final int loaiKy; // 1: ký nháy, 2: ký, 3: ký số, 4: ký số dạng hình ảnh
  final double top;
  final double left;
  final bool isEdit;
  final bool isNew;

  const DraggableImage({
    super.key,
    required this.bytes,
    required this.loaiKy,
    required this.top,
    required this.left,
    required this.isEdit,
    this.isNew = true,
  });

  @override
  State<DraggableImage> createState() => _DraggableImageState();
}

class _DraggableImageState extends State<DraggableImage> {
  double top = 0;
  double left = 0;
  double scale = 1.0;
  bool isSelected = false;
  Offset? lastPanPosition;
  Offset? lastScaleDragPosition;

  @override
  void initState() {
    super.initState();
    top = widget.top;
    left = widget.left;
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = switch (widget.loaiKy) {
      1 => Colors.orange,
      2 => Colors.green,
      3 => Colors.blue,
      _ => Colors.blueGrey,
    };

    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () {
          if (widget.isEdit) {
            setState(() => isSelected = !isSelected);
          }
        },
        onPanStart:
            widget.isEdit
                ? (details) => lastPanPosition = details.globalPosition
                : null,
        onPanUpdate:
            widget.isEdit
                ? (details) {
                  setState(() {
                    final delta =
                        details.globalPosition -
                        (lastPanPosition ?? details.globalPosition);
                    left += delta.dx;
                    top += delta.dy;
                    lastPanPosition = details.globalPosition;
                  });
                }
                : null,
        child: Stack(
          clipBehavior: Clip.none, // Đảm bảo zoom không bị cắt
          alignment: Alignment.topRight,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border:
                    isSelected ? Border.all(color: accent, width: 1.2) : null,
              ),
              clipBehavior: Clip.none,
              // Cho phép phần zoom vượt ra ngoài
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.center, // Zoom từ giữa ảnh
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.memory(
                    widget.bytes,
                    width: 150,
                    fit: BoxFit.contain, // Không crop ảnh
                  ),
                ),
              ),
            ),

            if (isSelected && widget.isEdit) ...[
              // Nút xoá
              Positioned(
                top: -10,
                right: -10,
                child: InkWell(
                  onTap: () {
                    context
                        .findAncestorStateOfType<_CommonContractState>()
                        ?.setState(() {
                          context
                              .findAncestorStateOfType<_CommonContractState>()
                              ?.images
                              .remove(widget);
                        });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),

              // Nút kéo-để-zoom
              Positioned(
                bottom: -6,
                right: -6,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart:
                      (details) =>
                          lastScaleDragPosition = details.globalPosition,
                  onPanUpdate: (details) {
                    setState(() {
                      final delta =
                          details.globalPosition -
                          (lastScaleDragPosition ?? details.globalPosition);
                      final deltaScale = (delta.dx + delta.dy) / 200;
                      scale = (scale + deltaScale).clamp(0.5, 5.0);
                      lastScaleDragPosition = details.globalPosition;
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.open_with,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),

              // Tooltip hiển thị toạ độ & scale
              Positioned(
                bottom: -28,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .75),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'X:${left.toStringAsFixed(1)}, '
                    'Y:${top.toStringAsFixed(1)}, '
                    'S:${scale.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
