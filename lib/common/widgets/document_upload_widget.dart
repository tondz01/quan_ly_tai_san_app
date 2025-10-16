import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DocumentUploadWidget extends StatefulWidget {
  final bool isEditing;
  final String? selectedFileName;
  final String? selectedFilePath;
  final Map<String, bool> validationErrors;
  final Function(String? fileName, String? filePath, Uint8List? fileBytes)
  onFileSelected;
  final Function()? onUpload;
  final bool isUploading;
  final String label;
  final String? errorMessage;
  final String? hintText;
  final List<String> allowedExtensions;
  final bool isInsertData;
  final Widget? document;
  final Future<Uint8List?> Function(Uint8List bytes, String fileName)?
  convertDocToPdf;

  const DocumentUploadWidget({
    super.key,
    this.isEditing = true,
    this.selectedFileName,
    this.selectedFilePath,
    this.validationErrors = const {},
    required this.onFileSelected,
    this.onUpload,
    this.isUploading = false,
    this.label = 'Tài liệu',
    this.errorMessage,
    this.hintText,
    this.allowedExtensions = const ['doc', 'docx', 'pdf'],
    this.isInsertData = false,
    this.document,
    this.convertDocToPdf,
  });

  @override
  State<DocumentUploadWidget> createState() => _DocumentUploadWidgetState();
}

class _DocumentUploadWidgetState extends State<DocumentUploadWidget> {
  @override
  Widget build(BuildContext context) {
    bool hasError = widget.validationErrors['document'] == true;
    return widget.isInsertData
        ? _buildInsertData()
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasError ? Colors.red : Colors.grey.shade200,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color:
                                  hasError ? Colors.red : Colors.grey.shade300,
                            ),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.description,
                                color: Colors.green.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  widget.selectedFileName ?? 'Chưa chọn tệp',
                                  style: TextStyle(
                                    color:
                                        widget.selectedFileName != null
                                            ? Colors.black
                                            : Colors.grey.shade600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if (widget.selectedFileName != null)
                                InkWell(
                                  onTap: () {
                                    widget.onFileSelected(null, null, null);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.grey.shade600,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: widget.isEditing ? _selectDocument : null,
                        icon: const Icon(Icons.upload_file, size: 18),
                        label: const Text('Chọn tệp'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green.shade700,
                          disabledBackgroundColor: Colors.grey.shade400,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                      ),
                      if (widget.onUpload != null) ...[
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed:
                              (widget.selectedFileName != null &&
                                      widget.isEditing &&
                                      !widget.isUploading)
                                  ? widget.onUpload
                                  : null,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF21A366),
                            disabledBackgroundColor: Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          child:
                              widget.isUploading
                                  ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text('Tải lên'),
                        ),
                      ],
                    ],
                  ),
                  if (hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        widget.errorMessage ?? 'Tài liệu là bắt buộc',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      widget.hintText ??
                          'Định dạng hỗ trợ: ${widget.allowedExtensions.join(', ')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  widget.document != null
                      ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: widget.document,
                      )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ],
        );
  }

  Future<void> _selectDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.allowedExtensions,
        withData: true, // Thay đổi thành true để lấy file bytes
        withReadStream: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final fileName = file.name;
        final lowerName = fileName.toLowerCase();
        final isDoc = lowerName.endsWith('.doc') || lowerName.endsWith('.docx');

        if (isDoc && file.bytes != null && widget.convertDocToPdf != null) {
          try {
            final pdfBytes = await widget.convertDocToPdf!(
              file.bytes!,
              fileName,
            );
            if (pdfBytes != null) {
              final newName = fileName.replaceAll(
                RegExp(r'\.docx?$', caseSensitive: false),
                '.pdf',
              );
              widget.onFileSelected(newName, file.path, pdfBytes);
              return;
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Không thể chuyển đổi sang PDF: ${e.toString()}',
                  ),
                  backgroundColor: Colors.red.shade600,
                ),
              );
            }
          }
        }

        widget.onFileSelected(file.name, file.path, file.bytes);
      }
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi chọn tệp: ${e.message}'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    } catch (e) {
      log('Error selecting file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể chọn tệp: ${e.toString()}'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  Widget _buildInsertData() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ElevatedButton.icon(
        onPressed: widget.isEditing ? _selectDocument : null,
        icon: const Icon(Icons.upload_file, size: 18),
        label: Text(
          widget.selectedFileName != null ? 'Submit' : 'Chọn file data',
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade700,
          disabledBackgroundColor: Colors.grey.shade400,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }
}
