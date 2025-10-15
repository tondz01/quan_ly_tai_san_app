import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/download_file.dart';

class SgDownloadFile extends StatelessWidget {
  final String url;
  final String? name;
  const SgDownloadFile({super.key, required this.url, this.name});

  @override
  Widget build(BuildContext context) {
    String name = this.name ?? 'File';
    return url.isNotEmpty
        ? InkWell(
          onTap: () {
            downloadFile(url, name, context);
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.green.shade200, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.file_download_outlined,
                  size: 14,
                  color: Colors.green.shade700,
                ),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        )
        : SizedBox.shrink();
  }
}
