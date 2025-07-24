import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/bloc/capital_source_state.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/models/capital_source.dart';

class CapitalSourceBloc extends Bloc<CapitalSourceEvent, CapitalSourceState> {
  CapitalSourceBloc() : super(CapitalSourceInitial()) {
    on<LoadCapitalSources>((event, emit) {
      emit(CapitalSourceLoaded(List.from(event.capitalSources)));
    });
    on<AddCapitalSource>((event, emit) {
      if (state is CapitalSourceLoaded) {
        final capitalSources = List<CapitalSource>.from((state as CapitalSourceLoaded).capitalSources);
        capitalSources.add(event.capitalSource);
        emit(CapitalSourceLoaded(capitalSources));
      } else {
        emit(CapitalSourceLoaded([event.capitalSource]));
      }
    });
    on<UpdateCapitalSource>((event, emit) {
      if (state is CapitalSourceLoaded) {
        final capitalSources = List<CapitalSource>.from((state as CapitalSourceLoaded).capitalSources);
        final index = capitalSources.indexWhere((element) => element.code == event.capitalSource.code);
        if (index != -1) {
          capitalSources[index] = event.capitalSource;
        }
        emit(CapitalSourceLoaded(capitalSources));
      }
    });
    on<DeleteCapitalSource>((event, emit) {
      if (state is CapitalSourceLoaded) {
        final capitalSources = List<CapitalSource>.from((state as CapitalSourceLoaded).capitalSources);
        capitalSources.removeWhere((element) => element.code == event.capitalSource.code);
        emit(CapitalSourceLoaded(capitalSources));
      }
    });
  }
} 