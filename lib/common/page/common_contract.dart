import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;

class CommonContract extends StatefulWidget {
  final Widget contractType;
  final List<String> signatureList;

  const CommonContract({
    super.key,
    required this.contractType,
    required this.signatureList,
  });

  @override
  State<CommonContract> createState() => _CommonContractState();
}

class _CommonContractState extends State<CommonContract> {
  final GlobalKey _contractKey = GlobalKey();
  List<DraggableImage> images = [];

  /// Chọn ảnh từ máy
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.bytes != null) {
      Uint8List bytes = result.files.single.bytes!;
      _addImage(bytes);
    }
  }

  /// Thêm ảnh từ link (trong signatureList)
  Future<void> _pickImageFromSignatureList(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _addImage(response.bodyBytes);
      } else {
        debugPrint("Không tải được ảnh: $url");
      }
    } catch (e) {
      debugPrint("Lỗi tải ảnh: $e");
    }
  }

  /// Thêm ảnh vào màn hình
  void _addImage(Uint8List bytes) {
    setState(() {
      images.add(DraggableImage(key: GlobalKey(), bytes: bytes));
    });
  }

  /// Xuất PDF (ẩn nút xóa/zoom khi chụp, định dạng ngang, có loading)
  Future<void> _exportToPdf() async {
    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Lưu trạng thái selected của ảnh
      final selectedStates =
          images.map((img) {
            final state =
                (img.key as GlobalKey).currentState as _DraggableImageState?;
            return state?.isSelected ?? false;
          }).toList();

      // Bỏ chọn toàn bộ ảnh
      for (var img in images) {
        final state =
            (img.key as GlobalKey).currentState as _DraggableImageState?;
        if (state != null && state.isSelected) {
          state.setState(() {
            state.isSelected = false;
          });
        }
      }

      await Future.delayed(const Duration(milliseconds: 50)); // chờ UI update

      final pdf = pw.Document();
      final boundary =
          _contractKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();

        final imageProvider = pw.MemoryImage(pngBytes);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4.landscape, // Xuất dạng ngang
            build: (context) => pw.Center(child: pw.Image(imageProvider)),
          ),
        );

        await Printing.sharePdf(
          bytes: await pdf.save(),
          filename: 'document.pdf',
        );
      }

      // Khôi phục trạng thái selected cũ
      for (int i = 0; i < images.length; i++) {
        final state =
            (images[i].key as GlobalKey).currentState as _DraggableImageState?;
        if (state != null && selectedStates[i]) {
          state.setState(() {
            state.isSelected = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Lỗi xuất PDF: $e');
    } finally {
      // Tắt loading
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: 842,
                  height: 595,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                  ),
                  margin: const EdgeInsets.all(16),
                  child: RepaintBoundary(
                    key: _contractKey,
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.white,
                          child: widget.contractType,
                        ),
                        ...images,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_photo_alternate),
                    onPressed: _pickImage,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.signatureList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap:
                                () => _pickImageFromSignatureList(
                                  widget.signatureList[index],
                                ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Image.network(
                                widget.signatureList[index],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => const Icon(
                                      Icons.broken_image,
                                      size: 40,
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          right: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: _exportToPdf,
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                label: const Text('Xuất PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // màu PDF
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(height: 10), // khoảng cách giữa 2 nút
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close, color: Colors.white),
                label: const Text('Đóng'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // màu Đóng
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DraggableImage extends StatefulWidget {
  final Uint8List bytes;

  const DraggableImage({super.key, required this.bytes});

  @override
  State<DraggableImage> createState() => _DraggableImageState();
}

class _DraggableImageState extends State<DraggableImage> {
  double top = 100;
  double left = 100;
  double scale = 1.0;
  bool isSelected = false;
  Offset? lastPanPosition;
  Offset? lastScaleDragPosition;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        onPanStart: (details) {
          lastPanPosition = details.globalPosition;
        },
        onPanUpdate: (details) {
          setState(() {
            final delta = details.globalPosition - lastPanPosition!;
            left += delta.dx;
            top += delta.dy;
            lastPanPosition = details.globalPosition;
          });
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Transform.scale(
              scale: scale,
              alignment: Alignment.topLeft,
              child: Image.memory(widget.bytes, width: 150),
            ),
            if (isSelected) ...[
              // Nút xóa
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
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
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              ),
              // Nút zoom
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (details) {
                    lastScaleDragPosition = details.globalPosition;
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      final delta =
                          details.globalPosition - lastScaleDragPosition!;
                      final deltaScale = (delta.dx + delta.dy) / 200;
                      scale = (scale + deltaScale).clamp(0.5, 5.0);
                      lastScaleDragPosition = details.globalPosition;
                    });
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.open_with,
                      color: Colors.white,
                      size: 16,
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
