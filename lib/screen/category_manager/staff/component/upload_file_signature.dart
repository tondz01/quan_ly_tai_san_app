import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

Future<Map<String, dynamic>?> uploadFileSignature(
  BuildContext context,
  String fileName,
  String filePath,
  Uint8List fileBytes,
) async {
  // Web platform validation
  if (kIsWeb) {
    if (fileName.isEmpty || fileBytes.isEmpty) {
      SGLog.warning("Upload chữ ký", "Web: fileName or fileBytes is empty");
      return null;
    }
  } else {
    // Mobile/Desktop platform validation
    if (filePath.isEmpty) {
      SGLog.warning("Upload chữ ký", "Mobile: filePath is empty");
      return null;
    }
  }
  try {
    final result =
        kIsWeb
            ? await AssetTransferRepository().uploadFileBytes(
              fileName,
              fileBytes,
            )
            : await AssetTransferRepository().uploadFile(filePath);
    final statusCode = result['status_code'] as int? ?? 0;
    if (statusCode >= 200 && statusCode < 300) {
      if (context.mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Tệp "$fileName" đã được tải lên thành công'),
        //     backgroundColor: Colors.green.shade600,
        //   ),
        // );
      }
      return result['data'];
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tải lên thất bại (mã $statusCode)'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
      return null;
    }
  } catch (e) {
    SGLog.error("Upload chữ ký", 'Error uploading file: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải lên tệp: ${e.toString()}'),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return null;
    }
  }
  return null;
}
