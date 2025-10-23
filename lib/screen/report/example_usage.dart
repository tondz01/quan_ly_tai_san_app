import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/report/widget/bien_ban_kiem_ke_tai_san_co_dinh_screen.dart';

class ExampleUsage extends StatelessWidget {
  const ExampleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ví dụ sử dụng')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const BienBanKiemKeTaiSanCoDinhScreen(
                      idDonVi: 'CD1', // ID đơn vị từ API
                      tenDonVi: 'Công ty ABC', // Tên đơn vị
                      denNgay: '31/12/2024', // Đến ngày
                    ),
              ),
            );
          },
          child: const Text('Mở Biên bản kiểm kê tài sản cố định'),
        ),
      ),
    );
  }
}
