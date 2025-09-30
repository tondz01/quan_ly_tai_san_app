import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';

abstract class UnitState extends Equatable {
  const UnitState();

  @override
  List<Object?> get props => [];
}

class UnitInitialState extends UnitState {}

class UnitLoadingState extends UnitState {}

class UnitLoadingDismissState extends UnitState {}

class GetListUnitSuccessState extends UnitState {
  final List<UnitDto> data;

  const GetListUnitSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateUnitSuccessState extends UnitState {

  const CreateUnitSuccessState();

  @override
  List<Object> get props => [];
}

class GetListUnitFailedState extends UnitState {
  final String title;
  final int? code;
  final String message;

  const GetListUnitFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

class CreateUnitFailedState extends UnitState {
  final String title;
  final int? code;
  final String message;

  const CreateUnitFailedState({
    required this.title,
    this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code!, message];
}

//UPDATE
class UpdateUnitSuccessState extends UnitState {
  final String data;

  const UpdateUnitSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

//DELETE
class DeleteUnitSuccessState extends UnitState {
  final String data;

  const DeleteUnitSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class PutPostDeleteFailedState extends UnitState {
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
