import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/models/capital_source.dart';

abstract class CapitalSourceEvent extends Equatable {
  const CapitalSourceEvent();
  @override
  List<Object?> get props => [];
}

class LoadCapitalSources extends CapitalSourceEvent {
  final List<CapitalSource> capitalSources;
  const LoadCapitalSources(this.capitalSources);
  @override
  List<Object?> get props => [capitalSources];
}

class AddCapitalSource extends CapitalSourceEvent {
  final CapitalSource capitalSource;
  const AddCapitalSource(this.capitalSource);
  @override
  List<Object?> get props => [capitalSource];
}

class UpdateCapitalSource extends CapitalSourceEvent {
  final CapitalSource capitalSource;
  const UpdateCapitalSource(this.capitalSource);
  @override
  List<Object?> get props => [capitalSource];
}

class DeleteCapitalSource extends CapitalSourceEvent {
  final CapitalSource capitalSource;
  const DeleteCapitalSource(this.capitalSource);
  @override
  List<Object?> get props => [capitalSource];
}

class SearchCapitalSource extends CapitalSourceEvent {
  final String keyword;
  const SearchCapitalSource(this.keyword);
  @override
  List<Object?> get props => [keyword];
} 