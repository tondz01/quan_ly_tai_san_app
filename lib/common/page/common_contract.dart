import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quan_ly_tai_san_app/common/widgets/a4_canvas.dart';
import 'package:se_gay_components/base_api/api_config.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class CommonContract extends StatefulWidget {
  final Widget contractType;
  final List<String> signatureList;
  final String idTaiLieu;
  final String idNguoiKy;
  final String tenNguoiKy;
  final bool isShowKy;
  final Function()? eventSignature;

  const CommonContract({
    super.key,
    required this.contractType,
    required this.signatureList,
    required this.idTaiLieu,
    required this.idNguoiKy,
    required this.tenNguoiKy,
    this.isShowKy = true,
    this.eventSignature,
  });

  @override
  State<CommonContract> createState() => _CommonContractState();
}

class _CommonContractState extends State<CommonContract> {
  final GlobalKey _contractKey = GlobalKey();
  final List<DraggableImage> images = [];
  bool _submitting = false;

  bool _isDigital = false;

  // ===== Helpers UI =====
  Widget _buildFab(
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return FloatingActionButton.extended(
      heroTag: label,
      backgroundColor: color,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontSize: 14)),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // ===== Add signatures =====
  void _addSignature(
    Uint8List bytes,
    int loaiKy,
    double top,
    double left,
    bool isEdit,
  ) {
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Chỉ được ký chữ ký số')));
      return;
    }
    if (widget.signatureList.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Danh sách chữ ký rỗng')));
      return;
    }
    try {
      final url =
          loaiKy == 2 ? widget.signatureList[1] : widget.signatureList.first;
      log('Check link chữ ký: $url');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _addSignature(response.bodyBytes, loaiKy, top, left, true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Không tải được ảnh: $url (HTTP ${response.statusCode})',
              ),
            ),
          );
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
    final List<dynamic> data = jsonDecode(res.body);
    setState(() {
      signatures = List<Map<String, dynamic>>.from(data);
    });

    _fillSignatures();
  }

  Future<void> _fillSignatures() async {
    if (widget.signatureList.isEmpty) return;
    final url = widget.signatureList.first;
    for (var sig in signatures) {
      final double x = sig["x"]?.toDouble() ?? 0;
      final double y = sig["y"]?.toDouble() ?? 0;
      final int loaiKy = sig["loaiKy"] ?? 1;
      if (loaiKy == 3) {
        setState(() {
          _isDigital = true;
        });
        Uint8List? imgBytes = await _captureWidget(); // hàm này trả Uint8List
        if (imgBytes != null) {
          _addSignature(imgBytes, loaiKy, y, x, false);
        }
      } else {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          _addSignature(response.bodyBytes, loaiKy, y, x, false);
        }
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
      final boundary =
          _contractKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary != null && boundary.debugNeedsPaint == false) {
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

        final image = await boundary.toImage(pixelRatio: 2.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();

        // Kiểm tra kích thước ảnh
        final imageWidth = image.width.toDouble();
        final imageHeight = image.height.toDouble();

        if (imageWidth.isNaN ||
            imageHeight.isNaN ||
            imageWidth <= 0 ||
            imageHeight <= 0) {
          throw Exception(
            'Kích thước ảnh không hợp lệ: ${imageWidth}x$imageHeight',
          );
        }

        final imageProvider = pw.MemoryImage(pngBytes);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4.portrait,
            margin: pw.EdgeInsets.zero,
            build:
                (context) => pw.SizedBox.expand(
                  child: pw.FittedBox(
                    fit: pw.BoxFit.fill,
                    child: pw.Image(imageProvider),
                  ),
                ),
          ),
        );

        await Printing.sharePdf(
          bytes: await pdf.save(),
          filename: 'document.pdf',
        );

        // Khôi phục trạng thái chọn
        for (int i = 0; i < images.length; i++) {
          final state =
              (images[i].key as GlobalKey).currentState
                  as _DraggableImageState?;
          if (state != null && selectedStates[i]) {
            state.setState(() => state.isSelected = true);
          }
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
      final state =
          (img.key as GlobalKey).currentState as _DraggableImageState?;
      if (state != null) {
        data.add({
          "id": UniqueKey().toString(),
          "idTaiLieu": widget.idTaiLieu,
          "loaiKy": img.loaiKy, // 1/2/3
          "x": state.left,
          "y": state.top,
          "idNguoiKy": widget.idNguoiKy,
          "chuKySo": img.loaiKy == 3 ? signatureValue : null,
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

  Future<Uint8List?> _captureWidget() async {
    try {
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

  // ===== Ký hash =====
  Future<void> signing({double top = 500, double left = 500}) async {
    String value = widget.idNguoiKy + widget.idTaiLieu;
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
      Uint8List? imgBytes = await _captureWidget(); // hàm này trả Uint8List
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return Center(
            child: SizedBox(
              width: 960,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Thanh tiêu đề
                  Container(
                    // height: 800 * (297 / 210),
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
                        const Icon(Icons.description, color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        const Text(
                          'Soạn & Ký Tài Liệu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
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
                          icon: const Icon(Icons.close, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),

                  // Nội dung cuộn được
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Stack(
                          children: [
                            Positioned(
                              top:
                                  (MediaQuery.of(context).size.height - 100) /
                                  2,
                              left:
                                  (MediaQuery.of(context).size.width - 200) / 2,
                              child: RepaintBoundary(
                                key: _captureKey,
                                child: buildSignatureValidContainer(
                                  widget.tenNguoiKy,
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
                                  A4Canvas(
                                    marginsMm: const EdgeInsets.all(20),
                                    scale: 1.2,
                                    maxWidth: 800,
                                    maxHeight: 800 * (297 / 210),
                                    child: widget.contractType,
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

                  // Thanh nút ký & xác nhận
                  if (widget.isShowKy)
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildFab(
                                Icons.edit,
                                'Ký nháy',
                                Colors.orange,
                                () => _addFirstSignatureFromList(
                                  1,
                                  top: screenHeight / 2,
                                  left: (screenWidth - 200) / 4,
                                ),
                              ),
                              _buildFab(
                                Icons.brush,
                                'Ký',
                                Colors.green,
                                () => _addFirstSignatureFromList(
                                  2,
                                  top: screenHeight / 2,
                                  left: (screenWidth - 200) / 4,
                                ),
                              ),
                              _buildFab(
                                Icons.vpn_key,
                                'Ký số',
                                Colors.blue,
                                () async => await signing(
                                  top: screenHeight / 2,
                                  left: (screenWidth - 200) / 4,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, color: Colors.white),
                            label: Text(
                              "Hủy",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 14),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            onPressed: _submitting ? null : _confirmSignatures,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget buildSignatureValidContainer(String name, String date) {
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
              "Ký bởi: $name",
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
  final int loaiKy; // 1: ký nháy, 2: ký, 3: ký số
  final double top;
  final double left;
  final bool isEdit;

  const DraggableImage({
    super.key,
    required this.bytes,
    required this.loaiKy,
    required this.top,
    required this.left,
    required this.isEdit,
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
