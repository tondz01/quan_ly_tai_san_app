import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/bloc/capital_source_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/models/capital_source.dart';

class CapitalSourceBloc extends Bloc<CapitalSourceEvent, CapitalSourceState> {
  List<CapitalSource> _allCapitalSources = [];
  CapitalSourceBloc() : super(CapitalSourceInitial()) {
    on<LoadCapitalSources>((event, emit) {
      _allCapitalSources = List.from(event.capitalSources);
      emit(CapitalSourceLoaded(_allCapitalSources));
    });
    on<SearchCapitalSource>((event, emit) {
      final searchLower = event.keyword.toLowerCase();
      final filtered =
          _allCapitalSources.where((item) {
            bool nameMatch = AppUtility.fuzzySearch(
              item.name.toLowerCase(),
              searchLower,
            );

            bool staffIdMatch = item.code.toLowerCase().contains(searchLower);
            bool departmentGroup = item.note.toLowerCase().contains(
              searchLower,
            );

            return nameMatch || staffIdMatch || departmentGroup;
          }).toList();
      emit(CapitalSourceLoaded(filtered));
    });
    on<AddCapitalSource>((event, emit) {
      if (state is CapitalSourceLoaded) {
        final capitalSources = List<CapitalSource>.from(
          (state as CapitalSourceLoaded).capitalSources,
        );
        capitalSources.add(event.capitalSource);
        emit(CapitalSourceLoaded(capitalSources));
      } else {
        emit(CapitalSourceLoaded([event.capitalSource]));
      }
    });
    on<UpdateCapitalSource>((event, emit) {
      if (state is CapitalSourceLoaded) {
        final capitalSources = List<CapitalSource>.from(
          (state as CapitalSourceLoaded).capitalSources,
        );
        final index = capitalSources.indexWhere(
          (element) => element.code == event.capitalSource.code,
        );
        if (index != -1) {
          capitalSources[index] = event.capitalSource;
        }
        emit(CapitalSourceLoaded(capitalSources));
      }
    });
    on<DeleteCapitalSource>((event, emit) {
      if (state is CapitalSourceLoaded) {
        final capitalSources = List<CapitalSource>.from(
          (state as CapitalSourceLoaded).capitalSources,
        );
        capitalSources.removeWhere(
          (element) => element.code == event.capitalSource.code,
        );
        emit(CapitalSourceLoaded(capitalSources));
      }
    });
  }
}
