import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/page/contract_page.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ContractPage.assetMovePage(
          DieuDongTaiSanDto(
            id: "DDTS-1754671065959",
            soQuyetDinh: "SCT-1754671064747",
            tenPhieu: "s",
            idDonViGiao: "PB004",
            tenDonViGiao: "Phòng Kế toán",
            idDonViNhan: "PB004",
            tenDonViNhan: "Phòng Kế toán",
            idDonViDeNghi: "",
            tenDonViDeNghi: null,
            idPhongBanXemPhieu: "",
            tenPhongBanXemPhieu: null,
            idNguoiDeNghi: "NV003",
            tenNguoiDeNghi: "Nguyen Van A",
            idTrinhDuyetCapPhong: "NV003",
            tenTrinhDuyetCapPhong: "Nguyen Van A",
            idTrinhDuyetGiamDoc: "NV003",
            tenTrinhDuyetGiamDoc: "Nguyen Van A",
            idNhanSuXemPhieu: "",
            tenNhanSuXemPhieu: null,
            nguoiLapPhieuKyNhay: true,
            quanTrongCanXacNhan: true,
            phoPhongXacNhan: true,
            tggnTuNgay: "2025-08-08T00:00:00.000+00:00",
            tggnDenNgay: "2025-08-08T00:00:00.000+00:00",
            diaDiemGiaoNhan: "",
            noiNhan: "",
            trangThai: 1,
            idCongTy: "ct001",
            ngayTao: "2025-08-08T23:37:45.000+00:00",
            ngayCapNhat: null,
            nguoiTao: "Nguyen Van A",
            nguoiCapNhat: "Nguyen Van A",
            coHieuLuc: true,
            loai: 1,
            isActive: true,
            trichYeu: "s",
            duongDanFile: "/root/PM-QL-tai-san/quanlytaisan/uploads/Bảng quy trình may sản phẩm áo sơ mi mã 5 (1).docx",
            tenFile: "Bảng quy trình may sản phẩm áo sơ mi mã 5 (1).docx",
            ngayKy: null,
          ),
        ),
      ),
    );
  }
}
