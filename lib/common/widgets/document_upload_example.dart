import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';

class DocumentUploadExample extends StatefulWidget {
  const DocumentUploadExample({super.key});

  @override
  State<DocumentUploadExample> createState() => _DocumentUploadExampleState();
}

class _DocumentUploadExampleState extends State<DocumentUploadExample> {
  String? selectedFileName;
  String? selectedFilePath;
  bool isUploading = false;
  Map<String, bool> validationErrors = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Upload Widget Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ví dụ sử dụng DocumentUploadWidget',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Ví dụ 1: Upload tài liệu Word
            const Text(
              '1. Upload tài liệu Word (.doc, .docx)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            DocumentUploadWidget(
              isEditing: true,
              selectedFileName: selectedFileName,
              selectedFilePath: selectedFilePath,
              validationErrors: validationErrors,
              onFileSelected: (fileName, filePath) {
                setState(() {
                  selectedFileName = fileName;
                  selectedFilePath = filePath;
                  if (validationErrors.containsKey('document')) {
                    validationErrors.remove('document');
                  }
                });
              },
              onUpload: _uploadDocument,
              isUploading: isUploading,
              label: 'Tài liệu Quyết định',
              errorMessage: 'Tài liệu quyết định là bắt buộc',
              hintText: 'Định dạng hỗ trợ: .doc, .docx (Microsoft Word)',
              allowedExtensions: ['doc', 'docx'],
            ),
            
            const SizedBox(height: 30),
            
            // Ví dụ 2: Upload PDF
            const Text(
              '2. Upload tài liệu PDF',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            DocumentUploadWidget(
              isEditing: true,
              selectedFileName: null,
              selectedFilePath: null,
              validationErrors: const {},
              onFileSelected: (fileName, filePath) {
                print('PDF selected: $fileName, $filePath');
              },
              onUpload: null, // Không có nút upload
              isUploading: false,
              label: 'Tài liệu PDF',
              hintText: 'Chỉ hỗ trợ định dạng PDF',
              allowedExtensions: ['pdf'],
            ),
            
            const SizedBox(height: 30),
            
            // Ví dụ 3: Upload hình ảnh
            const Text(
              '3. Upload hình ảnh',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            DocumentUploadWidget(
              isEditing: true,
              selectedFileName: null,
              selectedFilePath: null,
              validationErrors: const {},
              onFileSelected: (fileName, filePath) {
                print('Image selected: $fileName, $filePath');
              },
              onUpload: null,
              isUploading: false,
              label: 'Hình ảnh',
              hintText: 'Hỗ trợ: JPG, PNG, GIF',
              allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
            ),
            
            const SizedBox(height: 30),
            
            // Ví dụ 4: Chế độ chỉ xem (không edit)
            const Text(
              '4. Chế độ chỉ xem (không edit)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            DocumentUploadWidget(
              isEditing: false,
              selectedFileName: 'document_example.docx',
              selectedFilePath: '/path/to/document_example.docx',
              validationErrors: const {},
              onFileSelected: (fileName, filePath) {
                // Không làm gì trong chế độ chỉ xem
              },
              onUpload: null,
              isUploading: false,
              label: 'Tài liệu (Chỉ xem)',
              hintText: 'Không thể chỉnh sửa trong chế độ này',
              allowedExtensions: ['doc', 'docx'],
            ),
            
            const SizedBox(height: 30),
            
            // Nút để test validation
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      validationErrors['document'] = true;
                    });
                  },
                  child: const Text('Test Validation Error'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      validationErrors.clear();
                    });
                  },
                  child: const Text('Clear Validation'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadDocument() async {
    setState(() {
      isUploading = true;
    });

    try {
      // Simulate upload delay
      await Future.delayed(const Duration(seconds: 2));
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tệp "$selectedFileName" đã được tải lên thành công'),
          backgroundColor: Colors.green.shade600,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải lên tệp: ${e.toString()}'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }
}

/*
CÁCH SỬ DỤNG DOCUMENTUPLOADWIDGET:

1. Import widget:
   import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';

2. Sử dụng cơ bản:
   DocumentUploadWidget(
     isEditing: true,
     selectedFileName: fileName,
     selectedFilePath: filePath,
     validationErrors: validationErrors,
     onFileSelected: (fileName, filePath) {
       // Xử lý khi file được chọn
     },
     onUpload: uploadFunction,
     isUploading: isUploading,
   )

3. Các tham số tùy chọn:
   - label: Tiêu đề của widget
   - errorMessage: Thông báo lỗi tùy chỉnh
   - hintText: Gợi ý định dạng file
   - allowedExtensions: Danh sách định dạng được phép
   - onUpload: Function để upload file (có thể null)

4. Các tính năng:
   - Chọn file với validation
   - Upload file với loading indicator
   - Hiển thị lỗi validation
   - Hỗ trợ nhiều định dạng file
   - Chế độ chỉ xem (isEditing = false)
   - Tùy chỉnh giao diện

5. Validation:
   - Tự động clear validation error khi file được chọn
   - Hiển thị thông báo lỗi tùy chỉnh
   - Border đỏ khi có lỗi

6. Upload:
   - Nút upload chỉ hiển thị khi có file được chọn
   - Loading indicator khi đang upload
   - Disable nút khi đang upload
*/ 