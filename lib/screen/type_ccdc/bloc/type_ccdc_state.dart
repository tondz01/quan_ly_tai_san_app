import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';

abstract class TypeCcdcState extends Equatable {
  const TypeCcdcState();

  @override
  List<Object?> get props => [];
}

class TypeCcdcInitialState extends TypeCcdcState {}

class TypeCcdcLoadingState extends TypeCcdcState {}

class TypeCcdcLoadingDismissState extends TypeCcdcState {}

class GetListTypeCcdcSuccessState extends TypeCcdcState {
  final List<TypeCcdc> data;

  const GetListTypeCcdcSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateTypeCcdcSuccessState extends TypeCcdcState {
  final String data;

  const CreateTypeCcdcSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class GetListTypeCcdcFailedState extends TypeCcdcState {
  final String title;
  final int? code;
  final String message;

  const GetListTypeCcdcFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

class CreateTypeCcdcFailedState extends TypeCcdcState {
  final String title;
  final int? code;
  final String message;

  const CreateTypeCcdcFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

class UpdateTypeCcdcSuccessState extends TypeCcdcState {
  final String data;

  const UpdateTypeCcdcSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class DeleteTypeCcdcSuccessState extends TypeCcdcState {
  final String data;

  const DeleteTypeCcdcSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends TypeCcdcState {
  final String title;
  final int? code;
  final String message;

  const PutPostDeleteFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}


