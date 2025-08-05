import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/models/capital_source.dart';

abstract class CapitalSourceState extends Equatable {
  const CapitalSourceState();
  @override
  List<Object?> get props => [];
}

class CapitalSourceInitial extends CapitalSourceState {}

class CapitalSourceLoaded extends CapitalSourceState {
  final List<NguonKinhPhi> capitalSources;
  const CapitalSourceLoaded(this.capitalSources);
  @override
  List<Object?> get props => [capitalSources];
}

class CapitalSourceError extends CapitalSourceState {
  final String message;
  const CapitalSourceError(this.message);
  @override
  List<Object?> get props => [message];
} 