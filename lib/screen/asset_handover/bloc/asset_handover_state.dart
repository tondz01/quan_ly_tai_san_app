// bloc/dieu_dong_tai_san_state.dart
import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/dieu_dong_tai_san.dart';
abstract class DieuDongTaiSanState extends Equatable {
  const DieuDongTaiSanState();

  @override
  List<Object?> get props => [];
}

class DieuDongTaiSanInitialState extends DieuDongTaiSanState {}

class DieuDongTaiSanLoadingState extends DieuDongTaiSanState {}

class DieuDongTaiSanLoadingDismissState extends DieuDongTaiSanState {}

class GetListDieuDongTaiSanSuccessState extends DieuDongTaiSanState {
  final List<DieuDongTaiSan> data;

  const GetListDieuDongTaiSanSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListDieuDongTaiSanFailedState extends DieuDongTaiSanState {
  final String title;
  final int? code;
  final String message;

  const GetListDieuDongTaiSanFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object?> get props => [title, code, message];
}
