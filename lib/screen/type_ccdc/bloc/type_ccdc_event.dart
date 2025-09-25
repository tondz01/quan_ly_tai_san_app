import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';

abstract class TypeCcdcEvent extends Equatable {
  const TypeCcdcEvent();
}

class GetListTypeCcdcEvent extends TypeCcdcEvent {
  final BuildContext context;

  const GetListTypeCcdcEvent(this.context);

  @override
  List<Object?> get props => [context];
}

class CreateTypeCcdcEvent extends TypeCcdcEvent {
  final BuildContext context;
  final TypeCcdc params;

  const CreateTypeCcdcEvent(this.context, this.params);

  @override
  List<Object?> get props => [context, params];
}

class CreateTypeCcdcBatchEvent extends TypeCcdcEvent {
  final List<TypeCcdc> params;

  const CreateTypeCcdcBatchEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateTypeCcdcEvent extends TypeCcdcEvent {
  final BuildContext context;
  final TypeCcdc params;
  final String id;

  const UpdateTypeCcdcEvent(this.context, this.params, this.id);

  @override
  List<Object?> get props => [context, params, id];
}

class DeleteTypeCcdcEvent extends TypeCcdcEvent {
  final BuildContext context;
  final String id;

  const DeleteTypeCcdcEvent(this.context, this.id);

  @override
  List<Object?> get props => [context, id];
}

class DeleteTypeCcdcBatchEvent extends TypeCcdcEvent {
  final List<String> ids;

  const DeleteTypeCcdcBatchEvent(this.ids);

  @override
  List<Object?> get props => [ids];
}
