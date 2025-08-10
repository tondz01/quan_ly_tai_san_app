// bloc/dieu_dong_tai_san_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class DieuDongTaiSanEvent extends Equatable {
  const DieuDongTaiSanEvent();
}

/// Lấy danh sách điều động tài sản
class GetListDieuDongTaiSanEvent extends DieuDongTaiSanEvent {
  final BuildContext context;
  final String idCongTy;

  const GetListDieuDongTaiSanEvent({
    required this.context,
    required this.idCongTy,
  });

  @override
  List<Object?> get props => [context, idCongTy];
}
