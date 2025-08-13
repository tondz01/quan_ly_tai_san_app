import 'package:equatable/equatable.dart';

import '../model/dieu_dong_tai_san_dto.dart';

abstract class DieuDongTaiSanState extends Equatable {
  const DieuDongTaiSanState();

  @override
  List<Object?> get props => [];
}

class DieuDongTaiSanInitialState extends DieuDongTaiSanState {}

class DieuDongTaiSanLoadingState extends DieuDongTaiSanState {}

class DieuDongTaiSanLoadingDismissState extends DieuDongTaiSanState {}

class GetListDieuDongTaiSanSuccessState extends DieuDongTaiSanState {
  final List<DieuDongTaiSanDto> data;

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
  List<Object> get props => [title, code!, message];
}
