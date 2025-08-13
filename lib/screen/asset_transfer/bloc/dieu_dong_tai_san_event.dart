import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
abstract class DieuDongTaiSanEvent extends Equatable {
  const DieuDongTaiSanEvent();
}

class GetListDieuDongTaiSanEvent extends DieuDongTaiSanEvent {
  final BuildContext context;
  final int typeAssetTransfer;
  final String idCongTy;

  const GetListDieuDongTaiSanEvent(this.context, this.typeAssetTransfer, this.idCongTy);

  @override
  List<Object?> get props => [context, typeAssetTransfer];
}